# Practice Music, Fundamentals & School Choreography — Build Spec v1

> **How to use this file (for Claude Code):** Open this repository in Claude Code and run:
> `Implement specs/practice-music-and-training-v1.md`
> Work through the four parts in order (A → B → C → D). Do not skip the
> Acceptance Criteria at the end. If anything in this spec conflicts with the
> code you find in the repo, follow the repo and say so in your summary.

## 0. Context — what this app is

Irish Dance Connect (`watsoc24/Irish-dance-connect`, `main`) is a Next.js 16
App Router + Supabase + Tailwind app for Irish dance parents and schools:
feis calendar (`/feis`), school directory (`/schools`, 810 locations),
marketplace (`/marketplace`, Stripe checkout not yet configured — a
"coming soon" notice is already wired to `env.stripeConfigured` in
`src/components/marketplace-coming-soon.tsx`).

**Read first, before writing any code:**
- `AGENTS.md` — this Next.js version has breaking changes. Read the guides in
  `node_modules/next/dist/docs/` before writing code. Heed deprecation notices.
- `README.md` — setup, migrations (applied in the Supabase SQL Editor), env vars.
- `src/lib/env.ts` — `env.stripeConfigured` is the existing feature gate.
- `src/app/schools/manage/page.tsx` + `src/app/schools/actions.ts` — the
  school-admin area and the server-action pattern to copy.
- `src/components/marketplace-coming-soon.tsx` — the existing "coming soon"
  pattern (banner + badge, auto-hides when its feature is configured).
- `src/app/marketplace/page.tsx` — how a gated page is structured.
- `src/lib/auth.ts` — `requireUser`, `requireSchoolAdmin`.

**House rules for this repo:**
- No live payments, no public publishing of real personal data. Do NOT wire
  Stripe, do NOT build checkout, do NOT add prices in this spec.
- Never host audio or video. Link out only (see §5 Legal).
- Never invent addresses, coordinates, or school details. Only use data
  already in the repo or in this spec.
- Follow existing patterns: server components, server actions in `actions.ts`
  next to the page, Tailwind classes already in use (`.card`, `.btn`,
  `.btn-secondary`, `.badge`, `.link`, `.page-title`, `.input`), `requireUser` /
  `requireSchoolAdmin` for protected pages.
- Every new page gets `export const metadata = { title: "..." }`.
- Mobile-first: the owner's main device is an iPhone. Test layouts at 390px.
- Run `npm run typecheck`, `npm run lint`, `npm test`, `npm run build` — all
  must pass before you finish.

## 1. What to build (Phase 1 — free now, paid tier later)

Four parts. All free in this phase. The paid build-out is designed for, not
built (§4).

### Part A — Practice Music page (`/practice`)

A free directory of practice music, one entry per dance × level. No audio is
hosted or embedded as a file — every listen option is an outbound link.

**Data file:** create `src/lib/practice-music.ts` with a static curated
dataset. Each entry: `dance`, `level`, `timeSignature`, `bpm` (from the tempo
table in §2), `bars` (from §2), `tunes` (tune names + TheSession.org links
where known), `listen` (outbound links: Spotify and YouTube — link to the
official artist/label upload or a Spotify search for the tune name + speed,
e.g. "Reel 122"). No Apple Music links presented as free (Apple Music has no
free tier — trial only; never present trials as free).

**Page (`src/app/practice/page.tsx`):**
- Level picker (First Feis, Beginner, Advanced Beginner, Novice,
  Prizewinner, Preliminary Championship, Open Championship, Adult).
- Per dance: tempo, time signature, bars, tune names, listen links.
- Tempo chart (the full table from §2) with the note: "North America
  (IDTANA) speeds unless stated — confirm with your dancer's teacher.
  European speeds differ slightly."
- The metronome from Part B embedded at the top of the page, wired to the
  selected dance + level (§3).
- Add "Practice" to the site nav (`src/app/layout.tsx`) and the mobile
  bottom nav (`src/components/bottom-nav.tsx`).

### Part B — Metronome (built into `/practice`, reusable component)

**Component:** `src/components/metronome.tsx`, generated on-device with the
Web Audio API. A generated click is not a recording and needs no music
licence. It must work on iPhone Safari: create/resume the `AudioContext`
inside a user gesture (the Start tap), never on page load.

**Behaviour (all required):**
- Dance selector + level selector. **Selecting a dance changes the pace
  automatically** to that dance's BPM for the selected level (table in §2).
  Changing the level re-derives the BPM. The user can then adjust BPM
  manually; a "Reset to dance tempo" button restores the preset.
