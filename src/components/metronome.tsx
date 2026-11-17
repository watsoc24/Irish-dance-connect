"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { DANCES, LEVELS, getDance, tempoFor, type DanceSlug, type LevelSlug } from "@/lib/practice-music";

// Dance-driven metronome (spec: specs/practice-music-and-training-v1.md,
// Part B). The click is generated live with the Web Audio API — no audio
// files, no downloads. The AudioContext is created/resumed only inside
// the Start tap handler, as iPhone Safari requires a user gesture.
//
// This component holds the shared dance + level state for /practice:
// its selectors update the URL (?dance=&level=) so the page's entries
// stay in step, and it adopts new initial values when the page's level
// picker (or a fundamentals link) changes them.

const MIN_BPM = 60;
const MAX_BPM = 150;
const COUNT_IN_BARS = 8;
const RUN_LENGTHS = [16, 32, 40, 48] as const;
const FALLBACK_BPM = 113;

function clampBpm(n: number): number {
  return Math.min(MAX_BPM, Math.max(MIN_BPM, Math.round(n)));
}

interface MetronomeProps {
  initialDance: DanceSlug;
  initialLevel: LevelSlug;
  /** Optional ?bpm= override — the starting BPM only, clamped 60–150. */
  initialBpm?: number;
}

