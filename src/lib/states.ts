/**
 * US states, DC and Canadian provinces, for the state landing pages
 * (/schools/state/[state] and /feis/state/[state]).
 *
 * The schools.region and feis_events.region columns store free text,
 * usually the full place name ("Ohio", "New York", "Ontario") but
 * sometimes the abbreviation ("OH"). Matching accepts either form.
 */

export interface StateInfo {
  slug: string;
  name: string;
  abbr: string;
  country: "US" | "CA";
}

function slugify(name: string): string {
  return name.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
}

const RAW: [string, string, "US" | "CA"][] = [
  ["Alabama", "AL", "US"], ["Alaska", "AK", "US"], ["Arizona", "AZ", "US"], ["Arkansas", "AR", "US"],
  ["California", "CA", "US"], ["Colorado", "CO", "US"], ["Connecticut", "CT", "US"], ["Delaware", "DE", "US"],
  ["District of Columbia", "DC", "US"], ["Florida", "FL", "US"], ["Georgia", "GA", "US"], ["Hawaii", "HI", "US"],
  ["Idaho", "ID", "US"], ["Illinois", "IL", "US"], ["Indiana", "IN", "US"], ["Iowa", "IA", "US"],
  ["Kansas", "KS", "US"], ["Kentucky", "KY", "US"], ["Louisiana", "LA", "US"], ["Maine", "ME", "US"],
  ["Maryland", "MD", "US"], ["Massachusetts", "MA", "US"], ["Michigan", "MI", "US"], ["Minnesota", "MN", "US"],
  ["Mississippi", "MS", "US"], ["Missouri", "MO", "US"], ["Montana", "MT", "US"], ["Nebraska", "NE", "US"],
  ["Nevada", "NV", "US"], ["New Hampshire", "NH", "US"], ["New Jersey", "NJ", "US"], ["New Mexico", "NM", "US"],
  ["New York", "NY", "US"], ["North Carolina", "NC", "US"], ["North Dakota", "ND", "US"], ["Ohio", "OH", "US"],
  ["Oklahoma", "OK", "US"], ["Oregon", "OR", "US"], ["Pennsylvania", "PA", "US"], ["Rhode Island", "RI", "US"],
  ["South Carolina", "SC", "US"], ["South Dakota", "SD", "US"], ["Tennessee", "TN", "US"], ["Texas", "TX", "US"],
  ["Utah", "UT", "US"], ["Vermont", "VT", "US"], ["Virginia", "VA", "US"], ["Washington", "WA", "US"],
  ["West Virginia", "WV", "US"], ["Wisconsin", "WI", "US"], ["Wyoming", "WY", "US"],
  ["Alberta", "AB", "CA"], ["British Columbia", "BC", "CA"], ["Manitoba", "MB", "CA"],
  ["New Brunswick", "NB", "CA"], ["Newfoundland and Labrador", "NL", "CA"], ["Nova Scotia", "NS", "CA"],
  ["Ontario", "ON", "CA"], ["Prince Edward Island", "PE", "CA"], ["Quebec", "QC", "CA"],
  ["Saskatchewan", "SK", "CA"],
];

export const STATES: StateInfo[] = RAW.map(([name, abbr, country]) => ({
  slug: slugify(name),
  name,
  abbr,
  country,
}));

export function findState(slug: string | undefined): StateInfo | undefined {
  if (!slug) return undefined;
  return STATES.find((s) => s.slug === slug);
}

/** True when a stored free-text region value names this state/province. */
export function stateMatches(region: string | null | undefined, state: StateInfo): boolean {
  if (!region) return false;
  const value = region.trim().toLowerCase();
  return value === state.name.toLowerCase() || value === state.abbr.toLowerCase();
}

/** The state a stored region value names, if any. */
export function stateOf(region: string | null | undefined): StateInfo | undefined {
  return STATES.find((s) => stateMatches(region, s));
}

/** States present in a set of region values, with counts, biggest first. */
export function statesWithCounts(regions: (string | null | undefined)[]): { state: StateInfo; count: number }[] {
  const counts = new Map<string, number>();
  for (const region of regions) {
    const state = stateOf(region);
    if (state) counts.set(state.slug, (counts.get(state.slug) ?? 0) + 1);
  }
  return STATES.filter((s) => counts.has(s.slug))
    .map((state) => ({ state, count: counts.get(state.slug) ?? 0 }))
    .sort((a, b) => b.count - a.count || a.state.name.localeCompare(b.state.name));
}
