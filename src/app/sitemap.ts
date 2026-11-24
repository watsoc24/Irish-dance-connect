import type { MetadataRoute } from "next";
import { createClient } from "@/lib/supabase/server";
import { SITE_URL } from "@/lib/site";
import { VENDORS } from "@/lib/vendors";
import { statesWithCounts } from "@/lib/states";

/**
 * Sitemap: every static public route, one entry per school detail page
 * (the directory lists every school publicly, claimed or not), one per
 * vendor profile, one per upcoming feis detail page, and the state
 * landing pages (school states with at least 3 schools, feis states
 * with at least 1 upcoming feis). Marketplace listings are deliberately
 * absent: browsing requires sign-in, so listing URLs redirect crawlers
 * to the login page and are not indexable today.
 *
 * If a query fails, the sitemap falls back to the entries built so far
 * rather than failing outright.
 */
export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const base = SITE_URL;
  const now = new Date();

  const entries: MetadataRoute.Sitemap = [
    { url: `${base}/`, lastModified: now, changeFrequency: "weekly", priority: 1 },
    { url: `${base}/feis`, lastModified: now, changeFrequency: "daily", priority: 0.9 },
    { url: `${base}/feis/calculator`, lastModified: now, changeFrequency: "monthly", priority: 0.7 },
    { url: `${base}/schools`, lastModified: now, changeFrequency: "weekly", priority: 0.9 },
    { url: `${base}/practice`, lastModified: now, changeFrequency: "monthly", priority: 0.8 },
    { url: `${base}/practice/fundamentals`, lastModified: now, changeFrequency: "monthly", priority: 0.6 },
    { url: `${base}/practice/conditioning`, lastModified: now, changeFrequency: "monthly", priority: 0.6 },
    { url: `${base}/parents`, lastModified: now, changeFrequency: "daily", priority: 0.7 },
    { url: `${base}/vendors`, lastModified: now, changeFrequency: "monthly", priority: 0.7 },
    { url: `${base}/vendors/featured`, lastModified: now, changeFrequency: "monthly", priority: 0.5 },
    { url: `${base}/privacy`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
    { url: `${base}/terms`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
    { url: `${base}/safety`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
  ];

  for (const vendor of VENDORS) {
    entries.push({
      url: `${base}/vendors/${vendor.slug}`,
      lastModified: now,
      changeFrequency: "monthly",
      priority: 0.6,
    });
  }

  try {
    const supabase = await createClient();
    const { data, error } = await supabase
      .from("schools")
      .select("slug, updated_at, region")
      .order("slug")
      .limit(5000);
    if (!error && data) {
      for (const school of data) {
        entries.push({
          url: `${base}/schools/${school.slug}`,
          lastModified: school.updated_at ? new Date(school.updated_at) : now,
          changeFrequency: "monthly",
          priority: 0.6,
        });
      }
      for (const { state, count } of statesWithCounts(data.map((s) => s.region as string | null))) {
        if (count < 3) continue;
        entries.push({
          url: `${base}/schools/state/${state.slug}`,
          lastModified: now,
          changeFrequency: "monthly",
          priority: 0.7,
        });
      }
    }

    const today = now.toISOString().slice(0, 10);
    const { data: feisRows, error: feisError } = await supabase
      .from("feis_events")
      .select("id, region")
      .eq("status", "published")
      .gte("ends_on", today)
      .order("starts_on")
      .limit(500);
    if (!feisError && feisRows) {
      for (const feis of feisRows) {
        entries.push({
          url: `${base}/feis/${feis.id}`,
          lastModified: now,
          changeFrequency: "weekly",
          priority: 0.7,
        });
      }
      for (const { state } of statesWithCounts(feisRows.map((f) => f.region as string | null))) {
        entries.push({
          url: `${base}/feis/state/${state.slug}`,
          lastModified: now,
          changeFrequency: "weekly",
          priority: 0.7,
        });
      }
    }
  } catch {
    // Static and vendor entries above still make a valid sitemap.
  }

  return entries;
}
