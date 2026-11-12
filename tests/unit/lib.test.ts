import { describe, expect, it } from "vitest";
import { parseMoneyToCents, platformFeeCents } from "@/lib/money";
import { safeNext } from "@/lib/safe-redirect";
import { buildCsp } from "@/lib/csp";
import { claimSchema, feisSchema, listingSchema, searchTerm, signUpSchema } from "@/lib/validation";
import { findRegion, regionMatches } from "@/lib/idtana-regions";
import { formatMiles, haversineMiles, isValidZip, normalizeZip, sortSchoolsByDistance } from "@/lib/geo";

describe("platform fee", () => {
  it("is 7% rounded to the nearest cent", () => {
    expect(platformFeeCents(10000)).toBe(700);
    expect(platformFeeCents(2500)).toBe(175);
    expect(platformFeeCents(1999)).toBe(140); // 139.93 -> 140
  });
  it("rejects invalid amounts", () => {
    expect(() => platformFeeCents(0)).toThrow();
    expect(() => platformFeeCents(10.5)).toThrow();
  });
});

describe("money parsing", () => {
  it("parses prices", () => {
    expect(parseMoneyToCents("120")).toBe(12000);
    expect(parseMoneyToCents("120.5")).toBe(12050);
    expect(parseMoneyToCents("$45.99")).toBe(4599);
  });
  it("rejects junk", () => {
    for (const bad of ["", "-5", "1e5", "12.345", "abc", "1,000"]) expect(parseMoneyToCents(bad)).toBeNull();
  });
});

describe("safeNext (open redirect protection)", () => {
  it("allows relative paths", () => {
    expect(safeNext("/marketplace/abc")).toBe("/marketplace/abc");
    expect(safeNext("/feis?where=Boston")).toBe("/feis?where=Boston");
  });
  it("blocks external and protocol-relative URLs", () => {
    for (const bad of ["https://evil.test", "//evil.test", "/\\evil.test", "/\t/evil.test", "/%09/evil.test".replace("%09", "\t"), "javascript:alert(1)", "/a\r\nb", 5]) {
      expect(safeNext(bad)).toBe("/account");
    }
  });
});

describe("CSP", () => {
  it("uses a nonce and blocks framing and plugins in production", () => {
    const csp = buildCsp("abc", false);
    expect(csp).toContain("'nonce-abc'");
    expect(csp).toContain("frame-ancestors 'none'");
    expect(csp).toContain("object-src 'none'");
    expect(csp).not.toContain("unsafe-eval");
    expect(csp).not.toMatch(/script-src[^;]*unsafe-inline/);
  });
});

describe("search terms", () => {
  it("strips characters that could change PostgREST filters", () => {
    expect(searchTerm('Boston",status.eq.pending')).toBe("Bostonstatuseqpending");
    expect(searchTerm("St. Louis (MO)")).toBe("St Louis MO");
    expect(searchTerm("Ó Riada")).toBe("Ó Riada");
  });
});

describe("form validation", () => {
  it("requires adult confirmation on signup", () => {
    const r = signUpSchema.safeParse({ displayName: "Sam", email: "a@b.co", password: "longenough1", role: "parent", terms: "yes" });
    expect(r.success).toBe(false);
  });
  it("rejects unknown roles at signup", () => {
    const r = signUpSchema.safeParse({ displayName: "Sam", email: "a@b.co", password: "longenough1", role: "platform_admin", adult: "yes", terms: "yes" });
    expect(r.success).toBe(false);
  });
  it("enforces listing price minimum and strips control characters", () => {
    const base = { title: "Dress\u0000", category: "solo_dress", size_label: "10", condition: "good", city: "A", region: "B", country: "US", shipping: "0" };
    expect(listingSchema.safeParse({ ...base, price: "5" }).success).toBe(false);
    const ok = listingSchema.safeParse({ ...base, price: "150" });
    expect(ok.success && ok.data.title).toBe("Dress");
  });
  it("only accepts https registration links for feis events", () => {
    const base = { name: "Test Feis", startsOn: "2027-01-01", endsOn: "2027-01-02", city: "X", country: "US" };
    expect(feisSchema.safeParse({ ...base, registrationUrl: "javascript:alert(1)" }).success).toBe(false);
    expect(feisSchema.safeParse({ ...base, registrationUrl: "http://example.com" }).success).toBe(false);
    expect(feisSchema.safeParse({ ...base, registrationUrl: "https://example.com/reg" }).success).toBe(true);
    expect(feisSchema.safeParse({ ...base, endsOn: "2026-12-31", registrationUrl: "https://e.com" }).success).toBe(false);
  });
  it("requires a school name or id for claims", () => {
    const base = { claimantTitle: "Owner", contactEmail: "a@b.co", evidence: "We are on the website." };
    expect(claimSchema.safeParse(base).success).toBe(false);
    expect(claimSchema.safeParse({ ...base, proposedName: "Scoil Rince" }).success).toBe(true);
  });
});

