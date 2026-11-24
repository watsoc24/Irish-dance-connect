import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { JsonLd } from "@/components/json-ld";
import { SITE_URL } from "@/lib/site";
import { stateOf } from "@/lib/states";

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
  schools: { name: string; slug: string } | { name: string; slug: string }[] | null;
};

async function getFeis(id: string): Promise<FeisRow | null> {
  if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(id)) return null;
  const supabase = await createClient();
  const { data } = await supabase
    .from("feis_events")
    .select("id, name, starts_on, ends_on, venue_name, city, region, country, registration_url, schools(name, slug)")
    .eq("id", id)
    .eq("status", "published")
    .maybeSingle();
  return (data as FeisRow | null) ?? null;
}

function hostOf(e: FeisRow): { name: string; slug: string } | null {
  if (!e.schools) return null;
  return Array.isArray(e.schools) ? (e.schools[0] ?? null) : e.schools;
}

function placeOf(e: FeisRow): string {
  return [e.venue_name, e.city, e.region, e.country].filter(Boolean).join(", ");
}

export async function generateMetadata({ params }: PageProps<"/feis/[id]">): Promise<Metadata> {
  const { id } = await params;
  const feis = await getFeis(id);
  if (!feis) return { title: "Feis" };
  const place = [feis.city, feis.region].filter(Boolean).join(", ");
  return {
    title: `${feis.name}: ${formatRange(feis.starts_on, feis.ends_on)}${place ? ` in ${place}` : ""}`,
    description: `${feis.name} is an Irish dance competition on ${formatRange(feis.starts_on, feis.ends_on)}${placeOf(feis) ? ` at ${placeOf(feis)}` : ""}. Dates, venue and a direct link to the organizer's official registration page.`,
    alternates: { canonical: `/feis/${feis.id}` },
  };
}

export default async function FeisDetailPage({ params }: PageProps<"/feis/[id]">) {
  const { id } = await params;
  const feis = await getFeis(id);
  if (!feis) notFound();
  const host = hostOf(feis);
  const today = new Date().toISOString().slice(0, 10);
  const hasEnded = feis.ends_on < today;
  const state = stateOf(feis.region);

  // Other upcoming feiseanna in the same state, for families nearby.
  let nearby: FeisRow[] = [];
  if (state) {
    const supabase = await createClient();
    const { data } = await supabase
      .from("feis_events")
      .select("id, name, starts_on, ends_on, venue_name, city, region, country, registration_url, schools(name, slug)")
      .eq("status", "published")
      .gte("ends_on", today)
      .neq("id", feis.id)
      .order("starts_on")
      .limit(200);
    nearby = ((data ?? []) as FeisRow[]).filter((e) => stateOf(e.region)?.slug === state.slug).slice(0, 5);
  }

  const eventJsonLd = {
    "@context": "https://schema.org",
    "@type": "Event",
    name: feis.name,
    startDate: feis.starts_on,
    endDate: feis.ends_on,
    eventStatus: "https://schema.org/EventScheduled",
    eventAttendanceMode: "https://schema.org/OfflineEventAttendanceMode",
    url: `${SITE_URL}/feis/${feis.id}`,
    ...(feis.venue_name || feis.city
      ? {
          location: {
            "@type": "Place",
            ...(feis.venue_name ? { name: feis.venue_name } : {}),
            address: {
              "@type": "PostalAddress",
              ...(feis.city ? { addressLocality: feis.city } : {}),
              ...(feis.region ? { addressRegion: feis.region } : {}),
              ...(feis.country ? { addressCountry: feis.country } : {}),
            },
          },
        }
      : {}),
    ...(host
      ? {
          organizer: {
            "@type": "Organization",
            name: host.name,
            url: `${SITE_URL}/schools/${host.slug}`,
          },
        }
      : {}),
  };

  return (
    <div className="space-y-4">
      <JsonLd data={eventJsonLd} />
      <Link href="/feis" className="link">
        &larr; Back to feis calendar
      </Link>
      <div>
        <p className="text-sm font-semibold text-brand-700">{formatRange(feis.starts_on, feis.ends_on)}</p>
        <h1 className="page-title">{feis.name}</h1>
        {placeOf(feis) ? <p className="text-gray-600">{placeOf(feis)}</p> : null}
        {host ? (
          <p className="text-sm text-gray-500">
            Hosted by{" "}
            <Link href={`/schools/${host.slug}`} className="link">
              {host.name}
            </Link>
          </p>
        ) : null}
      </div>
      {hasEnded ? (
        <p className="rounded-xl bg-brand-50 p-3 text-sm text-brand-900">
          This feis has already taken place. Its details stay here for reference; see the{" "}
          <Link href="/feis" className="link">
            calendar
          </Link>{" "}
          for upcoming competitions.
        </p>
      ) : (
        <>
          <a href={feis.registration_url} target="_blank" rel="noopener noreferrer nofollow" className="btn w-full">
            Register on organizer&apos;s site ↗
          </a>
          <p className="text-sm text-gray-600">
            Registration happens on the organizer&apos;s own site. Dates and details can change, so always
            confirm there before you travel.
          </p>
        </>
      )}
      {state ? (
        <p className="text-sm text-gray-600">
          <Link href={`/feis/state/${state.slug}`} className="link">
            All upcoming feiseanna in {state.name}
          </Link>{" "}
          ·{" "}
          <Link href={`/schools/state/${state.slug}`} className="link">
            Irish dance schools in {state.name}
          </Link>
        </p>
      ) : null}
      {nearby.length ? (
        <section aria-label="More feiseanna in this state">
          <h2 className="mb-2 text-lg font-semibold">More feiseanna in {state?.name}</h2>
          <ul className="space-y-3">
            {nearby.map((e) => (
              <li key={e.id} className="card space-y-1">
                <p className="text-sm font-semibold text-brand-700">{formatRange(e.starts_on, e.ends_on)}</p>
                <p className="font-semibold">
                  <Link href={`/feis/${e.id}`} className="link">
                    {e.name}
                  </Link>
                </p>
                <p className="text-sm text-gray-600">{placeOf(e)}</p>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
    </div>
  );
}
