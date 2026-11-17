// Curated practice-music data for /practice
// (spec: specs/practice-music-and-training-v1.md, Parts A + B).
//
// Static facts only: dance/level lists, time signatures, feis tempos,
// bar counts, traditional tune names and notation links. No audio or
// video is hosted anywhere in this app — every "listen" option is an
// outbound link (a Spotify or YouTube search for the tune at the tempo).
// Traditional tunes are public domain; recordings are not, so we never
// link to a specific recording as if it were ours to give away, and we
// never present a trial-only service (e.g. Apple Music) as free.

export type DanceSlug =
  | "reel"
  | "light-jig"
  | "slip-jig"
  | "single-jig"
  | "treble-jig"
  | "hornpipe"
  | "treble-reel";

export type LevelSlug =
  | "first-feis"
  | "beginner"
  | "advanced-beginner"
  | "novice"
  | "prizewinner"
  | "preliminary-championship"
  | "open-championship"
  | "adult";

export type Access = "free" | "premium";

export interface Dance {
  slug: DanceSlug;
  name: string;
  /** Display form, e.g. "4/4", "6/8 (12/8)", "2/4 or 4/4". */
  timeSignature: string;
  /**
   * Clicks per bar in the metronome, with the accent on beat 1:
   * 4/4 = 4 quarter-note beats, 6/8 = 2 dotted-quarter beats,
   * 9/8 = 3, 12/8 = 4, 2/4 = 2.
   */
  beatsPerBar: number;
}

export interface Level {
  slug: LevelSlug;
  name: string;
}

export interface Tune {
  name: string;
  /** TheSession.org tune page — only set where the URL is verified. */
  sessionUrl?: string;
}

export interface ListenLink {
  label: string;
  url: string;
}

export interface PracticeEntry {
  dance: DanceSlug;
  level: LevelSlug;
  /** Paid tier is designed for, not built — everything is "free" for now. */
  access: Access;
  timeSignature: string;
  bpm: number;
  bars: number;
  tunes: Tune[];
  listen: ListenLink[];
}

export const DANCES: Dance[] = [
  { slug: "reel", name: "Reel", timeSignature: "4/4", beatsPerBar: 4 },
  { slug: "light-jig", name: "Light Jig", timeSignature: "6/8", beatsPerBar: 2 },
  { slug: "slip-jig", name: "Slip Jig", timeSignature: "9/8", beatsPerBar: 3 },
  { slug: "single-jig", name: "Single / Hop Jig", timeSignature: "6/8 (12/8)", beatsPerBar: 2 },
  { slug: "treble-jig", name: "Treble / Heavy / Double Jig", timeSignature: "6/8", beatsPerBar: 2 },
  { slug: "hornpipe", name: "Hornpipe", timeSignature: "2/4 or 4/4", beatsPerBar: 2 },
  { slug: "treble-reel", name: "Treble Reel", timeSignature: "4/4", beatsPerBar: 4 },
];

export const LEVELS: Level[] = [
  { slug: "first-feis", name: "First Feis" },
  { slug: "beginner", name: "Beginner" },
  { slug: "advanced-beginner", name: "Advanced Beginner" },
  { slug: "novice", name: "Novice" },
  { slug: "prizewinner", name: "Prizewinner" },
  { slug: "preliminary-championship", name: "Preliminary Championship" },
  { slug: "open-championship", name: "Open Championship" },
  { slug: "adult", name: "Adult" },
];

export function getDance(slug: string | undefined | null): Dance | undefined {
  return DANCES.find((d) => d.slug === slug);
}

export function getLevel(slug: string | undefined | null): Level | undefined {
  return LEVELS.find((l) => l.slug === slug);
}