- Correct accent groupings per time signature (accent on beat 1):
  4/4 = 4 quarter-note beats; 6/8 = 2 dotted-quarter beats; 9/8 = 3
  dotted-quarter beats; 12/8 = 4 dotted-quarter beats; 2/4 = 2 beats.
- BPM range 60–150, with tap tempo.
- Slow-practice slider: 60–100% of the target tempo (default 100%).
- 8-bar count-in toggle, and a bar counter that counts up through the run
  length (16 / 32 / 40 / 48 bars, selectable, default 32) then stops.
- Start / stop. Clear visual beat indicator (the current beat lights up).
- No audio files, no downloads, no offline promise. The click is generated
  live while the page is open.

### Part C — Fundamentals (`/practice/fundamentals`)

Basic exercises for the four fundamentals. Plain-language, beginner-level,
safe to do at home. Each fundamental gets: what it is (one short paragraph),
one simple drill, what to watch for (2–3 bullets), and a "Practice with the
metronome" link that opens `/practice` with that fundamental's suggested
tempo pre-selected (slow: Reel 90 or Light Jig 90 — see §2 note).

1. **Point** — toes pointed, foot extended through the ankle; the foot, not
   just the toes, makes the line.
2. **Turn out** — feet turned out from the hips, knees tracking over the
   toes; turnout comes from the hip, never by twisting the knee or ankle.
3. **Cross** — feet crossing in front of each other (third/fifth position);
   legs crossing cleanly on jumps and steps, knees together.
4. **Arms** — arms held straight at the sides, hands in relaxed fists,
   shoulders down; arms do not swing or flap.

Do NOT invent claims about any specific school's method. Keep every drill
generic and beginner-safe. If a detail is not standard teaching, leave it
out rather than guessing. Link each fundamental back to the dances that use
it most (e.g. point → reel and light jig).

### Part D — School choreography back end (staff-only)

Schools that have claimed their listing (via `school_admins`, see
`src/app/schools/manage/page.tsx`) get a choreography section in their
back end. **Staff-only in this phase** — nothing here is public, and nothing
is shared with dancers yet (that is a later phase).

**Database:** new migration
`supabase/migrations/20261117000000_school_choreography.sql`:
```sql
create table public.school_choreography (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id) on delete cascade,
  created_by uuid not null references auth.users(id),
  title text not null,
  dance text not null,
  level text not null,
  notes text,
  video_url text, -- outbound link only, https, YouTube/Vimeo; never a hosted file
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- RLS: only rows whose school_id is in the caller's school_admins rows
-- are visible or writable. Mirror the RLS pattern used for schools in
-- supabase/migrations/20261103000000_init.sql. No public read access.
```
Also add the migration file only — do NOT apply it to the live database.
The owner applies migrations in the Supabase SQL Editor. Say so in your
summary.

**UI:** inside `/schools/manage` (one section per claimed school, below the
existing school details):
- List the school's choreography items (title, dance, level, published?).
- Add / edit / delete, via server actions in `src/app/schools/actions.ts`
  following the existing `updateSchool` pattern, with validation in
  `src/lib/validation.ts` if it fits there (title ≤ 120 chars, dance and
  level from the same fixed lists as Part A, notes ≤ 2000 chars, video_url
  https-only or empty).
- `is_published` is stored but has no public effect in this phase — label it
  in the UI as "Ready to share later (not visible to dancers yet)".

## 2. Tempo data (North America / IDTANA — embed exactly this)

BPM here means **counted beats per minute** (reels/hornpipes are counted on
2 significant beats per bar), not raw note rate.

| Dance | Time | Beginner | Adv. Beginner | Novice | Prizewinner | Championship |
|---|---|---|---|---|---|---|
| Reel | 4/4 | 122 | 122 | 113 | 113 | 113 |
| Light Jig | 6/8 | 115 | 115 | 115 | 115 | — |
| Slip Jig | 9/8 | 122 | 122 | 113 | 113 | 113 |
| Single / Hop Jig | 6/8 (12/8) | 124 | 124 | 124 | 124 | — |
| Treble / Heavy / Double Jig | 6/8 | — | 92 | 73 or 92 | 73 or 92 | 73 |
| Hornpipe | 2/4 or 4/4 | — | 138 | 113 or 138 | 113 or 138 | 113 |
| Treble Reel | 4/4 | — | — | 113 | 113 | 113 |

