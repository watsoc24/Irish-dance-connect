import Link from "next/link";
import { Metronome } from "@/components/metronome";
import { getDance, getLevel, LEVELS, PRACTICE_ENTRIES, TEMPO_CHART } from "@/lib/practice-music";

export const metadata = { title: "Practice music" };

// Free practice-music directory + metronome. No sign-in required, no
// audio hosted — listening is always an outbound link. Initial state
// comes from the URL: ?dance=<slug>&level=<slug>&bpm=<60-150>, which is
// how the fundamentals page pre-selects a tempo. Invalid dance/level
// values fall back to reel / beginner.
export default async function PracticePage({ searchParams }: PageProps<"/practice">) {
  const sp = await searchParams;
  const dance = getDance(typeof sp.dance === "string" ? sp.dance : undefined)?.slug ?? "reel";
  const level = getLevel(typeof sp.level === "string" ? sp.level : undefined)?.slug ?? "beginner";
  const bpmRaw = typeof sp.bpm === "string" ? Number(sp.bpm) : Number.NaN;
  const initialBpm = Number.isFinite(bpmRaw) ? Math.min(150, Math.max(60, Math.round(bpmRaw))) : undefined;

  const levelName = getLevel(level)?.name ?? "Beginner";
  const entries = PRACTICE_ENTRIES.filter((e) => e.level === level);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="page-title">Practice music</h1>
        <p className="text-gray-600">
          Feis tempos, traditional tunes and a metronome for every dance and level — free, no sign-in needed. Pick
          your level, choose a dance, and press start.
        </p>
      </div>

      <div id="metronome">
        <Metronome initialDance={dance} initialLevel={level} initialBpm={initialBpm} />
      </div>

      <section aria-label="Choose your level">
        <h2 className="mb-2 text-lg font-semibold">Your level</h2>
        <ul className="flex flex-wrap gap-2">
          {LEVELS.map((l) => (
            <li key={l.slug}>
              <Link
                href={`/practice?dance=${dance}&level=${l.slug}`}
                aria-current={l.slug === level ? "true" : undefined}
                className={
                  l.slug === level
                    ? "inline-flex min-h-11 items-center rounded-lg bg-brand-600 px-3 py-2 text-sm font-semibold text-white"
                    : "inline-flex min-h-11 items-center rounded-lg border border-line bg-cream px-3 py-2 text-sm font-semibold text-ink"
                }
              >
                {l.name}
              </Link>
            </li>
          ))}
        </ul>
        <p className="hint">A dancer advances per dance, not as a whole — your level can differ from dance to dance.</p>
      </section>

      <section aria-label="Tempos and tunes for your level">
        <h2 className="mb-2 text-lg font-semibold">Tempos &amp; tunes — {levelName}</h2>
        <ul className="space-y-3">
          {entries.map((entry) => {
            const danceInfo = getDance(entry.dance);
            return (
              <li key={`${entry.dance}-${entry.level}`} className="card space-y-2">
                <div className="flex flex-wrap items-center gap-2">
                  <h3 className="text-base font-semibold">{danceInfo?.name}</h3>
                  <span className="badge bg-brand-100 text-brand-900">{entry.bpm} BPM</span>
                  <span className="badge">{entry.timeSignature}</span>
                  <span className="badge">{entry.bars} bars</span>
                </div>
                <div>
                  <p className="text-sm font-medium text-gray-700">Tunes to practise to</p>
                  <ul className="list-inside list-disc text-sm text-gray-600">
                    {entry.tunes.map((tune) => (
                      <li key={tune.name}>
                        {tune.name}
                        {tune.sessionUrl ? (
                          <>
                            {" · "}
                            <a href={tune.sessionUrl} target="_blank" rel="noreferrer" className="link">
                              Notation on TheSession.org
                            </a>
                          </>
                        ) : null}
                      </li>
                    ))}
                  </ul>
                </div>
                <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-sm">
                  <span className="font-medium text-gray-700">Listen:</span>
                  {entry.listen.map((link) => (
                    <a key={link.label} href={link.url} target="_blank" rel="noreferrer" className="link">
                      {link.label}
                    </a>
                  ))}
                  <Link href={`/practice?dance=${entry.dance}&level=${entry.level}#metronome`} className="link">
                    Open in metronome
                  </Link>
                </div>
              </li>
            );
          })}
        </ul>
      </section>

      <section aria-label="Feis tempo chart">
        <h2 className="mb-2 text-lg font-semibold">Feis tempo chart</h2>
        <div className="card overflow-x-auto p-0">
          <table className="w-full min-w-[540px] text-sm">
            <thead>
              <tr className="text-left text-gray-500">
                <th scope="col" className="p-3 font-semibold">Dance</th>
                <th scope="col" className="p-3 font-semibold">Time</th>
                <th scope="col" className="p-3 font-semibold">Beginner</th>
                <th scope="col" className="p-3 font-semibold">Adv. Beginner</th>
                <th scope="col" className="p-3 font-semibold">Novice</th>
                <th scope="col" className="p-3 font-semibold">Prizewinner</th>
                <th scope="col" className="p-3 font-semibold">Championship</th>
              </tr>
            </thead>
            <tbody>
              {TEMPO_CHART.map((row) => (
                <tr key={row.dance} className="border-t border-gray-100">
                  <th scope="row" className="p-3 text-left font-semibold">
                    {getDance(row.dance)?.name}
                  </th>
                  <td className="p-3">{row.timeSignature}</td>
                  <td className="p-3">{row.beginner}</td>
                  <td className="p-3">{row.advancedBeginner}</td>
                  <td className="p-3">{row.novice}</td>
                  <td className="p-3">{row.prizewinner}</td>
                  <td className="p-3">{row.championship}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p className="mt-2 text-sm text-gray-600">
          North America (IDTANA) speeds unless stated — confirm with your dancer&apos;s teacher. European speeds
          differ slightly.
        </p>
        <p className="mt-1 text-sm text-gray-600">
          First Feis dancers use beginner speeds, and adult dancers generally use novice speeds. Where the chart
          shows two speeds (treble jig and hornpipe at Novice and Prizewinner), either may be used — the metronome
          above uses 92 at Novice and 73 at Prizewinner for the treble jig, and 138 at Novice and 113 at Prizewinner
          for the hornpipe. Championships add an 8-bar introduction before the 48 bars (Reel, Treble Jig, Treble
          Reel) or 40 bars (Slip Jig, Hornpipe).
        </p>
      </section>

      <section className="rounded-xl border border-line bg-brand-50 p-4" aria-label="Premium practice tracks coming soon">
        <p className="mb-1 flex items-center gap-2 font-semibold text-brand-900">
          Premium practice tracks
          <span className="badge bg-brand-100 text-brand-900">Coming soon</span>
        </p>
        <p className="text-sm text-brand-900">
          Premium practice tracks — coming soon. Full-length tracks at exact feis tempos, coming soon.
        </p>
      </section>
    </div>
  );
}
