"use client";

import { useEffect, useMemo, useRef, useState } from "react";

// Feis stage time calculator. A parent enters their dancer's competition
// number, the stage start time, and the running order (competition
// number, dance, dancer count, and a type preset), and gets an estimated
// on-stage time. Competition numbers usually break down with the first
// digit as the level (1 First Feis to 7 Open Championship) and the last
// two digits as the age group. All timing assumptions live in PRESETS
// below so the math stays simple and explainable. The form persists to
// localStorage so a refresh on feis day does not lose it.

type RowType =
  | "grades-2"
  | "grades-1"
  | "championship"
  | "set"
  | "treble-reel"
  | "team"
  | "break";

interface Preset {
  label: string;
  /** How many dance at once (dancers, or teams for team rows). */
  atATime: number;
  /** Minutes each group of that size takes. */
  minutesPerGroup: number;
  /** What the count field counts, for the label. */
  unit: "Dancers" | "Teams";
}

const PRESETS: Record<RowType, Preset> = {
  "grades-2": { label: "Grades, 2 dances", atATime: 2, minutesPerGroup: 2.5, unit: "Dancers" },
  "grades-1": { label: "Grades, 1 dance", atATime: 2, minutesPerGroup: 1.25, unit: "Dancers" },
  championship: { label: "Championship", atATime: 1, minutesPerGroup: 5, unit: "Dancers" },
  set: { label: "Set dance only", atATime: 1, minutesPerGroup: 2, unit: "Dancers" },
  "treble-reel": { label: "Treble reel or special", atATime: 2, minutesPerGroup: 1.5, unit: "Dancers" },
  team: { label: "Team or céilí", atATime: 1, minutesPerGroup: 3, unit: "Teams" },
  break: { label: "Break", atATime: 1, minutesPerGroup: 0, unit: "Dancers" },
};

const ROW_TYPES = Object.keys(PRESETS) as RowType[];

const DANCES = [
  "Any dance",
  "Reel",
  "Slip Jig",
  "Light Jig",
  "Single Jig",
  "Treble Jig",
  "Hornpipe",
  "Set Dance",
  "Traditional Set",
  "Céilí or Team",
  "Other",
] as const;

type Dance = (typeof DANCES)[number];

const LEVELS: Record<string, string> = {
  "1": "First Feis",
  "2": "Beginner 1",
  "3": "Beginner 2",
  "4": "Novice",
  "5": "Prizewinner",
  "6": "Preliminary Championship",
  "7": "Open Championship",
};

interface DecodedComp {
  digit: number;
  level: string;
  age: number;
}

/** Decode a three digit competition number, or null if it does not fit the usual scheme. */
function decodeComp(raw: string): DecodedComp | null {
  const t = raw.trim();
  if (!/^[1-7][0-9][0-9]$/.test(t)) return null;
  return { digit: Number(t[0]), level: LEVELS[t[0]], age: Number.parseInt(t.slice(1), 10) };
}

/** Compare competition numbers loosely: trimmed, case-insensitive, leading zeros stripped. */
function normalizeNumber(raw: string): string {
  const t = raw.trim().toLowerCase();
  if (/^[0-9]+$/.test(t)) return String(Number.parseInt(t, 10));
  return t;
}

// Fixed speeds (bpm) for the seven traditional sets, from the site's
// verified tempo chart. Modern sets are typed in by the parent.
const TRADITIONAL_SET_SPEEDS: Record<string, number> = {
  "St. Patrick's Day": 94,
  Blackbird: 144,
  "Garden of Daisies": 138,
  "Job of Journeywork": 138,
  "Jockey to the Fair": 90,
  "King of the Fairies": 130,
  "Three Sea Captains": 96,
};

const SET_NAMES = [...Object.keys(TRADITIONAL_SET_SPEEDS), "The Storyteller", "Other modern set"];

function isSetDance(dance: Dance): boolean {
  return dance === "Set Dance" || dance === "Traditional Set";
}

/** The speed a set is danced at: fixed for traditional sets, else the typed value. */
function setSpeed(setName: string, speedText: string): number | null {
  const fixed = TRADITIONAL_SET_SPEEDS[setName];
  if (fixed) return fixed;
  const n = Number.parseFloat(speedText);
  return Number.isFinite(n) && n > 0 ? n : null;
}

function formatSpeed(speed: number): string {
  return Number.isInteger(speed) ? String(speed) : String(Math.round(speed * 10) / 10);
}

