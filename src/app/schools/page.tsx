import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { searchTerm } from "@/lib/validation";
import { formatMiles, lookupZip, normalizeZip, sortSchoolsByDistance } from "@/lib/geo";

export const metadata = { title: "School directory" };

type SchoolRow = {
  id: string;
  name: string;
  slug: string;
  city: string | null;
  region: string | null;
  country: string | null;
  status: string;
  street_address: string | null;
  postal_code: string | null;
  latitude: number | null;
  longitude: number | null;
  geo_precision: string | null;
};

export default async function SchoolsPage({ searchParams }: PageProps<"/schools">) {
  const sp = await searchParams;
  const q = searchTerm(sp.q);
  const rawZip = typeof sp.zip === "string" ? sp.zip : "";
  const zip = normalizeZip(rawZip);

  const supabase = await createClient();
  let query = supabase
    .from("schools")
    .select("id, name, slug, city, region, country, status, street_address, postal_code, latitude, longitude, geo_precision")
    .order("name")
    .limit(200);
  if (q) query = query.or(`name.ilike."%${q}%",city.ilike."%${q}%",region.ilike."%${q}%"`);
  const { data } = await query;
  const schools = (data ?? []) as SchoolRow[];

  // ZIP nearest-first: resolve the ZIP to coordinates, then sort by
  // straight-line distance. Schools without coordinates sort last.
  let zipError: string | null = null;
  let zipNotice: string | null = null;
  let located: { city: string; state: string; zip: string } | null = null;
  let rows: { school: SchoolRow; distanceMiles: number | null }[] = schools.map((school) => ({
    school,
    distanceMiles: null,
  }));
  if (rawZip.trim() !== "") {
    if (!zip) {
      zipError = "Enter a 5-digit US ZIP code, for example 45226.";
    } else {
      const result = await lookupZip(zip);
      if (result.ok) {
        located = { city: result.place.city, state: result.place.state, zip };
        rows = sortSchoolsByDistance(schools, result.place);
      } else if (result.reason === "not_found") {
        zipError = `We couldn't find ZIP code ${zip}. Check it and try again — some PO-box-only and very new ZIP codes aren't in the lookup.`;
      } else {
        zipNotice = "We couldn't reach the ZIP lookup just now, so schools are listed alphabetically.";
      }
    }
  }

  return (
    <div className="space-y-4">
      <h1 className="page-title">Irish dance schools</h1>
      <form className="space-y-2" role="search">
        <input name="q" defaultValue={q} placeholder="School name, city or state" className="input" maxLength={60} aria-label="Search schools" />
        <div className="flex gap-2">
          <input
            name="zip"
            defaultValue={rawZip}
            placeholder="Your ZIP code, e.g. 45226"
            className="input"
            maxLength={10}
            inputMode="numeric"
            autoComplete="postal-code"
            aria-label="Your ZIP code"
          />
          <button className="btn-secondary">Search</button>
        </div>
        <p className="hint">Enter your ZIP code to see the nearest schools first. Distances are straight-line, not driving distances.</p>
      </form>
      {zipError ? (
        <p role="alert" className="rounded-xl bg-red-50 p-3 text-sm text-red-800">
          {zipError}
        </p>
      ) : null}
      {zipNotice ? (
        <p role="status" className="rounded-xl bg-amber-50 p-3 text-sm text-amber-800">
          {zipNotice}
        </p>
      ) : null}
      {located ? (
        <p role="status" className="text-sm text-gray-600">
          Nearest schools to {located.city ? `${located.city}, ${located.state} ` : ""}{located.zip}, nearest first.
        </p>
      ) : null}
      {rows.length ? (
        <ul className="space-y-2">
          {rows.map(({ school: s, distanceMiles }) => (
            <li key={s.id}>
              <Link href={`/schools/${s.slug}`} className="card flex items-center justify-between gap-2">
                <span>
                  <span className="block font-semibold">{s.name}</span>
                  <span className="block text-sm text-gray-500">
                    {[s.street_address, s.city, s.region, s.country].filter(Boolean).join(", ")}
                  </span>
                  {distanceMiles !== null ? (
                    <span className="block text-sm font-medium text-brand-700">
                      {formatMiles(distanceMiles)} mi straight-line
                      {s.geo_precision === "city" ? " · approximate location" : ""}
                    </span>
                  ) : null}
                </span>
                {s.status === "verified" ? <span className="badge shrink-0 bg-brand-50 text-brand-700">Verified</span> : null}
              </Link>
            </li>
          ))}
        </ul>
      ) : (
        <p className="card text-gray-600">No schools found{q || rawZip ? " for that search" : " yet"}.</p>
      )}
      <p className="text-sm text-gray-600">
        Run a school that isn&apos;t listed?{" "}
        <Link href="/schools/claim" className="link">
          Add and verify your school
        </Link>
      </p>
      {located ? (
        <p className="text-xs text-gray-500">
          ZIP lookup by <a href="https://www.zippopotam.us/" target="_blank" rel="noopener noreferrer nofollow" className="link">Zippopotam.us</a> (place data © GeoNames, CC BY).
        </p>
      ) : null}
    </div>
  );
}
