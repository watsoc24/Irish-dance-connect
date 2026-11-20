"use client";

import { useEffect, useMemo, useRef, useState } from "react";

// Feis stage time calculator. A parent enters the stage start time and
// the running order (competition name, dancer count, and a type preset),
// marks their dancer's competition, and gets an estimated on-stage time.
// All timing assumptions live in PRESETS below so the math stays simple
// and explainable. The form persists to localStorage so a refresh on
// feis day does not lose it.

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

interface Row {
  id: string;
  name: string;
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
  rows: Row[];
}

const STORAGE_KEY = "idc-feis-calculator";

const DEFAULT_ROWS: Row[] = [
  { id: "sample-1", name: "Reel U10", count: "24", type: "grades-2", breakMinutes: "30", mine: false },
  { id: "sample-2", name: "Light Jig U10", count: "24", type: "grades-1", breakMinutes: "30", mine: false },
  { id: "sample-3", name: "Championship U12", count: "12", type: "championship", breakMinutes: "30", mine: true },
  { id: "sample-4", name: "Lunch break", count: "0", type: "break", breakMinutes: "30", mine: false },
];

const DEFAULT_STATE: FormState = { feisName: "", stage: "", startTime: "08:00", rows: DEFAULT_ROWS };

function parseCount(text: string): number {
  const n = Number.parseInt(text, 10);
  return Number.isFinite(n) && n > 0 ? n : 0;
}

/** Minutes a row takes on stage: ceil(count / atATime) * minutesPerGroup. */
function rowMinutes(row: Row): number {
  if (row.type === "break") return parseCount(row.breakMinutes);
  const preset = PRESETS[row.type];
  const count = parseCount(row.count);
  if (count === 0) return 0;
  return Math.ceil(count / preset.atATime) * preset.minutesPerGroup;
}

/** "08:00" to minutes since midnight; falls back to 8:00 AM. */
function startMinutes(startTime: string): number {
  const match = /^(\d{1,2}):(\d{2})$/.exec(startTime);
  if (!match) return 8 * 60;
  return Number(match[1]) * 60 + Number(match[2]);
}

/** Minutes since midnight to a 12 hour US time. Wraps past midnight. */
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
    return {
      id: typeof row.id === "string" ? row.id : `row-${i}`,
      name: typeof row.name === "string" ? row.name : "",
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
    rows,
  };
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

  const updateRow = (id: string, patch: Partial<Row>) =>
    setState((s) => ({ ...s, rows: s.rows.map((r) => (r.id === id ? { ...r, ...patch } : r)) }));

  const markMine = (id: string) =>
    setState((s) => ({ ...s, rows: s.rows.map((r) => ({ ...r, mine: r.id === id })) }));

  const removeRow = (id: string) => setState((s) => ({ ...s, rows: s.rows.filter((r) => r.id !== id) }));

  const addRow = () =>
    setState((s) => ({
      ...s,
      rows: [
        ...s.rows,
        { id: `row-${Date.now()}-${nextId.current++}`, name: "", count: "20", type: "grades-2", breakMinutes: "30", mine: false },
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

      {mineTimed ? (
        <section className="card space-y-1 border-brand-600 bg-brand-50" aria-label="Your dancer's estimated time">
          <p className="text-sm font-semibold text-brand-700">
            Your dance{state.feisName ? ` at ${state.feisName}` : ""}
            {state.stage ? `, ${state.stage}` : ""}
          </p>
          <p className="text-lg font-semibold">{mineTimed.row.name.trim() || "Your competition"}</p>
          <p>
            Estimated on stage at <strong>{formatTime(mineTimed.start)}</strong>. Be ready by{" "}
            <strong>{formatTime(mineTimed.start - 45)}</strong>, hair done and shoes on.
          </p>
          <p className="text-sm text-gray-600">
            Stages often drift 15 to 30 minutes by midday, so treat this as a planning estimate, not a
            promise. If the stage is running behind, everything moves together.
          </p>
        </section>
      ) : (
        <section className="card bg-brand-50" aria-label="Your dancer's estimated time">
          <p className="text-sm text-brand-900">
            Tap <strong>Mine</strong> on your dancer&apos;s competition below and we will work out when
            they are likely to be on, and when to be ready.
          </p>
        </section>
      )}

      <section className="space-y-3" aria-label="Stage schedule">
        <h2 className="text-lg font-semibold">Stage schedule</h2>
        {state.rows.map((row, index) => {
          const preset = PRESETS[row.type];
          const isBreak = row.type === "break";
          return (
            <div key={row.id} className={`card space-y-2 ${row.mine ? "border-brand-600 bg-brand-50" : ""}`}>
              <div className="flex items-center gap-2">
                <span className="badge shrink-0">{index + 1}</span>
                <input
                  className="input min-w-0 flex-1"
                  value={row.name}
                  onChange={(e) => updateRow(row.id, { name: e.target.value })}
                  placeholder={isBreak ? "e.g. Lunch" : "e.g. Reel U10"}
                  maxLength={60}
                  aria-label={`Competition ${index + 1} name`}
                />
                <button
                  type="button"
                  className={row.mine ? "btn shrink-0 px-3" : "btn-secondary shrink-0 px-3"}
                  onClick={() => markMine(row.id)}
                  aria-pressed={row.mine}
                >
                  Mine
                </button>
              </div>
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
              {timed.map((t) => (
                <tr key={t.row.id} className={t.row.mine ? "bg-brand-50 font-semibold" : ""}>
                  <td className="py-1 pr-2">
                    {t.row.type === "break"
                      ? `Break${t.row.name.trim() ? `: ${t.row.name.trim()}` : ""} (${t.minutes} min)`
                      : t.row.name.trim() || "Untitled competition"}
                    {t.row.mine ? <span className="badge ml-2 bg-brand-100 text-brand-900">Yours</span> : null}
                  </td>
                  <td className="py-1 pr-2 whitespace-nowrap">{formatTime(t.start)}</td>
                  <td className="py-1 whitespace-nowrap">{formatTime(t.end)}</td>
                </tr>
              ))}
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
          We keep it simple: each competition takes as long as its groups need, one after another from
          the stage start time. The timings we assume are:
        </p>
        <ul className="list-inside list-disc space-y-1 text-sm text-gray-600">
          <li>Grades, 2 dances: 2 dancers at a time, about 2.5 minutes per group for both dances.</li>
          <li>Grades, 1 dance: 2 dancers at a time, about 1.25 minutes per group.</li>
          <li>
            Championship: 1 dancer at a time, about 5 minutes each, covering the heavy, light and set
            rounds with changeovers.
          </li>
          <li>Set dance only: 1 dancer at a time, about 2 minutes each.</li>
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