**Bars:** grades 16 (trophy) / 32; championships 8-bar intro + 48 bars
(Reel/Treble Jig) / 40 bars (Slip Jig/Hornpipe). Céilí: 2- and 3-hand 40
bars at 113; 8-Hand default 115. **Traditional set dances (fixed):**
Blackbird 144, Garden of Daisies 138, Job of Journeywork 138, Jockey to the
Fair 90, King of the Fairies 130, St Patrick's Day 94, Three Sea Captains 96.
**Fundamentals practice tempo:** slow work at Reel 90 / Light Jig 90.

Levels in order: First Feis → Beginner → Advanced Beginner → Novice →
Prizewinner → Preliminary Championship → Open Championship (plus Adult).
A dancer advances per dance, not as a whole.

## 3. Metronome + dance wiring (the key interaction)

- One shared state on `/practice`: selected dance + selected level.
- The tempo chart, the listen entries, AND the metronome all read that
  state. Changing the dance updates the metronome BPM to the table value
  for that dance + level; changing the level re-derives it.
- The fundamentals page links to `/practice?dance=reel&level=beginner`
  (and equivalents), which must pre-select that dance/level on load.
- Manual BPM changes do not change the selected dance — the preset is only
  restored by "Reset to dance tempo" or by re-selecting the dance/level.

## 4. Paid build-out — design for it, do NOT build it

The free directory in Part A is the foundation; a paid tier follows later
(premium practice tracks, longer metronome sessions, sharing choreography
with a school's dancers). Prepare for it, do not build it:
- Every music entry in `src/lib/practice-music.ts` gets
  `access: "free" | "premium"`. All entries are `"free"` in this phase.
- Add one placeholder card on `/practice` after the free entries: "Premium
  practice tracks — coming soon. Full-length tracks at exact feis tempos,
  coming soon." No price, no button that takes payment, no Stripe code.
- The choreography `is_published` flag (Part D) is the future sharing
  switch; do not expose it publicly yet.
- Do NOT add Stripe keys, prices, checkout, webhooks, or any billing UI.

## 5. Legal — non-negotiable

- Host ZERO audio and ZERO video. Traditional tunes are public domain, but
  every recording and arrangement is copyrighted. The app links out, never
  hosts, never embeds a downloaded file, never rips or downloads from
  YouTube/Spotify. Use the official Spotify/YouTube players and links only.
- Tune names, time signatures, tempos and notation links (TheSession.org)
  are facts — free to list and link.
- Never present a free trial as free. Apple Music has no free tier.
- The metronome click is generated on-device (Web Audio) — no licence needed.
- School choreography videos are outbound links (YouTube/Vimeo) only.
- Privacy: no children's names or photos anywhere. Choreography items are
  staff-only. Do not add any feature that exposes dancer details.

## 6. Out of scope (do not touch)

- Stripe / payments / checkout / pricing (see §4).
- Feis calendar, school directory search, marketplace, auth, admin.
- Hosting, uploading or transcoding any media file.
- Email templates, notifications, or any new database table beyond
  `school_choreography`.

## 7. Acceptance criteria (all must be true before you finish)

1. `/practice` loads without sign-in: level picker, per-dance tempo/bars/
   tunes/listen links, full tempo chart with the regional note, metronome
   at the top, premium placeholder card at the bottom. No audio files in
   the repo or the build output.
2. Metronome: selecting Reel / Beginner sets 122 BPM; selecting Treble Jig /
   Open Championship sets 73 BPM; changing the level re-derives the BPM;
   tap tempo, 60–100% slow-practice slider, 8-bar count-in, and 16/32/40/48
   bar counting all work; correct accents for 4/4, 6/8, 9/8, 12/8, 2/4;
   starts/stops cleanly on iPhone Safari (AudioContext resumed on tap).
3. `/practice/fundamentals` loads without sign-in with all four fundamentals
   (point, turn out, cross, arms), each with drill + watch-fors + a
   metronome link that pre-selects the tempo on `/practice`.
4. A school admin sees a choreography section on `/schools/manage` for each
   claimed school and can add / edit / delete items; a non-admin (or a
   signed-out visitor) cannot see or reach any choreography data — verify
   the RLS by attempting a read as a non-member in your tests or by code
   inspection and say which you did.
5. "Practice" appears in the desktop nav and the mobile bottom nav.
6. `npm run typecheck`, `npm run lint`, `npm test`, `npm run build` all pass.
7. No Stripe code, no prices, no checkout, no hosted media added.
8. Your final summary lists: files created/changed, the migration filename
   (with the note that the owner applies it in the Supabase SQL Editor),
   how you verified each acceptance criterion, and anything you left
   unfinished.