describe("IDTANA region filter", () => {
  it("matches a state by full name or abbreviation, case-insensitively", () => {
    expect(regionMatches("Pennsylvania", "mid-atlantic")).toBe(true);
    expect(regionMatches("PA", "mid-atlantic")).toBe(true);
    expect(regionMatches("pa", "mid-atlantic")).toBe(true);
    expect(regionMatches("Ohio", "mid-america")).toBe(true);
    expect(regionMatches("Ontario", "eastern-canada")).toBe(true);
  });
  it("does not match a state from another region", () => {
    expect(regionMatches("Pennsylvania", "southern")).toBe(false);
    expect(regionMatches("Texas", "mid-atlantic")).toBe(false);
  });
  it("does not match empty or unknown values", () => {
    expect(regionMatches(null, "southern")).toBe(false);
    expect(regionMatches("", "southern")).toBe(false);
    expect(regionMatches("Paris", "western-us")).toBe(false);
  });
  it("finds regions by slug only", () => {
    expect(findRegion("western-us")?.label).toBe("Western US");
    expect(findRegion("nowhere")).toBeUndefined();
    expect(findRegion(undefined)).toBeUndefined();
  });
});

describe("ZIP codes", () => {
  it("accepts exactly five digits", () => {
    expect(isValidZip("45226")).toBe(true);
    expect(isValidZip("02127")).toBe(true);
    expect(normalizeZip("45226")).toBe("45226");
    expect(normalizeZip("  45226  ")).toBe("45226");
  });
  it("rejects anything that is not a 5-digit ZIP", () => {
    for (const bad of ["4522", "452266", "4522a", "ABCDE", "45 226", "", "45226-123", null, undefined, 45226]) {
      expect(isValidZip(bad)).toBe(false);
      expect(normalizeZip(bad)).toBeNull();
    }
  });
  it("normalizes ZIP+4 to the 5-digit ZIP", () => {
    expect(normalizeZip("45226-1234")).toBe("45226");
    expect(isValidZip("45226-1234")).toBe(false);
  });
});

describe("Haversine distance", () => {
  it("is zero for the same point", () => {
    expect(haversineMiles({ latitude: 41, longitude: -81 }, { latitude: 41, longitude: -81 })).toBe(0);
  });
  it("is about 69.1 miles per degree of latitude", () => {
    expect(haversineMiles({ latitude: 0, longitude: 0 }, { latitude: 1, longitude: 0 })).toBeCloseTo(69.1, 1);
  });
  it("matches known city pairs", () => {
    // Cincinnati -> Dayton, straight-line
    expect(
      haversineMiles({ latitude: 39.1031, longitude: -84.512 }, { latitude: 39.7589, longitude: -84.1916 }),
    ).toBeCloseTo(48.4, 1);
    // New York -> Los Angeles, straight-line
    expect(
      haversineMiles({ latitude: 40.7128, longitude: -74.006 }, { latitude: 34.0522, longitude: -118.2437 }),
    ).toBeCloseTo(2445.7, 0);
  });
  it("is symmetric", () => {
    const a = { latitude: 39.1, longitude: -84.5 };
    const b = { latitude: 41.5, longitude: -81.7 };
    expect(haversineMiles(a, b)).toBeCloseTo(haversineMiles(b, a), 10);
  });
  it("formats to one decimal place", () => {
    expect(formatMiles(12.345)).toBe("12.3");
    expect(formatMiles(0)).toBe("0.0");
  });
});

describe("nearest-first school sort", () => {
  const origin = { latitude: 39.1031, longitude: -84.512 }; // Cincinnati
  const schools = [
    { name: "Far Away", latitude: 41.5, longitude: -81.7 },
    { name: "No Coordinates", latitude: null, longitude: null },
    { name: "Nearby", latitude: 39.2, longitude: -84.4 },
    { name: "Also No Coordinates", latitude: null, longitude: null },
  ];
  it("sorts geocoded schools nearest-first and ungeocoded schools last", () => {
    const sorted = sortSchoolsByDistance(schools, origin);
    expect(sorted.map((r) => r.school.name)).toEqual([
      "Nearby",
      "Far Away",
      "Also No Coordinates",
      "No Coordinates",
    ]);
    expect(sorted[0].distanceMiles).toBeGreaterThan(0);
    expect(sorted[0].distanceMiles).toBeLessThan(sorted[1].distanceMiles!);
    expect(sorted[2].distanceMiles).toBeNull();
    expect(sorted[3].distanceMiles).toBeNull();
  });
  it("returns an empty list for no schools", () => {
    expect(sortSchoolsByDistance([], origin)).toEqual([]);
  });
});
