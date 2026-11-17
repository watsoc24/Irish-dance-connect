import { describe, expect, it } from "vitest";
import { barsFor, DANCES, LEVELS, PRACTICE_ENTRIES, tempoFor } from "@/lib/practice-music";

describe("practice music tempo table (spec §2)", () => {
  it("sets Reel / Beginner to 122 BPM", () => {
    expect(tempoFor("reel", "beginner")).toBe(122);
  });
  it("sets Treble Jig / Open Championship to 73 BPM", () => {
    expect(tempoFor("treble-jig", "open-championship")).toBe(73);
    expect(tempoFor("treble-jig", "preliminary-championship")).toBe(73);
  });
  it("re-derives BPM when the level changes", () => {
    expect(tempoFor("reel", "novice")).toBe(113);
    expect(tempoFor("hornpipe", "advanced-beginner")).toBe(138);
    expect(tempoFor("hornpipe", "prizewinner")).toBe(113);
    expect(tempoFor("treble-jig", "novice")).toBe(92);
    expect(tempoFor("treble-jig", "prizewinner")).toBe(73);
  });
  it("maps First Feis to beginner speeds and Adult to novice speeds", () => {
    expect(tempoFor("reel", "first-feis")).toBe(122);
    expect(tempoFor("reel", "adult")).toBe(113);
    expect(tempoFor("treble-reel", "adult")).toBe(113);
  });
  it("returns null where the table has no tempo", () => {
    expect(tempoFor("light-jig", "open-championship")).toBeNull();
    expect(tempoFor("single-jig", "preliminary-championship")).toBeNull();
    expect(tempoFor("treble-jig", "beginner")).toBeNull();
    expect(tempoFor("treble-reel", "advanced-beginner")).toBeNull();
    expect(tempoFor("hornpipe", "first-feis")).toBeNull();
  });
  it("returns null for unknown slugs", () => {
    expect(tempoFor("polka", "beginner")).toBeNull();
    expect(tempoFor("reel", "champion")).toBeNull();
  });
});

describe("practice music bars (spec §2)", () => {
  it("uses 32 bars for grades", () => {
    expect(barsFor("reel", "beginner")).toBe(32);
    expect(barsFor("slip-jig", "prizewinner")).toBe(32);
  });
  it("uses 48 bars for championship Reel / Treble Jig / Treble Reel", () => {
    expect(barsFor("reel", "open-championship")).toBe(48);
    expect(barsFor("treble-jig", "preliminary-championship")).toBe(48);
    expect(barsFor("treble-reel", "open-championship")).toBe(48);
  });
  it("uses 40 bars for championship Slip Jig / Hornpipe", () => {
    expect(barsFor("slip-jig", "open-championship")).toBe(40);
    expect(barsFor("hornpipe", "preliminary-championship")).toBe(40);
  });
});

describe("practice entries", () => {
  it("covers every dance and level slug in the shared contract", () => {
    expect(DANCES.map((d) => d.slug)).toEqual([
      "reel",
      "light-jig",
      "slip-jig",
      "single-jig",
      "treble-jig",
      "hornpipe",
      "treble-reel",
    ]);
    expect(LEVELS.map((l) => l.slug)).toEqual([
      "first-feis",
      "beginner",
      "advanced-beginner",
      "novice",
      "prizewinner",
      "preliminary-championship",
      "open-championship",
      "adult",
    ]);
  });
  it("has an entry exactly where the tempo table has a tempo", () => {
    for (const d of DANCES) {
      for (const l of LEVELS) {
        const entry = PRACTICE_ENTRIES.find((e) => e.dance === d.slug && e.level === l.slug);
        if (tempoFor(d.slug, l.slug) === null) expect(entry).toBeUndefined();
        else expect(entry?.bpm).toBe(tempoFor(d.slug, l.slug));
      }
    }
  });
  it("marks every entry free in this phase", () => {
    expect(PRACTICE_ENTRIES.length).toBeGreaterThan(0);
    expect(PRACTICE_ENTRIES.every((e) => e.access === "free")).toBe(true);
  });
  it("only links out for listening — https Spotify/YouTube searches, never Apple Music", () => {
    for (const e of PRACTICE_ENTRIES) {
      for (const link of e.listen) {
        expect(link.url.startsWith("https://")).toBe(true);
        expect(link.url).not.toContain("apple.com");
        expect(link.url).toMatch(/spotify\.com|youtube\.com/);
      }
      for (const tune of e.tunes) {
        if (tune.sessionUrl) expect(tune.sessionUrl).toMatch(/^https:\/\/thesession\.org\/tunes\/\d+$/);
      }
    }
  });
});