export function Metronome({ initialDance, initialLevel, initialBpm }: MetronomeProps) {
  const router = useRouter();
  const [dance, setDance] = useState<DanceSlug>(initialDance);
  const [level, setLevel] = useState<LevelSlug>(initialLevel);
  const [slowPct, setSlowPct] = useState(100);
  const [bpm, setBpm] = useState<number>(() => initialBpm ?? tempoFor(initialDance, initialLevel) ?? FALLBACK_BPM);
  const [adjusted, setAdjusted] = useState(false);
  const [countIn, setCountIn] = useState(false);
  const [runLength, setRunLength] = useState<number>(32);
  const [running, setRunning] = useState(false);
  const [phase, setPhase] = useState<"count-in" | "run">("run");
  const [currentBeat, setCurrentBeat] = useState(-1);
  const [currentBar, setCurrentBar] = useState(0);

  const target = tempoFor(dance, level);
  const beatsPerBar = getDance(dance)?.beatsPerBar ?? 4;

  // --- Playback engine (refs so the scheduler never reads stale state) ---
  const ctxRef = useRef<AudioContext | null>(null);
  const timerRef = useRef<number | null>(null);
  const visualTimersRef = useRef<number[]>([]);
  const nextNoteTimeRef = useRef(0);
  const beatRef = useRef(0);
  const barRef = useRef(1);
  const phaseRef = useRef<"count-in" | "run">("run");
  const finishedRef = useRef(false);
  const bpmRef = useRef(bpm);
  const beatsPerBarRef = useRef(beatsPerBar);
  const runLengthRef = useRef(runLength);
  const slowPctRef = useRef(slowPct);

  useEffect(() => {
    bpmRef.current = bpm;
  }, [bpm]);
  useEffect(() => {
    beatsPerBarRef.current = beatsPerBar;
  }, [beatsPerBar]);
  useEffect(() => {
    runLengthRef.current = runLength;
  }, [runLength]);
  useEffect(() => {
    slowPctRef.current = slowPct;
  }, [slowPct]);

  const stop = useCallback(() => {
    if (timerRef.current !== null) {
      window.clearInterval(timerRef.current);
      timerRef.current = null;
    }
    visualTimersRef.current.forEach((id) => window.clearTimeout(id));
    visualTimersRef.current = [];
    finishedRef.current = false;
    setRunning(false);
    setCurrentBeat(-1);
    setCurrentBar(0);
    const ctx = ctxRef.current;
    if (ctx && ctx.state === "running") void ctx.suspend();
  }, []);

  // Adopt new initial values when the URL changes underneath us (page
  // level picker, browser back/forward). Our own selector changes also
  // update the URL; they set the same values locally first, so adopting
  // them again here is a no-op apart from stopping playback.
  const prevInitialRef = useRef({ initialDance, initialLevel, initialBpm });
  useEffect(() => {
    const prev = prevInitialRef.current;
    if (prev.initialDance === initialDance && prev.initialLevel === initialLevel && prev.initialBpm === initialBpm) {
      return;
    }
    prevInitialRef.current = { initialDance, initialLevel, initialBpm };
    stop();
    setDance(initialDance);
    setLevel(initialLevel);
    const t = tempoFor(initialDance, initialLevel);
    setBpm(initialBpm ?? (t !== null ? Math.round((t * slowPctRef.current) / 100) : bpmRef.current));
    setAdjusted(false);
  }, [initialDance, initialLevel, initialBpm, stop]);

  // Tear down audio on unmount.
  useEffect(
    () => () => {
      if (timerRef.current !== null) window.clearInterval(timerRef.current);
      visualTimersRef.current.forEach((id) => window.clearTimeout(id));
      const ctx = ctxRef.current;
      if (ctx) void ctx.close();
    },
    [],
  );

  const scheduleClick = useCallback((time: number, accent: boolean) => {
    const ctx = ctxRef.current;
    if (!ctx) return;
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.type = "sine";
    osc.frequency.setValueAtTime(accent ? 1200 : 800, time);
    gain.gain.setValueAtTime(accent ? 0.6 : 0.35, time);
    gain.gain.exponentialRampToValueAtTime(0.001, time + 0.06);
    osc.connect(gain);
    gain.connect(ctx.destination);
    osc.start(time);
    osc.stop(time + 0.07);
  }, []);

  // Lookahead scheduler: a 25ms interval schedules clicks ~0.1s ahead,
  // so the tempo stays steady even if the UI thread hiccups.
  const tick = useCallback(() => {
    const ctx = ctxRef.current;
    if (!ctx) return;
    while (!finishedRef.current && nextNoteTimeRef.current < ctx.currentTime + 0.1) {
      const beat = beatRef.current;
      const bar = barRef.current;
      const ph = phaseRef.current;
      const time = nextNoteTimeRef.current;
      scheduleClick(time, beat === 0);
      const delayMs = Math.max(0, (time - ctx.currentTime) * 1000);
      const visualId = window.setTimeout(() => {
        setCurrentBeat(beat);
        setCurrentBar(bar);
        setPhase(ph);
      }, delayMs);
      visualTimersRef.current.push(visualId);

      nextNoteTimeRef.current = time + 60 / bpmRef.current;
      if (beat + 1 < beatsPerBarRef.current) {
        beatRef.current = beat + 1;
      } else {
        beatRef.current = 0;
        if (ph === "count-in") {
          if (bar >= COUNT_IN_BARS) {
            phaseRef.current = "run";
            barRef.current = 1;
          } else {
            barRef.current = bar + 1;
          }
        } else if (bar >= runLengthRef.current) {
          // That was the last beat of the last bar — stop just after it sounds.
          finishedRef.current = true;
          const stopId = window.setTimeout(() => stop(), delayMs + 80);
          visualTimersRef.current.push(stopId);
        } else {
          barRef.current = bar + 1;
        }
      }
    }
  }, [scheduleClick, stop]);

  const start = async () => {
    // Create/resume the AudioContext here, inside the tap — never on load.
    if (!ctxRef.current) {
      const Ctor =
        window.AudioContext ??
        (window as unknown as { webkitAudioContext?: typeof AudioContext }).webkitAudioContext;
      if (!Ctor) return;
      ctxRef.current = new Ctor();
    }
    const ctx = ctxRef.current;
    if (ctx.state === "suspended") await ctx.resume();
    if (timerRef.current !== null) window.clearInterval(timerRef.current);
    visualTimersRef.current.forEach((id) => window.clearTimeout(id));
    visualTimersRef.current = [];
    finishedRef.current = false;
    beatRef.current = 0;
    barRef.current = 1;
    phaseRef.current = countIn ? "count-in" : "run";
    setPhase(phaseRef.current);
    setCurrentBeat(-1);
    setCurrentBar(0);
    nextNoteTimeRef.current = ctx.currentTime + 0.06;
    timerRef.current = window.setInterval(tick, 25);
    setRunning(true);
  };

  // --- Tempo controls ---

  const applyDerivedTempo = (d: DanceSlug, l: LevelSlug, pct: number) => {
    const t = tempoFor(d, l);
    if (t !== null) {
      setBpm(Math.round((t * pct) / 100));
      setAdjusted(false);
    }
  };

  const handleDance = (slug: DanceSlug) => {
    setDance(slug);
    applyDerivedTempo(slug, level, slowPct);
    router.replace(`/practice?dance=${slug}&level=${level}`, { scroll: false });
  };

  const handleLevel = (slug: LevelSlug) => {
    setLevel(slug);
    applyDerivedTempo(dance, slug, slowPct);
    router.replace(`/practice?dance=${dance}&level=${slug}`, { scroll: false });
  };

  const handleSlowPct = (pct: number) => {
    setSlowPct(pct);
    if (target !== null) {
      setBpm(Math.round((target * pct) / 100));
      setAdjusted(false);
    }
  };

  const setManualBpm = (n: number) => {
    setBpm(clampBpm(n));
    setAdjusted(true);
  };

  const tapsRef = useRef<number[]>([]);
  const handleTapTempo = () => {
    const now = performance.now();
    const recent = [...tapsRef.current.filter((t) => now - t < 2500), now].slice(-5);
    tapsRef.current = recent;
    if (recent.length >= 2) {
      const intervals: number[] = [];
      for (let i = 1; i < recent.length; i++) intervals.push(recent[i] - recent[i - 1]);
      const avg = intervals.reduce((a, b) => a + b, 0) / intervals.length;
      if (avg > 0) setManualBpm(60000 / avg);
    }
  };

  const statusText = running
    ? phase === "count-in"
      ? `Count-in · bar ${Math.max(1, currentBar)} of ${COUNT_IN_BARS}`
      : `Bar ${Math.max(1, currentBar)} of ${runLength}`
    : "Ready";

  return (
    <section className="card space-y-4" aria-label="Metronome">
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-semibold">Metronome</h2>
        <span className="badge bg-brand-100 text-brand-900">Free</span>
      </div>

      <div className="grid grid-cols-2 gap-2">
        <div>
          <label className="label" htmlFor="metro-dance">
            Dance
          </label>
          <select
            id="metro-dance"
            className="input"
            value={dance}
            onChange={(e) => handleDance(e.target.value as DanceSlug)}
          >
            {DANCES.map((d) => (
              <option key={d.slug} value={d.slug}>
                {d.name}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label className="label" htmlFor="metro-level">
            Level
          </label>
          <select
            id="metro-level"
            className="input"
            value={level}
            onChange={(e) => handleLevel(e.target.value as LevelSlug)}
          >
            {LEVELS.map((l) => (
              <option key={l.slug} value={l.slug}>
                {l.name}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="text-center">
        <p className="text-5xl font-bold tabular-nums" aria-live="polite">
          {bpm}
          <span className="ml-1 text-base font-semibold text-gray-500">BPM</span>
        </p>
        {target !== null ? (
          <p className="mt-1 text-sm text-gray-600">
            Dance tempo: {target} BPM
            {slowPct < 100 ? ` · slow practice at ${slowPct}%` : ""}
            {adjusted ? " · tempo adjusted by hand" : ""}
          </p>
        ) : (
          <p className="mt-1 text-sm text-gray-600">
            No set tempo for this dance at this level — pick another level, or set a tempo below.
          </p>
        )}
      </div>

      <div className="flex items-center justify-center gap-2" aria-hidden="true">
        {Array.from({ length: beatsPerBar }, (_, i) => (
          <span
            key={i}
            className={`h-4 w-4 rounded-full transition-colors ${
              running && currentBeat === i ? (i === 0 ? "bg-brand-600 ring-4 ring-brand-100" : "bg-brand-600") : "bg-gray-200"
            }`}
          />
        ))}
      </div>
      <p className="text-center text-sm font-medium text-gray-700" aria-live="polite">
        {statusText}
      </p>

      <div className="flex gap-2">
        {running ? (
          <button type="button" className="btn flex-1" onClick={stop}>
            Stop
          </button>
        ) : (
          <button type="button" className="btn flex-1" onClick={() => void start()}>
            Start
          </button>
        )}
        <button type="button" className="btn-secondary flex-1" onClick={handleTapTempo}>
          Tap tempo
        </button>
      </div>

      <div>
        <label className="label" htmlFor="metro-bpm">
          Tempo (60–150 BPM)
        </label>
        <div className="flex items-center gap-2">
          <button type="button" className="btn-secondary px-3" aria-label="Slower" onClick={() => setManualBpm(bpm - 1)}>
            −
          </button>
          <input
            id="metro-bpm"
            type="range"
            min={MIN_BPM}
            max={MAX_BPM}
            step={1}
            value={bpm}
            onChange={(e) => setManualBpm(Number(e.target.value))}
            className="w-full accent-brand-600"
          />
          <button type="button" className="btn-secondary px-3" aria-label="Faster" onClick={() => setManualBpm(bpm + 1)}>
            +
          </button>
        </div>
      </div>

      <div>
        <label className="label" htmlFor="metro-slow">
          Slow practice: {slowPct}%{target !== null ? ` of ${target} BPM` : ""}
        </label>
        <input
          id="metro-slow"
          type="range"
          min={60}
          max={100}
          step={1}
          value={slowPct}
          onChange={(e) => handleSlowPct(Number(e.target.value))}
          className="w-full accent-brand-600"
        />
      </div>

      <div className="flex flex-wrap items-center gap-2">
        <span className="text-sm font-medium text-gray-700">Run length</span>
        {RUN_LENGTHS.map((n) => (
          <button
            key={n}
            type="button"
            aria-pressed={runLength === n}
            onClick={() => setRunLength(n)}
            className={runLength === n ? "btn px-3" : "btn-secondary px-3"}
          >
            {n} bars
          </button>
        ))}
      </div>

      <div className="flex flex-wrap items-center justify-between gap-2">
        <label className="flex min-h-11 items-center gap-2 text-sm font-medium text-gray-700">
          <input
            type="checkbox"
            checked={countIn}
            onChange={(e) => setCountIn(e.target.checked)}
            className="h-5 w-5 accent-brand-600"
          />
          8-bar count-in
        </label>
        <button
          type="button"
          className="btn-secondary"
          disabled={target === null}
          onClick={() => {
            if (target !== null) {
              setBpm(Math.round((target * slowPct) / 100));
              setAdjusted(false);
            }
          }}
        >
          Reset to dance tempo{target !== null ? ` (${target})` : ""}
        </button>
      </div>
    </section>
  );
}
