import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { JsonLd } from "@/components/json-ld";

function placeOf(school: { city: string | null; region: string | null; country: string | null }): string {
  return [school.city, school.region, school.country].filter(Boolean).join(", ");
}

export async function generateMetadata({ params }: PageProps<"/schools/[slug]">): Promise<Metadata> {
  const { slug } = await params;
  if (!/^[a-z0-9-]{1,140}$/.test(slug)) return { title: "School" };
  const supabase = await createClient();
  const { data: school } = await supabase
    .from("schools")
    .select("name, city, region, country, description")
    .eq("slug", slug)
    .maybeSingle();
  if (!school) return { title: "School" };
  const place = placeOf(school);
  const fallback = `${school.name} is an Irish dance school${place ? ` in ${place}` : ""}. See its location, website, contact details and hosted feiseanna on Irish Dance Connect.`;
  return {
    title: place ? `${school.name}, ${school.city ?? school.region ?? school.country}` : school.name,
    description: school.description ? school.description.slice(0, 300) : fallback,
    alternates: { canonical: `/schools/${slug}` },
  };
}

export default async function SchoolPage({ params }: PageProps<"/schools/[slug]">) {
  const { slug } = await params;
  if (!/^[a-z0-9-]{1,140}$/.test(slug)) notFound();
  const supabase = await createClient();
  const { data: school } = await supabase.from("schools").select("*").eq("slug", slug).maybeSingle();
  if (!school) notFound();
  const today = new Date().toISOString().slice(0, 10);
  const { data: events } = await supabase
    .from("feis_events")
    .select("id, name, starts_on, registration_url")
    .eq("host_school_id", school.id)
    .eq("status", "published")
    .gte("ends_on", today)
    .order("starts_on")
    .limit(20);

  // Structured data from the school's own stored fields only. A street
  // address is included only when it is a real address, not a city-level
  // approximation (geo_precision "city").
  const schoolJsonLd = {
    "@context": "https://schema.org",
    "@type": "DanceSchool",
    name: school.name,
    ...(school.description ? { description: school.description } : {}),
    ...(school.website_url ? { url: school.website_url } : {}),
    ...(school.public_email ? { email: school.public_email } : {}),
    address: {
      "@type": "PostalAddress",
      ...(school.street_address && school.geo_precision !== "city"
        ? { streetAddress: school.street_address }
        : {}),
      ...(school.city ? { addressLocality: school.city } : {}),
      ...(school.region ? { addressRegion: school.region } : {}),
      ...(school.postal_code ? { postalCode: school.postal_code } : {}),
      ...(school.country ? { addressCountry: school.country } : {}),
    },
    ...(school.latitude != null && school.longitude != null
      ? { geo: { "@type": "GeoCoordinates", latitude: school.latitude, longitude: school.longitude } }
      : {}),
  };

  return (
    <div className="space-y-4">
      <JsonLd data={schoolJsonLd} />
      <div>
        <h1 className="text-2xl font-bold">{school.name}</h1>
        <p className="text-gray-600">{[school.city, school.region, school.country].filter(Boolean).join(", ")}</p>
        {school.street_address ? (
          <p className="text-gray-600">
            {[school.street_address, school.postal_code].filter(Boolean).join(" ")}
            {school.geo_precision === "city" ? " (approximate location)" : ""}
          </p>
        ) : school.geo_precision === "city" ? (
          <p className="text-gray-600">Location is approximate (city-level only).</p>
        ) : null}
        {school.status === "verified" ? (
          <span className="badge mt-2 bg-brand-50 text-brand-700">Verified by the school</span>
        ) : (
          <span className="badge mt-2">Not yet claimed</span>
        )}
      </div>
      {school.description ? <p className="whitespace-pre-line">{school.description}</p> : null}
      <div className="card space-y-2 text-sm">
        {school.website_url ? (
          <p>
            Website:{" "}
            <a href={school.website_url} target="_blank" rel="noopener noreferrer nofollow" className="link break-all">
              {school.website_url}
            </a>
          </p>
        ) : null}
        {school.public_email ? (
          <p>
            Email:{" "}
            <a href={`mailto:${school.public_email}`} className="link break-all">
              {school.public_email}
            </a>
          </p>
        ) : null}
        {!school.website_url && !school.public_email ? <p className="text-gray-500">No contact details added yet.</p> : null}
      </div>
      {events?.length ? (
        <section>
          <h2 className="mb-2 font-semibold">Upcoming feiseanna hosted</h2>
          <ul className="space-y-2">
            {events.map((e) => (
              <li key={e.id} className="card text-sm">
                <Link href={`/feis/${e.id}`} className="link font-medium">
                  {e.name}
                </Link>{" "}
                · {e.starts_on}{" "}
                <a href={e.registration_url} target="_blank" rel="noopener noreferrer nofollow" className="link">
                  Register ↗
                </a>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
      {school.status !== "verified" ? (
        <Link href={`/schools/claim?school=${school.id}`} className="btn-secondary w-full">
          Is this your school? Claim it
        </Link>
      ) : null}
    </div>
  );
}
