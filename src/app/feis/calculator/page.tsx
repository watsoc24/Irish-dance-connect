import Link from "next/link";
import { FeisCalculator, type FeisListing } from "@/components/feis-calculator";
import { createClient } from "@/lib/supabase/server";

export const metadata = { title: "Feis stage time calculator" };

/**
 * Published, upcoming feiseanna for the calculator's name typeahead.
 * feis_events has no state column: the region column holds the state
 * name, the same way the feis calendar renders it in its location line.
 * Any failure returns an empty list and the field stays plain free text.
 */
async function fetchFeisListings(): Promise<FeisListing[]> {
  try {
    const supabase = await createClient();
    const today = new Date().toISOString().slice(0, 10);
    const { data, error } = await supabase
      .from("feis_events")
      .select("id, name, starts_on, ends_on, city, region")
      .eq("status", "published")
      .gte("ends_on", today)
      .order("starts_on")
      .limit(200);
    if (error || !data) return [];
    return data.map((e) => ({
      id: e.id,
      name: e.name,
      startsOn: e.starts_on,
      endsOn: e.ends_on,
      city: e.city,
      state: e.region ?? "",
    }));
  } catch {
    return [];
  }
}

export default async function FeisCalculatorPage() {
  const feisListings = await fetchFeisListings();
  return (
    <div className="space-y-4">
      <h1 className="page-title">Stage time calculator</h1>
      <p className="text-sm text-gray-600">
        Feis day runs on one question: when is my dancer on? Enter your dancer&apos;s competition
        number, the stage start time, and the running order from the feis schedule, and we will
        estimate the rest. Competition numbers usually put the level first and the age group last, so
        713 is Open Championship, age 13, and 206 is Beginner 1, age 6. Your entries are saved on this
        device, so they are still here when you check again later.
      </p>
      <FeisCalculator feisListings={feisListings} />
      <p className="text-sm text-gray-600">
        Looking for a feis to enter? Browse the <Link href="/feis" className="link">feis calendar</Link>.
      </p>
    </div>
  );
}