interface Row {
  id: string;
  /** Competition number as typed, e.g. "713". */
  comp: string;
  dance: Dance;
  /** Set name, only used when the dance is a set dance. */
  setName: string;
  /** Raw speed text (bpm), only used for modern sets. */
  speed: string;
  /** Raw input text; parsed when computing so typing stays smooth. */
  count: string;
  type: RowType;
  /** Raw input text for break length in minutes (break rows only). */
  breakMinutes: string;
  mine: boolean;
}

interface FormState {
  feisName: string;
  stage: string;
  startTime: string;
  dancerNumber: string;
  dancerDance: Dance;
  dancerSetName: string;
  dancerSpeed: string;
  rows: Row[];
}

const STORAGE_KEY = "idc-feis-calculator-v2";

const DEFAULT_ROWS: Row[] = [
  { id: "sample-1", comp: "206", dance: "Reel", setName: "King of the Fairies", speed: "130", count: "18", type: "grades-2", breakMinutes: "30", mine: false },
  { id: "sample-2", comp: "206", dance: "Light Jig", setName: "King of the Fairies", speed: "130", count: "18", type: "grades-1", breakMinutes: "30", mine: false },
  { id: "sample-3", comp: "512", dance: "Reel", setName: "King of the Fairies", speed: "130", count: "22", type: "grades-2", breakMinutes: "30", mine: false },
  { id: "sample-4", comp: "713", dance: "Other", setName: "King of the Fairies", speed: "130", count: "15", type: "championship", breakMinutes: "30", mine: false },
  { id: "sample-5", comp: "615", dance: "Set Dance", setName: "The Storyteller", speed: "69", count: "10", type: "set", breakMinutes: "30", mine: false },
  { id: "sample-6", comp: "", dance: "Reel", setName: "King of the Fairies", speed: "130", count: "0", type: "break", breakMinutes: "30", mine: false },
];

const DEFAULT_STATE: FormState = {
  feisName: "",
  stage: "",
  startTime: "08:00",
  dancerNumber: "713",
  dancerDance: "Any dance",
  dancerSetName: "King of the Fairies",
  dancerSpeed: "130",
  rows: DEFAULT_ROWS,
};

function parseCount(text: string): number {
  const n = Number.parseInt(text, 10);
  return Number.isFinite(n) && n > 0 ? n : 0;
}

/** Minutes a row takes on stage: ceil(count / atATime) * minutesPerGroup, with speed-based timing for set dances. */
function rowMinutes(row: Row): number {
  if (row.type === "break") return parseCount(row.breakMinutes);
  const count = parseCount(row.count);
  if (count === 0) return 0;
  if (row.type === "set") {
    // No set chosen on the row: keep the flat preset time. With a set,
    // the music speed decides: about 150 / speed per dancer, because a
    // slower set keeps each dancer on stage longer.
    if (!isSetDance(row.dance)) return count * PRESETS.set.minutesPerGroup;
    const speed = setSpeed(row.setName, row.speed) ?? 73;
    const perDancer = Math.min(2.5, Math.max(1.25, 150 / speed));
    return count * perDancer;
  }
  const preset = PRESETS[row.type];
  return Math.ceil(count / preset.atATime) * preset.minutesPerGroup;
}

/** Short label for a row, e.g. "713 · Set Dance: King of the Fairies (130)". */
function rowLabel(row: Row): string {
  const comp = row.comp.trim() || "Competition";
  let dancePart: string;
  if (isSetDance(row.dance) && row.setName) {
    const speed = setSpeed(row.setName, row.speed);
    dancePart = `${row.dance}: ${row.setName}${speed ? ` (${formatSpeed(speed)})` : ""}`;
  } else if (row.dance === "Any dance" || row.dance === "Other") {
    dancePart = PRESETS[row.type].label;
  } else {
    dancePart = row.dance;
  }
  return `${comp} · ${dancePart}`;
}

/** "08:00" to minutes since midnight; falls back to 8:00 AM. */
function startMinutes(startTime: string): number {
  const match = /^(\d{1,2}):(\d{2})$/.exec(startTime);
  if (!match) return 8 * 60;
  return Number(match[1]) * 60 + Number(match[2]);
}

