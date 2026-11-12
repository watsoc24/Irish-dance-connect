/**
 * IDTANA regions, used to filter the feis calendar.
 *
 * The `feis_events.region` column stores free text — usually the state or
 * province the submitter typed ("Pennsylvania", "PA", "Ontario", ...).
 * These lists map each IDTANA region to the place names and abbreviations
 * that belong to it, so the filter works whatever form the stored value
 * took. A place that matches no region (e.g. a country outside North
 * America) simply has no region and is only shown with "All regions".
 */

export interface IdtanaRegion {
  slug: string;
  label: string;
  /** Full place names, e.g. "Pennsylvania". */
  places: string[];
  /** Abbreviations, e.g. "PA". */
  abbreviations: string[];
}

export const IDTANA_REGIONS: IdtanaRegion[] = [
  {
    slug: "new-england",
    label: "New England",
    places: ["Connecticut", "Maine", "Massachusetts", "New Hampshire", "Rhode Island", "Vermont"],
    abbreviations: ["CT", "ME", "MA", "NH", "RI", "VT"],
  },
  {
    slug: "mid-atlantic",
    label: "Mid-Atlantic",
    places: [
      "New York",
      "New Jersey",
      "Pennsylvania",
      "Delaware",
      "Maryland",
      "District of Columbia",
      "Washington DC",
    ],
    abbreviations: ["NY", "NJ", "PA", "DE", "MD", "DC"],
  },
  {
    slug: "southern",
    label: "Southern",
    places: [
      "Virginia",
      "North Carolina",
      "South Carolina",
      "Georgia",
      "Florida",
      "Tennessee",
      "Alabama",
      "Mississippi",
      "Texas",
      "Oklahoma",
      "Mexico",
    ],
    abbreviations: ["VA", "NC", "SC", "GA", "FL", "TN", "AL", "MS", "TX", "OK"],
  },
  {
    slug: "mid-america",
    label: "Mid-America",
    places: [
      "Illinois",
      "Indiana",
      "Iowa",
      "Kansas",
      "Kentucky",
      "Michigan",
      "Minnesota",
      "Missouri",
      "Nebraska",
      "North Dakota",
      "Ohio",
      "South Dakota",
      "Wisconsin",
    ],
    abbreviations: ["IL", "IN", "IA", "KS", "KY", "MI", "MN", "MO", "NE", "ND", "OH", "SD", "WI"],
  },
  {
    slug: "western-us",
    label: "Western US",
    places: [
      "Washington",
      "Oregon",
      "California",
      "Nevada",
      "Idaho",
      "Montana",
      "Wyoming",
      "Utah",
      "Colorado",
      "Arizona",
      "New Mexico",
      "Alaska",
      "Hawaii",
    ],
    abbreviations: ["WA", "OR", "CA", "NV", "ID", "MT", "WY", "UT", "CO", "AZ", "NM", "AK", "HI"],
  },
  {
    slug: "eastern-canada",
    label: "Eastern Canada",
    places: [
      "Ontario",
      "Quebec",
      "New Brunswick",
      "Nova Scotia",
      "Prince Edward Island",
      "Newfoundland and Labrador",
    ],
    abbreviations: ["ON", "QC", "NB", "NS", "PE", "NL"],
  },
  {
    slug: "western-canada",
    label: "Western Canada",
    places: ["British Columbia", "Alberta", "Saskatchewan", "Manitoba"],
    abbreviations: ["BC", "AB", "SK", "MB"],
  },
];

export function findRegion(slug: string | null | undefined): IdtanaRegion | undefined {
  if (!slug) return undefined;
  return IDTANA_REGIONS.find((r) => r.slug === slug);
}

function normalize(place: string): string {
  return place.trim().toLowerCase().replace(/\./g, "");
}

/** True when the stored region value belongs to the given IDTANA region slug. */
export function regionMatches(place: string | null | undefined, slug: string): boolean {
  if (!place) return false;
  const region = findRegion(slug);
  if (!region) return false;
  const value = normalize(place);
  return (
    region.places.some((p) => normalize(p) === value) ||
    region.abbreviations.some((a) => a.toLowerCase() === value)
  );
}
