import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { getAccount } from "@/lib/auth";
import { searchTerm } from "@/lib/validation";
import { IDTANA_REGIONS, findRegion, regionMatches } from "@/lib/idtana-regions";

export const metadata = { title: "Feis calendar" };

function formatRange(start: string, end: string) {
  const opts: Intl.DateTimeFormatOptions = { month: "short", day: "numeric", year: "numeric", timeZone: "UTC" };
  const s = new Date(`${start}T00:00:00Z`).toLocaleDateString("en", opts);
  if (start === end) return s;
  return `${s} – ${new Date(`${end}T00:00:00Z`).toLocaleDateString("en", opts)}`;
}

/** Accepts only a real YYYY-MM-DD date; anything else is ignored. */
function dateParam(input: unknown): string {
  if (typeof input !== "string") return "";
  if (!/^\d{4}-\d{2}-\d{2}$/.test(input)) return "";
  const parsed = Date.parse(`${input}T00:00:00Z`);
  return Number.isNaN(parsed) ? "" : input;
}

export default async function FeisPage({ searchParams }: PageProps<"/feis">) {
  const sp = await searchParams;
  // `where` is the old filter name; `q` is the new search box. Accept both.
  const q = searchTerm(sp.q ?? sp.where);
  const region = findRegion(typeof sp.region === "string" ? sp.region : undefined)?.slug ?? "";
  const from = dateParam(sp.from);
  const account = await getAccount();
  const supabase = await createClient();
  const today = new Date().toISOString().slice(0, 10);

  let query = supabase
    .from("feis_events")
    .select("id, name, starts_on, ends_on, venue_name, city, region, country, registration_url, schools(name, slug)")
    .eq("status", "published")
    .gte("ends_on", today)
    .order("starts_on")
    .limit(200);
  if (q) {
    query = query.or(`name.ilike."%${q}%",city.ilike."%${q}%",venue_name.ilike."%${q}%"`);
  }
  if (from) {
    query = query.gte("starts_on", from);
  }
  const { data } = await query;
  const events = region ? (data ?? []).filter((e) => regionMatches(e.region, region)) : (data ?? []);
  const hasFilter = Boolean(q || region || from);

  return (
    <div className="space-y-4">
      <h1 className="page-title">Feis calendar</h1>
      {sp.submitted ? (
        <p role="status" className="rounded-xl bg-brand-50 p-3 text-sm text-brand-900">
          Thanks! Your event will appear once it&apos;s been reviewed.
        </p>
      ) : null}
      <p className="text-sm text-gray-600">
        Listings are curated from Planxti, the IDTANA regional calendars, FeisWeb and QuickFeis.
        Registration happens on each organizer&apos;s own site — tap a feis to register there. Dates and
        details can change, so always confirm on the organizer&apos;s site.
      </p>
      <form className="space-y-2" role="search">
        <input
          name="q"
          defaultValue={q}
          placeholder="Search name, city or venue"
          className="input w-full"
          maxLength={60}
          aria-label="Search feiseanna by name, city or venue"
        />
        <div className="flex gap-2">
          <select name="region" defaultValue={region} className="input min-w-0 flex-1" aria-label="Filter by IDTANA region">
            <option value="">All regions</option>
            {IDTANA_REGIONS.map((r) => (
              <option key={r.slug} value={r.slug}>
                {r.label}
              </option>
            ))}
          </select>
          <label className="flex min-w-0 flex-1 items-center gap-2">
            <span className="shrink-0 text-sm text-gray-600">From</span>
            <input name="from" type="date" defaultValue={from} className="input min-w-0 flex-1" aria-label="Show feiseanna starting on or after this date" />
          </label>
        </div>
        <div className="flex gap-2">
          <button className="btn-secondary">Search</button>
          {hasFilter ? (
            <Link href="/feis" className="btn-secondary">
              Clear
            </Link>
          ) : null}
        </div>
      </form>

      <p className="text-sm text-gray-600" role="status">
        {events.length === 1
          ? "1 upcoming feis"
          : `${events.length} upcoming feiseanna`}
        {hasFilter ? " matching your search" : ""}
      </p>

      {events.length ? (
        <ul className="space-y-3">
          {events.map((e) => {
            const host = e.schools as unknown as { name: string; slug: string } | null;
            return (
              <li key={e.id} className="card space-y-1">
                <p className="text-sm font-semibold text-brand-700">{formatRange(e.starts_on, e.ends_on)}</p>
                <p className="text-lg font-semibold">{e.name}</p>
                <p className="text-sm text-gray-600">
                  {[e.venue_name, e.city, e.region, e.country].filter(Boolean).join(", ")}
                </p>
                {host ? (
                  <p className="text-sm text-gray-500">
                    Hosted by{" "}
                    <Link href={`/schools/${host.slug}`} className="link">
                      {host.name}
                    </Link>
                  </p>
                ) : null}
                <a href={e.registration_url} target="_blank" rel="noopener noreferrer nofollow" className="btn-secondary mt-2 w-full">
                  Register on organizer&apos;s site ↗
                </a>
              </li>
            );
          })}
        </ul>
      ) : (
        <p className="card text-gray-600">
          No upcoming feiseanna are listed
          {hasFilter ? " matching your search" : ""} yet. School administrators can submit
          events for review.
        </p>
      )}
      {account?.role === "school_admin" ? (
        <Link href="/feis/submit" className="btn w-full">
          Submit a feis
        </Link>
      ) : null}
    </div>
  );
}