/** Minutes since midnight to a 12 hour US time, rounded to the nearest minute. Wraps past midnight. */
function formatTime(totalMinutes: number): string {
  const wrapped = ((Math.round(totalMinutes) % 1440) + 1440) % 1440;
  const hour24 = Math.floor(wrapped / 60);
  const minute = wrapped % 60;
  const suffix = hour24 >= 12 ? "PM" : "AM";
  const hour12 = hour24 % 12 === 0 ? 12 : hour24 % 12;
  return `${hour12}:${String(minute).padStart(2, "0")} ${suffix}`;
}

interface TimedRow {
  row: Row;
  start: number;
  end: number;
  minutes: number;
}

/** Loose validation of whatever localStorage held, with safe fallbacks. */
function sanitizeState(value: unknown): FormState | null {
  if (typeof value !== "object" || value === null) return null;
  const v = value as Partial<FormState>;
  if (!Array.isArray(v.rows)) return null;
  const rows: Row[] = v.rows.map((r, i) => {
    const row = (typeof r === "object" && r !== null ? r : {}) as Partial<Row>;
    const type = ROW_TYPES.includes(row.type as RowType) ? (row.type as RowType) : "grades-2";
    const dance = DANCES.includes(row.dance as Dance) ? (row.dance as Dance) : "Reel";
    return {
      id: typeof row.id === "string" ? row.id : `row-${i}`,
      comp: typeof row.comp === "string" ? row.comp : "",
      dance,
      setName: SET_NAMES.includes(row.setName as string) ? (row.setName as string) : "King of the Fairies",
      speed: typeof row.speed === "string" ? row.speed : "69",
      count: typeof row.count === "string" ? row.count : "0",
      type,
      breakMinutes: typeof row.breakMinutes === "string" ? row.breakMinutes : "30",
      mine: row.mine === true,
    };
  });
  // Keep the "exactly one Mine" rule even if stored data broke it.
  let seenMine = false;
  for (const row of rows) {
    if (row.mine && seenMine) row.mine = false;
    if (row.mine) seenMine = true;
  }
  return {
    feisName: typeof v.feisName === "string" ? v.feisName : "",
    stage: typeof v.stage === "string" ? v.stage : "",
    startTime: typeof v.startTime === "string" ? v.startTime : "08:00",
    dancerNumber: typeof v.dancerNumber === "string" ? v.dancerNumber : "",
    dancerDance: DANCES.includes(v.dancerDance as Dance) ? (v.dancerDance as Dance) : "Any dance",
    dancerSetName: SET_NAMES.includes(v.dancerSetName as string) ? (v.dancerSetName as string) : "King of the Fairies",
    dancerSpeed: typeof v.dancerSpeed === "string" ? v.dancerSpeed : "69",
    rows,
  };
}

/** The set name and speed fields, shared by the Your dancer card and schedule rows. */
function SetFields({
  idPrefix,
  setName,
  speed,
  onSetName,
  onSpeed,
}: {
  idPrefix: string;
  setName: string;
  speed: string;
  onSetName: (name: string) => void;
  onSpeed: (value: string) => void;
}) {
  const fixed = TRADITIONAL_SET_SPEEDS[setName];
  return (
    <div className="flex gap-2">
      <div className="min-w-0 flex-1">
        <label className="label" htmlFor={`${idPrefix}-set`}>
          Set
        </label>
        <select
          id={`${idPrefix}-set`}
          className="input w-full"
          value={setName}
          onChange={(e) => onSetName(e.target.value)}
        >
          {SET_NAMES.map((name) => (
            <option key={name} value={name}>
              {name}
            </option>
          ))}
        </select>
      </div>
      <div className="min-w-0 flex-1">
        <label className="label" htmlFor={`${idPrefix}-speed`}>
          Speed (bpm)
        </label>
        {fixed ? (
          <input
            id={`${idPrefix}-speed`}
            className="input w-full"
            value={fixed}
            disabled
            aria-label="Speed in beats per minute, fixed for this set"
          />
        ) : (
          <input
            id={`${idPrefix}-speed`}
            type="number"
            inputMode="numeric"
            min={1}
            className="input w-full"
            value={speed}
            onChange={(e) => onSpeed(e.target.value)}
            aria-label="Speed in beats per minute"
          />
        )}
        <p className="mt-1 text-sm text-gray-600">
          {fixed ? "Traditional sets are danced at a fixed speed." : "Modern sets are usually danced between 66 and 72."}
        </p>
      </div>
    </div>
  );
}

