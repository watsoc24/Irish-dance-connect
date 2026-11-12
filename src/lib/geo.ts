/**
 * Geography helpers for the school directory: US ZIP validation, ZIP ->
 * coordinates, and straight-line (Haversine) distances in miles.
 *
 * ZIP lookup uses the free Zippopotam.us API (place data from GeoNames,
 * CC BY). No key, no account. About 4% of US ZIPs — mostly PO-box-only and
 * very new ones — 404 there; callers must handle `not_found` with a clear
 * message instead of failing the page.
 *
 * Distances are straight-line ("as the crow flies"), never driving
 * distances, and are always labelled that way in the UI. Schools whose
 * coordinates are only a city centroid are marked approximate.
 */

export const EARTH_RADIUS_MILES = 3959;

/** Exactly five ASCII digits. */
const ZIP_PATTERN = /^[0-9]{5}$/;
/** Five digits plus the optional ZIP+4 suffix. */
const ZIP_PLUS_4_PATTERN = /^([0-9]{5})-[0-9]{4}$/;

export function isValidZip(value: unknown): value is string {
  return typeof value === "string" && ZIP_PATTERN.test(value);
}

/**
 * Normalizes user input to a 5-digit ZIP, or null when it is not one.
 * Trims whitespace and accepts ZIP+4 ("45226-1234" -> "45226").
 */
export function normalizeZip(value: unknown): string | null {
  if (typeof value !== "string") return null;
  const trimmed = value.trim();
  if (ZIP_PATTERN.test(trimmed)) return trimmed;
  const plus4 = ZIP_PLUS_4_PATTERN.exec(trimmed);
  return plus4 ? plus4[1] : null;
}

export interface GeoPoint {
  latitude: number;
  longitude: number;
}

/** Straight-line distance between two points, in miles (Haversine, R=3959). */
export function haversineMiles(a: GeoPoint, b: GeoPoint): number {
  const toRad = (deg: number) => (deg * Math.PI) / 180;
  const dLat = toRad(b.latitude - a.latitude);
  const dLng = toRad(b.longitude - a.longitude);
  const lat1 = toRad(a.latitude);
  const lat2 = toRad(b.latitude);
  const h =
    Math.sin(dLat / 2) ** 2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLng / 2) ** 2;
  return 2 * EARTH_RADIUS_MILES * Math.asin(Math.min(1, Math.sqrt(h)));
}

export interface ZipLookup {
  zip: string;
  latitude: number;
  longitude: number;
  city: string;
  state: string;
}

export type ZipLookupResult =
  | { ok: true; place: ZipLookup }
  | { ok: false; reason: "not_found" | "unavailable" };

/**
 * Resolves a 5-digit US ZIP to coordinates via Zippopotam.us.
 * Returns `not_found` for ZIPs the service has no place for (HTTP 404)
 * and `unavailable` for network/server failures. Results are cached for a
 * day — ZIP centroids do not change.
 */
export async function lookupZip(zip: string): Promise<ZipLookupResult> {
  let res: Response;
  try {
    res = await fetch(`https://api.zippopotam.us/us/${zip}`, {
      headers: { accept: "application/json" },
      next: { revalidate: 86_400 },
    });
  } catch {
    return { ok: false, reason: "unavailable" };
  }
  if (res.status === 404) return { ok: false, reason: "not_found" };
  if (!res.ok) return { ok: false, reason: "unavailable" };
  let json: unknown;
  try {
    json = await res.json();
  } catch {
    return { ok: false, reason: "unavailable" };
  }
  const place = (json as { places?: { latitude?: unknown; longitude?: unknown; "place name"?: unknown; state?: unknown; "state abbreviation"?: unknown }[] })?.places?.[0];
  const latitude = Number(place?.latitude);
  const longitude = Number(place?.longitude);
  if (!place || !Number.isFinite(latitude) || !Number.isFinite(longitude)) {
    return { ok: false, reason: "not_found" };
  }
  return {
    ok: true,
    place: {
      zip,
      latitude,
      longitude,
      city: typeof place["place name"] === "string" ? place["place name"] : "",
      state:
        typeof place["state abbreviation"] === "string"
          ? place["state abbreviation"]
          : typeof place.state === "string"
            ? place.state
            : "",
    },
  };
}

export interface SchoolWithDistance<T> {
  school: T;
  /** Straight-line miles from the search origin, or null when the school has no coordinates. */
  distanceMiles: number | null;
}

/**
 * Attaches a straight-line distance to each school and sorts nearest-first.
 * Schools without coordinates sort after every geocoded school, in name
 * order; geocoded schools with equal distances keep name order too.
 */
export function sortSchoolsByDistance<T extends { latitude: number | null; longitude: number | null; name: string }>(
  schools: readonly T[],
  origin: GeoPoint,
): SchoolWithDistance<T>[] {
  const withDistance = schools.map((school) => ({
    school,
    distanceMiles:
      school.latitude === null || school.longitude === null
        ? null
        : haversineMiles(origin, { latitude: school.latitude, longitude: school.longitude }),
  }));
  withDistance.sort((a, b) => {
    if (a.distanceMiles === null && b.distanceMiles === null) {
      return a.school.name.localeCompare(b.school.name);
    }
    if (a.distanceMiles === null) return 1;
    if (b.distanceMiles === null) return -1;
    return a.distanceMiles - b.distanceMiles || a.school.name.localeCompare(b.school.name);
  });
  return withDistance;
}

/** "12.3" — one decimal place, for display next to a school. */
export function formatMiles(miles: number): string {
  return miles.toFixed(1);
}