// ---------------------------------------------------------------------------
// Tempo table — spec §2, North America (IDTANA), embedded exactly.
// BPM means counted beats per minute (reels/hornpipes are counted on 2
// significant beats per bar), not raw note rate.
//
// The spec table has five columns (Beginner, Adv. Beginner, Novice,
// Prizewinner, Championship). Our eight levels map onto them:
//   first-feis              -> Beginner column (first-feis dancers dance
//                              beginner speeds)
//   preliminary-championship -> Championship column
//   open-championship        -> Championship column
//   adult                    -> Novice column (adult dancers generally
//                              dance novice speeds)
// Two cells in the spec allow either of two speeds; tempoFor must return
// one number, so we use the common progression — the faster speed at
// Novice, the slower, more controlled speed at Prizewinner:
//   Treble Jig  Novice 92 / Prizewinner 73   (spec: "73 or 92")
//   Hornpipe    Novice 138 / Prizewinner 113 (spec: "113 or 138")
// The chart on /practice still shows the spec's "either speed" wording.
// ---------------------------------------------------------------------------

type TempoColumn = "beginner" | "advancedBeginner" | "novice" | "prizewinner" | "championship";

type TempoRow = Record<TempoColumn, number | null>;

const TEMPO_TABLE: Record<DanceSlug, TempoRow> = {
  reel: { beginner: 122, advancedBeginner: 122, novice: 113, prizewinner: 113, championship: 113 },
  "light-jig": { beginner: 115, advancedBeginner: 115, novice: 115, prizewinner: 115, championship: null },
  "slip-jig": { beginner: 122, advancedBeginner: 122, novice: 113, prizewinner: 113, championship: 113 },
  "single-jig": { beginner: 124, advancedBeginner: 124, novice: 124, prizewinner: 124, championship: null },
  "treble-jig": { beginner: null, advancedBeginner: 92, novice: 92, prizewinner: 73, championship: 73 },
  hornpipe: { beginner: null, advancedBeginner: 138, novice: 138, prizewinner: 113, championship: 113 },
  "treble-reel": { beginner: null, advancedBeginner: null, novice: 113, prizewinner: 113, championship: 113 },
};

const LEVEL_TO_COLUMN: Record<LevelSlug, TempoColumn> = {
  "first-feis": "beginner",
  beginner: "beginner",
  "advanced-beginner": "advancedBeginner",
  novice: "novice",
  prizewinner: "prizewinner",
  "preliminary-championship": "championship",
  "open-championship": "championship",
  adult: "novice",
};

/** Feis tempo (BPM) for a dance at a level, or null where the spec table has no tempo. */
export function tempoFor(danceSlug: string, levelSlug: string): number | null {
  const dance = getDance(danceSlug);
  const level = getLevel(levelSlug);
  if (!dance || !level) return null;
  return TEMPO_TABLE[dance.slug][LEVEL_TO_COLUMN[level.slug]];
}

const CHAMPIONSHIP_LEVELS: ReadonlySet<LevelSlug> = new Set(["preliminary-championship", "open-championship"]);

/**
 * Standard bar count for a dance at a level (spec §2): grades dance
 * 32 bars (16 for trophy/short dances); championships add an 8-bar
 * introduction, then 48 bars for Reel / Treble Jig / Treble Reel and
 * 40 bars for Slip Jig / Hornpipe. The 8-bar intro is a note for the
 * dancer, not extra counted bars, so it is not added here.
 */
export function barsFor(danceSlug: string, levelSlug: string): number {
  const dance = getDance(danceSlug);
  const level = getLevel(levelSlug);
  if (!dance || !level) return 32;
  if (CHAMPIONSHIP_LEVELS.has(level.slug)) {
    if (dance.slug === "reel" || dance.slug === "treble-jig" || dance.slug === "treble-reel") return 48;
    if (dance.slug === "slip-jig" || dance.slug === "hornpipe") return 40;
  }
  return 32;
}

// ---------------------------------------------------------------------------
// Tempo chart — the spec §2 table verbatim, for display on /practice.
// "—" means the dance is not danced at that level; "73 or 92" etc. are
// the spec's either-speed cells (tempoFor picks one — see note above).
// ---------------------------------------------------------------------------

export interface TempoChartRow {
  dance: DanceSlug;
  timeSignature: string;
  beginner: string;
  advancedBeginner: string;
  novice: string;
  prizewinner: string;
  championship: string;
}

