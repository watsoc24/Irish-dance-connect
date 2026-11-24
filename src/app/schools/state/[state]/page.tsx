import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { findState, stateMatches, statesWithCounts } from "@/lib/states";

type SchoolRow = {
  id: string;
  name: string;
  slug: string;
  city: string | null;
  region: string | null;
  country: string | null;
  status: string;
  street_address: string | null;
};

async function schoolsInState(stateSlug: string): Promise<{ state: NonNullable<ReturnType<typeof findState>>; schools: SchoolRow[]; all: SchoolRow[] } | null> {
  const state = findState(stateSlug);
  if (!state) return null;
  const supabase = await createClient();
  const { data } = await supabase
    .from("schools")
    .select("id, name, slug, city, region, country, status, street_address")
    .order("name")
    .limit(1000);
  const all = (data ?? []) as SchoolRow[];
  return { state, schools: all.filter((s) => stateMatches(s.region, state)), all };
}

export async function generateMetadata({ params }: PageProps<"/schools/state/[state]">): Promise<Metadata> {
  const { state: slug } = await params;
  const result = await schoolsInState(slug);
  if (!result) return { title: "Irish Dance Schools" };
  const { state, schools } = result;
  return {
    title: `Irish Dance Schools in ${state.name}`,
    description: `${schools.length} Irish dance schools listed in ${state.name}: locations, websites and contact details, plus the feiseanna they host. Find a school near you on Irish Dance Connect.`,
    alternates: { canonical: `/schools/state/${state.slug}` },
  };
}

export default async function SchoolsByStatePage({ params }: PageProps<"/schools/state/[state]">) {
  const { state: slug } = await params;
  const result = await schoolsInState(slug);
  if (!result) notFound();
  const { state, schools, all } = result;
  const others = statesWithCounts(all.map((s) => s.region)).filter((x) => x.state.slug !== state.slug);

  // Does this state have upcoming feiseanna? Link across when it does.
  const supabase = await createClient();
  const today = new Date().toISOString().slice(0, 10);
  const { data: feisRows } = await supabase
    .from("feis_events")
    .select("region")
    .eq("status", "published")
    .gte("ends_on", today)
    .limit(200);
  const feisCount = (feisRows ?? []).filter((r) => stateMatches(r.region as string | null, state)).length;

  return (
    <div className="space-y-4">
      <Link href="/schools" className="link">
        &larr; All Irish dance schools
      </Link>
      <div>
        <h1 className="page-title">Irish dance schools in {state.name}</h1>
        <p className="text-gray-600">
          {schools.length === 1
            ? `1 Irish dance school is listed in ${state.name}.`
            : `${schools.length} Irish dance schools are listed in ${state.name}.`}{" "}
          Tap a school for its location, website and contact details.
        </p>
        {feisCount ? (
          <p className="mt-1 text-gray-600">
            <Link href={`/feis/state/${state.slug}`} className="link">
              See upcoming feiseanna in {state.name}
            </Link>{" "}
            ({feisCount} coming up).
          </p>
        ) : null}
      </div>
      {schools.length ? (
        <ul className="space-y-2">
          {schools.map((s) => (
            <li key={s.id}>
              <Link href={`/schools/${s.slug}`} className="card flex items-center justify-between gap-2">
                <span>
                  <span className="block font-semibold">{s.name}</span>
                  <span className="block text-sm text-gray-500">
                    {[s.street_address, s.city, s.region, s.country].filter(Boolean).join(", ")}
                  </span>
                </span>
                {s.status === "verified" ? (
                  <span className="badge shrink-0 bg-brand-50 text-brand-700">Verified</span>
                ) : null}
              </Link>
            </li>
          ))}
        </ul>
      ) : (
        <p className="card text-gray-600">
          No schools are listed in {state.name} yet.{" "}
          <Link href="/schools/claim" className="link">
            Add and verify your school
          </Link>
          .
        </p>
      )}
      {others.length ? (
        <section aria-label="Schools in other states">
          <h2 className="mb-2 text-lg font-semibold">Schools in other states</h2>
          <ul className="flex flex-wrap gap-2">
            {others.map(({ state: s, count }) => (
              <li key={s.slug}>
                <Link
                  href={`/schools/state/${s.slug}`}
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
