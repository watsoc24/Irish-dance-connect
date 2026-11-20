import type { MetadataRoute } from "next";
import { createClient } from "@/lib/supabase/server";
import { SITE_URL } from "@/lib/site";
import { VENDORS } from "@/lib/vendors";

/**
 * Sitemap: every static public route, one entry per school detail page
 * (the directory lists every school publicly, claimed or not), and one
 * per vendor profile. Feis events have no detail pages, so /feis itself
 * is the entry. Marketplace listings are deliberately absent: browsing
 * requires sign-in, so listing URLs redirect crawlers to the login page
 * and are not indexable today.
 *
 * If the schools query fails, the sitemap falls back to the static and
 * vendor routes rather than failing outright.
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
      .select("slug, updated_at")
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
    }
  } catch {
    // Static and vendor entries above still make a valid sitemap.
  }

  return entries;
}