export const TEMPO_CHART: TempoChartRow[] = [
  { dance: "reel", timeSignature: "4/4", beginner: "122", advancedBeginner: "122", novice: "113", prizewinner: "113", championship: "113" },
  { dance: "light-jig", timeSignature: "6/8", beginner: "115", advancedBeginner: "115", novice: "115", prizewinner: "115", championship: "—" },
  { dance: "slip-jig", timeSignature: "9/8", beginner: "122", advancedBeginner: "122", novice: "113", prizewinner: "113", championship: "113" },
  { dance: "single-jig", timeSignature: "6/8 (12/8)", beginner: "124", advancedBeginner: "124", novice: "124", prizewinner: "124", championship: "—" },
  { dance: "treble-jig", timeSignature: "6/8", beginner: "—", advancedBeginner: "92", novice: "73 or 92", prizewinner: "73 or 92", championship: "73" },
  { dance: "hornpipe", timeSignature: "2/4 or 4/4", beginner: "—", advancedBeginner: "138", novice: "113 or 138", prizewinner: "113 or 138", championship: "113" },
  { dance: "treble-reel", timeSignature: "4/4", beginner: "—", advancedBeginner: "—", novice: "113", prizewinner: "113", championship: "113" },
];

// ---------------------------------------------------------------------------
// Traditional tunes per dance. Well-known session standards. A
// TheSession.org link is included only where the tune's page URL has
// been verified — never guess a tune URL.
// ---------------------------------------------------------------------------

const TUNES: Record<DanceSlug, Tune[]> = {
  reel: [
    { name: "The Silver Spear" },
    { name: "Cooley's Reel", sessionUrl: "https://thesession.org/tunes/1" },
    { name: "The Maid Behind the Bar" },
    { name: "Drowsy Maggie" },
    { name: "The Wind That Shakes the Barley" },
  ],
  "light-jig": [
    { name: "The Irish Washerwoman" },
    { name: "The Kesh" },
    { name: "The Lilting Banshee" },
    { name: "Haste to the Wedding" },
    { name: "The Rakes of Mallow" },
  ],
  "slip-jig": [
    { name: "The Butterfly", sessionUrl: "https://thesession.org/tunes/10" },
    { name: "The Kid on the Mountain" },
    { name: "The Rocky Road to Dublin" },
    { name: "A Fig for a Kiss" },
    { name: "Dever the Dancer" },
  ],
  "single-jig": [
    { name: "The Humours of Glendart" },
    { name: "The Blarney Pilgrim" },
    { name: "The Blackthorn Stick" },
    { name: "Off She Goes" },
  ],
  "treble-jig": [
    { name: "The Frost Is All Over" },
    { name: "The Connaughtman's Rambles" },
    { name: "The Mug of Brown Ale" },
    { name: "The Gander in the Pratie Hole" },
  ],
  hornpipe: [
    { name: "The Boys of Bluehill" },
    { name: "The Harvest Home" },
    { name: "The Rights of Man" },
    { name: "The Liverpool Hornpipe" },
  ],
  "treble-reel": [
    { name: "The Silver Spear" },
    { name: "Cooley's Reel", sessionUrl: "https://thesession.org/tunes/1" },
    { name: "The Maid Behind the Bar" },
    { name: "The Gravel Walk" },
  ],
};

/** Outbound listen links only: searches for the tune at the feis tempo. */
function listenLinks(tuneName: string, danceName: string, bpm: number): ListenLink[] {
  const query = `${tuneName} ${danceName} ${bpm}`;
  return [
    { label: "Spotify", url: `https://open.spotify.com/search/${encodeURIComponent(query)}` },
    { label: "YouTube", url: `https://www.youtube.com/results?search_query=${encodeURIComponent(query)}` },
  ];
}

/**
 * One entry per dance × level that has a tempo in the spec table.
 * All entries are free in this phase (see `access`).
 */
export const PRACTICE_ENTRIES: PracticeEntry[] = DANCES.flatMap((dance) =>
  LEVELS.flatMap((level) => {
    const bpm = tempoFor(dance.slug, level.slug);
    if (bpm === null) return [];
    const tunes = TUNES[dance.slug];
    const entry: PracticeEntry = {
      dance: dance.slug,
      level: level.slug,
      access: "free",
      timeSignature: dance.timeSignature,
      bpm,
      bars: barsFor(dance.slug, level.slug),
      tunes,
      listen: listenLinks(tunes[0].name, dance.name, bpm),
    };
    return [entry];
  }),
);