export function FeisCalculator() {
  const [state, setState] = useState<FormState>(DEFAULT_STATE);
  const [loaded, setLoaded] = useState(false);
  const nextId = useRef(1);

  // Load saved state once, after first render, so server and first
  // client render agree (no hydration mismatch).
  useEffect(() => {
    try {
      const raw = window.localStorage.getItem(STORAGE_KEY);
      if (raw) {
        const saved = sanitizeState(JSON.parse(raw));
        // eslint-disable-next-line react-hooks/set-state-in-effect -- one-time load of saved form state after mount, so the first render matches the server render
        if (saved) setState(saved);
      }
    } catch {
      // Corrupt or unavailable storage: keep the defaults.
    }
    setLoaded(true);
  }, []);

  // Persist every change, but only after the initial load so the
  // defaults never overwrite a saved form before it is read.
  useEffect(() => {
    if (!loaded) return;
    try {
      window.localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    } catch {
      // Storage full or blocked: the calculator still works in memory.
    }
  }, [loaded, state]);

  const timed = useMemo<TimedRow[]>(() => {
    const origin = startMinutes(state.startTime);
    return state.rows.reduce<TimedRow[]>((acc, row) => {
      const minutes = rowMinutes(row);
      const start = acc.length > 0 ? acc[acc.length - 1].end : origin;
      return [...acc, { row, start, end: start + minutes, minutes }];
    }, []);
  }, [state.rows, state.startTime]);

  const mineTimed = timed.find((t) => t.row.mine) ?? null;

  // Match the Your dancer number against the schedule. The dance picker
  // only narrows the match when the same number appears more than once.
  const dancerNorm = normalizeNumber(state.dancerNumber);
  const hasNumber = dancerNorm !== "";
  let matches: TimedRow[] = [];
  if (hasNumber) {
    const byNumber = timed.filter(
      (t) => t.row.type !== "break" && t.row.comp.trim() !== "" && normalizeNumber(t.row.comp) === dancerNorm,
    );
    if (state.dancerDance !== "Any dance") {
      const byDance = byNumber.filter((t) => t.row.dance === state.dancerDance);
      matches = byDance.length > 0 ? byDance : byNumber;
    } else {
      matches = byNumber;
    }
  }
  const yoursIds = new Set<string>(
    hasNumber ? matches.map((t) => t.row.id) : mineTimed ? [mineTimed.row.id] : [],
  );
  const headline = matches.length > 0 ? matches[0] : !hasNumber ? mineTimed : null;
  const decoded = decodeComp(state.dancerNumber);

  const updateRow = (id: string, patch: Partial<Row>) =>
    setState((s) => ({ ...s, rows: s.rows.map((r) => (r.id === id ? { ...r, ...patch } : r)) }));

  // When a row's number becomes decodable and differs from what the row
  // held before, set its type from the level. After that the parent can
  // change the type freely; we never fight a manual change.
  const updateComp = (row: Row, value: string) => {
    const patch: Partial<Row> = { comp: value };
    const decodedRow = decodeComp(value);
    if (decodedRow && normalizeNumber(value) !== normalizeNumber(row.comp)) {
      patch.type = decodedRow.digit <= 5 ? "grades-2" : "championship";
    }
    updateRow(row.id, patch);
  };

  const updateRowSetName = (row: Row, name: string) => {
    const fixed = TRADITIONAL_SET_SPEEDS[name];
    if (fixed) {
      updateRow(row.id, { setName: name, speed: String(fixed) });
    } else if (TRADITIONAL_SET_SPEEDS[row.setName]) {
      updateRow(row.id, { setName: name, speed: "69" });
    } else {
      updateRow(row.id, { setName: name });
    }
  };

  const updateDancerSetName = (name: string) => {
    const fixed = TRADITIONAL_SET_SPEEDS[name];
    if (fixed) {
      setState((s) => ({ ...s, dancerSetName: name, dancerSpeed: String(fixed) }));
    } else if (TRADITIONAL_SET_SPEEDS[state.dancerSetName]) {
      setState((s) => ({ ...s, dancerSetName: name, dancerSpeed: "69" }));
    } else {
      setState((s) => ({ ...s, dancerSetName: name }));
    }
  };

  const markMine = (id: string) =>
    setState((s) => ({ ...s, rows: s.rows.map((r) => ({ ...r, mine: r.id === id })) }));

  const removeRow = (id: string) => setState((s) => ({ ...s, rows: s.rows.filter((r) => r.id !== id) }));

  const addRow = () =>
    setState((s) => ({
      ...s,
      rows: [
        ...s.rows,
        {
          id: `row-${Date.now()}-${nextId.current++}`,
          comp: "",
          dance: "Reel",
          setName: "King of the Fairies",
          speed: "130",
          count: "20",
          type: "grades-2",
          breakMinutes: "30",
          mine: false,
        },
      ],
    }));

  const startOver = () => {
    try {
      window.localStorage.removeItem(STORAGE_KEY);
    } catch {
      // Nothing to clear; resetting state below is enough.
    }
    setState(DEFAULT_STATE);
  };

  return (
    <div className="space-y-4">
      <section className="card space-y-3" aria-label="Feis and stage details">
        <div>
          <label className="label" htmlFor="calc-feis">
            Feis name (optional)
          </label>
          <input
            id="calc-feis"
            className="input w-full"
            value={state.feisName}
            onChange={(e) => setState((s) => ({ ...s, feisName: e.target.value }))}
            placeholder="e.g. Gem City Feis"
            maxLength={80}
          />
        </div>
        <div className="flex gap-2">
          <div className="min-w-0 flex-1">
            <label className="label" htmlFor="calc-stage">
              Stage (optional)
            </label>
            <input
              id="calc-stage"
              className="input w-full"
              value={state.stage}
              onChange={(e) => setState((s) => ({ ...s, stage: e.target.value }))}
              placeholder="e.g. Stage 2"
              maxLength={30}
            />
          </div>
          <div className="min-w-0 flex-1">
            <label className="label" htmlFor="calc-start">
              Stage start time
            </label>
            <input
              id="calc-start"
              type="time"
              className="input w-full"
              value={state.startTime}
              onChange={(e) => setState((s) => ({ ...s, startTime: e.target.value }))}
              required
            />
          </div>
        </div>
      </section>

      <section className="card space-y-3" aria-label="Your dancer">
        <h2 className="text-lg font-semibold">Your dancer</h2>
        <div className="flex gap-2">
          <div className="min-w-0 flex-1">
            <label className="label" htmlFor="calc-dancer-number">
              Competition number
            </label>
            <input
              id="calc-dancer-number"
              className="input w-full"
              inputMode="numeric"
              value={state.dancerNumber}
              onChange={(e) => setState((s) => ({ ...s, dancerNumber: e.target.value }))}
              placeholder="713"
              maxLength={10}
            />
          </div>
          <div className="min-w-0 flex-1">
            <label className="label" htmlFor="calc-dancer-dance">
              Dance
            </label>
            <select
              id="calc-dancer-dance"
              className="input w-full"
              value={state.dancerDance}
              onChange={(e) => setState((s) => ({ ...s, dancerDance: e.target.value as Dance }))}
            >
              {DANCES.map((d) => (
                <option key={d} value={d}>
                  {d}
                </option>
              ))}
            </select>
          </div>
        </div>
        {decoded ? (
          <p className="text-sm text-gray-600">
            {state.dancerNumber.trim()}: {decoded.level}, age {decoded.age}. Competition numbers usually
            break down this way, with the first digit as the level and the last two digits as the age
            group. Some feiseanna number differently, so trust the printed schedule if yours looks
            different.
          </p>
        ) : null}
        <p className="text-sm text-gray-600">
          The dance picker only matters if the same number appears more than once in the schedule below.
        </p>
        {isSetDance(state.dancerDance) ? (
          <SetFields
            idPrefix="calc-dancer"
            setName={state.dancerSetName}
            speed={state.dancerSpeed}
            onSetName={updateDancerSetName}
            onSpeed={(value) => setState((s) => ({ ...s, dancerSpeed: value }))}
          />
        ) : null}
      </section>

      {headline ? (
        <section className="card space-y-1 border-brand-600 bg-brand-50" aria-label="Your dancer's estimated time">
          <p className="text-sm font-semibold text-brand-700">
            Your dance{state.feisName ? ` at ${state.feisName}` : ""}
            {state.stage ? `, ${state.stage}` : ""}
          </p>
          <p className="text-lg font-semibold">{rowLabel(headline.row)}</p>
          <p>
            Estimated on stage at <strong>{formatTime(headline.start)}</strong>. Be ready by{" "}
            <strong>{formatTime(headline.start - 45)}</strong>, hair done and shoes on.
          </p>
          {matches.length > 1 ? (
            <p className="text-sm text-gray-600">
              Competition {state.dancerNumber.trim()} comes up {matches.length} times in this schedule.
              The time above is the first of them, and each one is marked Yours in the running order.
            </p>
          ) : null}
          <p className="text-sm text-gray-600">
            Stages often drift 15 to 30 minutes by midday, so treat this as a planning estimate, not a
            promise. If the stage is running behind, everything moves together.
          </p>
        </section>
      ) : hasNumber ? (
        <section className="card bg-brand-50" aria-label="Your dancer's estimated time">
          <p className="text-sm text-brand-900">
            We could not find competition <strong>{state.dancerNumber.trim()}</strong> in the schedule
            below. Check the number against the printed schedule, and make sure one of the rows below
            carries the same number in its Comp # box. If your feis numbers competitions differently,
            clear the number above and tap <strong>Mine</strong> on your dancer&apos;s row instead.
          </p>
        </section>
      ) : (
        <section className="card bg-brand-50" aria-label="Your dancer's estimated time">
          <p className="text-sm text-brand-900">
            Enter your dancer&apos;s competition number above, or tap <strong>Mine</strong> on their
            competition in the schedule below, and we will work out when they are likely to be on, and
            when to be ready.
          </p>
        </section>
      )}

      <section className="space-y-3" aria-label="Stage schedule">
        <h2 className="text-lg font-semibold">Stage schedule</h2>
        {state.rows.map((row, index) => {
          const preset = PRESETS[row.type];
          const isBreak = row.type === "break";
          const yours = yoursIds.has(row.id);
          return (
            <div key={row.id} className={`card space-y-2 ${yours ? "border-brand-600 bg-brand-50" : ""}`}>
              {isBreak ? (
                <div className="flex items-center gap-2">
                  <span className="badge shrink-0">{index + 1}</span>
                  <span className="min-w-0 flex-1 font-medium">Break</span>
                </div>
              ) : (
                <div className="flex items-center gap-2">
                  <span className="badge shrink-0">{index + 1}</span>
                  <input
                    className="input w-20 shrink-0"
                    value={row.comp}
                    onChange={(e) => updateComp(row, e.target.value)}
                    placeholder="713"
                    inputMode="numeric"
                    maxLength={10}
                    aria-label={`Competition ${index + 1} number`}
                  />
                  <select
                    className="input min-w-0 flex-1"
                    value={row.dance}
                    onChange={(e) => updateRow(row.id, { dance: e.target.value as Dance })}
                    aria-label={`Competition ${index + 1} dance`}
                  >
                    {DANCES.map((d) => (
                      <option key={d} value={d}>
                        {d}
                      </option>
                    ))}
                  </select>
                  <button
                    type="button"
                    className={row.mine ? "btn shrink-0 px-3" : "btn-secondary shrink-0 px-3"}
                    onClick={() => markMine(row.id)}
                    aria-pressed={row.mine}
                  >
                    Mine
                  </button>
                </div>
              )}
              <div className="flex gap-2">
                <select
                  className="input min-w-0 flex-1"
                  value={row.type}
                  onChange={(e) => updateRow(row.id, { type: e.target.value as RowType })}
                  aria-label={`Competition ${index + 1} type`}
                >
                  {ROW_TYPES.map((t) => (
                    <option key={t} value={t}>
                      {PRESETS[t].label}
                    </option>
                  ))}
                </select>
                {isBreak ? (
                  <label className="flex min-w-0 flex-1 items-center gap-2">
                    <span className="shrink-0 text-sm text-gray-600">Minutes</span>
                    <input
                      type="number"
                      inputMode="numeric"
                      min={0}
                      className="input min-w-0 flex-1"
                      value={row.breakMinutes}
                      onChange={(e) => updateRow(row.id, { breakMinutes: e.target.value })}
                      aria-label={`Break ${index + 1} length in minutes`}
                    />
                  </label>
                ) : (
                  <label className="flex min-w-0 flex-1 items-center gap-2">
                    <span className="shrink-0 text-sm text-gray-600">{preset.unit}</span>
                    <input
                      type="number"
                      inputMode="numeric"
                      min={0}
                      className="input min-w-0 flex-1"
                      value={row.count}
                      onChange={(e) => updateRow(row.id, { count: e.target.value })}
                      aria-label={`${preset.unit} in competition ${index + 1}`}
                    />
                  </label>
                )}
              </div>
              {!isBreak && isSetDance(row.dance) ? (
                <SetFields
                  idPrefix={`calc-row-${row.id}`}
                  setName={row.setName}
                  speed={row.speed}
                  onSetName={(name) => updateRowSetName(row, name)}
                  onSpeed={(value) => updateRow(row.id, { speed: value })}
                />
              ) : null}
              <div className="flex items-center justify-between text-sm text-gray-600">
                <span>
                  {isBreak
                    ? `${parseCount(row.breakMinutes)} minute break`
                    : `About ${Math.round(rowMinutes(row))} minutes on stage`}
                </span>
                <button
                  type="button"
                  className="link"
                  onClick={() => removeRow(row.id)}
                  aria-label={`Remove row ${index + 1}`}
                >
                  Remove
                </button>
              </div>
            </div>
          );
        })}
        <div className="flex gap-2">
          <button type="button" className="btn-secondary flex-1" onClick={addRow}>
            Add a competition
          </button>
          <button type="button" className="btn-secondary flex-1" onClick={startOver}>
            Start over
          </button>
        </div>
      </section>

      <section className="card space-y-2" aria-label="Running order with estimated times">
        <h2 className="text-lg font-semibold">Running order</h2>
        {timed.length ? (
          <table className="w-full text-sm">
            <thead>
              <tr className="text-left text-gray-500">
                <th className="py-1 pr-2 font-medium">Competition</th>
                <th className="py-1 pr-2 font-medium">On stage</th>
                <th className="py-1 font-medium">Ends</th>
              </tr>
            </thead>
            <tbody>
              {timed.map((t) => {
                const yours = yoursIds.has(t.row.id);
                return (
                  <tr key={t.row.id} className={yours ? "bg-brand-50 font-semibold" : ""}>
                    <td className="py-1 pr-2">
                      {t.row.type === "break"
                        ? `Break (${Math.round(t.minutes)} min)`
                        : rowLabel(t.row)}
                      {yours ? <span className="badge ml-2 bg-brand-100 text-brand-900">Yours</span> : null}
                    </td>
                    <td className="py-1 pr-2 whitespace-nowrap">{formatTime(t.start)}</td>
                    <td className="py-1 whitespace-nowrap">{formatTime(t.end)}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        ) : (
          <p className="text-sm text-gray-600">
            No competitions yet. Add the running order above and the times will appear here.
          </p>
        )}
      </section>

      <section className="card space-y-2" aria-label="How the estimate works">
        <h2 className="text-lg font-semibold">How the estimate works</h2>
        <p className="text-sm text-gray-600">
          Competition numbers: at most CLRG feiseanna the three digit number puts the level first and
          the age group last. The first digit runs from 1 for First Feis to 7 for Open Championship, and
          the last two digits are the dancer&apos;s age on January 1 of the feis year. So 713 is Open
          Championship, age 13, and 206 is Beginner 1, age 6. Type a number like that on a schedule row
          and we set its type for you, grades for levels 1 to 5 and championship for levels 6 and 7. You
          can change the type yourself at any time, and some feiseanna number differently.
        </p>
        <p className="text-sm text-gray-600">
          We keep the timing simple: each competition takes as long as its groups need, one after
          another from the stage start time. The timings we assume are:
        </p>
        <ul className="list-inside list-disc space-y-1 text-sm text-gray-600">
          <li>Grades, 2 dances: 2 dancers at a time, about 2.5 minutes per group for both dances.</li>
          <li>Grades, 1 dance: 2 dancers at a time, about 1.25 minutes per group.</li>
          <li>
            Championship: 1 dancer at a time, about 5 minutes each, covering the heavy, light and set
            rounds with changeovers.
          </li>
          <li>
            Set dance only: 1 dancer at a time, timed from the music. Each dancer takes about 150
            divided by the speed in beats per minute, so a slower speed means longer on stage.
            Traditional sets have fixed speeds; modern sets are usually danced between 66 and 72.
          </li>
          <li>Treble reel or special: 2 dancers at a time, about 1.5 minutes per group.</li>
          <li>Team or céilí: 1 team at a time, about 3 minutes per team.</li>
        </ul>
        <p className="text-sm text-gray-600">
          Dancer counts come from the feis&apos;s published schedule or syllabus, which usually list how
          many are entered in each competition. If your stage runs a competition with a different number
          dancing at a time, adjust the count and the estimate will follow.
        </p>
      </section>
    </div>
  );
}
