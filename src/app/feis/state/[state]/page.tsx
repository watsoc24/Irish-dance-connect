import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { findState, stateMatches, statesWithCounts } from "@/lib/states";

function formatRange(start: string, end: string) {
  const opts: Intl.DateTimeFormatOptions = { month: "short", day: "numeric", year: "numeric", timeZone: "UTC" };
  const s = new Date(`${start}T00:00:00Z`).toLocaleDateString("en", opts);
  if (start === end) return s;
  return `${s} – ${new Date(`${end}T00:00:00Z`).toLocaleDateString("en", opts)}`;
}

type FeisRow = {
  id: string;
  name: string;
  starts_on: string;
  ends_on: string;
  venue_name: string | null;
  city: string | null;
  region: string | null;
  country: string | null;
  registration_url: string;
};

async function feiseannaInState(stateSlug: string) {
  const state = findState(stateSlug);
  if (!state) return null;
  const supabase = await createClient();
  const today = new Date().toISOString().slice(0, 10);
  const { data } = await supabase
    .from("feis_events")
    .select("id, name, starts_on, ends_on, venue_name, city, region, country, registration_url")
    .eq("status", "published")
    .gte("ends_on", today)
    .order("starts_on")
    .limit(200);
  const all = (data ?? []) as FeisRow[];
  return { state, events: all.filter((e) => stateMatches(e.region, state)), all };
}

export async function generateMetadata({ params }: PageProps<"/feis/state/[state]">): Promise<Metadata> {
  const { state: slug } = await params;
  const result = await feiseannaInState(slug);
  if (!result) return { title: "Feis Calendar" };
  const { state, events } = result;
  return {
    title: `Irish Dance Competitions in ${state.name}: Upcoming Feiseanna`,
    description: `${events.length} upcoming feiseanna and Irish dance competitions in ${state.name}, with dates, venues and direct links to each organizer's official registration page. Updated weekly.`,
    alternates: { canonical: `/feis/state/${state.slug}` },
  };
}

export default async function FeisByStatePage({ params }: PageProps<"/feis/state/[state]">) {
  const { state: slug } = await params;
  const result = await feiseannaInState(slug);
  if (!result) notFound();
  const { state, events, all } = result;
  const others = statesWithCounts(all.map((e) => e.region)).filter((x) => x.state.slug !== state.slug);

  return (
    <div className="space-y-4">
      <Link href="/feis" className="link">
        &larr; Full feis calendar
      </Link>
      <div>
        <h1 className="page-title">Irish dance competitions in {state.name}</h1>
        <p className="text-gray-600">
          {events.length === 1
            ? `1 upcoming feis in ${state.name}.`
            : `${events.length} upcoming feiseanna in ${state.name}.`}{" "}
          Registration happens on each organizer&apos;s own site; tap a feis for its dates and venue.
        </p>
        <p className="mt-1 text-gray-600">
          <Link href={`/schools/state/${state.slug}`} className="link">
            Irish dance schools in {state.name}
          </Link>
        </p>
      </div>
      {events.length ? (
        <ul className="space-y-3">
          {events.map((e) => (
            <li key={e.id} className="card space-y-1">
              <p className="text-sm font-semibold text-brand-700">{formatRange(e.starts_on, e.ends_on)}</p>
              <p className="text-lg font-semibold">
                <Link href={`/feis/${e.id}`} className="link">
                  {e.name}
                </Link>
              </p>
              <p className="text-sm text-gray-600">
                {[e.venue_name, e.city, e.region, e.country].filter(Boolean).join(", ")}
              </p>
              <a
                href={e.registration_url}
                target="_blank"
                rel="noopener noreferrer nofollow"
                className="btn-secondary mt-2 w-full"
              >
                Register on organizer&apos;s site ↗
              </a>
            </li>
          ))}
        </ul>
      ) : (
        <p className="card text-gray-600">
          No upcoming feiseanna are listed in {state.name} yet. The{" "}
          <Link href="/feis" className="link">
            full calendar
          </Link>{" "}
          shows every competition we track.
        </p>
      )}
      {others.length ? (
        <section aria-label="Feiseanna in other states">
          <h2 className="mb-2 text-lg font-semibold">Feiseanna in other states</h2>
          <ul className="flex flex-wrap gap-2">
            {others.map(({ state: s, count }) => (
              <li key={s.slug}>
                <Link
                  href={`/feis/state/${s.slug}`}
                  className="inline-flex min-h-11 items-center rounded-lg border border-line bg-cream px-3 py-2 text-sm font-semibold text-ink"
                >
                  {s.name} ({count})
                </Link>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
    </div>
  );
}
