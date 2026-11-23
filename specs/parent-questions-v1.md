# Parent Questions ("Ask a Parent") — Build Spec v1

> **Status:** Implemented in the same pass as this spec. If anything here
> conflicts with the code in the repo, the code wins — update this file.

## 0. Context

Irish Dance Connect is a Next.js 16 App Router + Supabase + Tailwind app for
Irish dance parents and schools. Parents repeatedly ask each other the same
questions — what a first feis morning looks like, how dress fittings work,
how much practice is normal — in places the site can't help with. This spec
adds a simple public Q&A board so those answers live on the site.

**House rules (same as the rest of the repo):**
- Follow existing patterns: server components, server actions in
  `actions.ts` next to the page, `ActionForm` + `fields.tsx` for forms,
  brand classes (`.card`, `.btn`, `.btn-secondary`, `.badge`, `.link`,
  `.page-title`, `.input`, `.label`).
- No emojis as icons. No new colors or fonts.
- Migrations are applied by the owner in the Supabase SQL Editor; a
  migration file is never applied automatically.
- Children's full names and photos are never shared — the board carries a
  guideline line saying so (see §3).

## 1. Data model — `supabase/migrations/20261119000000_parent_questions.sql`

Two tables, mirroring `20261117000000_school_choreography.sql` (uuid pk,
`private.set_updated_at()` triggers, RLS on, policies named
`<table>_<verb>`):

- `public.parent_questions`: `id`, `author_id` (default `auth.uid()`, FK
  `auth.users` cascade), `title` (trimmed 5–140 chars), `body` (trimmed
  10–4000), `category` (check in the seven slugs in §2), `is_hidden`
  (default false), `created_at`, `updated_at`.
- `public.parent_replies`: `id`, `question_id` (FK `parent_questions`
  cascade), `author_id` (same as above), `body` (trimmed 1–4000),
  `is_hidden`, timestamps.
- Indexes: questions `(created_at desc)`, questions `(category)`,
  replies `(question_id, created_at)`.

### RLS

- **SELECT** (`anon`, `authenticated`): a row is readable when it is not
  hidden, or the reader is its author, or the reader is a platform admin.
  Replies additionally require the parent question to be readable by the
  same rule, so hiding a question hides its whole thread.
- **INSERT** (`authenticated` only — no anonymous posting):
  `author_id = auth.uid()`. Replies also require the parent question to be
  visible (not hidden), so nothing can be added to a hidden thread.
- **UPDATE / DELETE** (`authenticated`): the author, or a platform admin
  via the existing `private.is_platform_admin()` helper (account_roles
  flag + MFA aal2). Hiding in this phase is an admin setting `is_hidden`
  directly; there is no separate moderation UI yet.
- Author display names come from `public.profiles` exactly as the
  marketplace does (`display_name`, fallback "Member"). Profiles are only
  readable by signed-in users under existing policy, so signed-out
  visitors see "Member" — same as the marketplace.

## 2. Categories — `src/lib/parent-questions.ts`

`QUESTION_CATEGORIES` (slug + label), the single source of truth shared by
the DB check, the zod schemas, and the UI:

| Slug | Label |
| --- | --- |
| `getting-started` | Getting started |
| `feis-day` | Feis day |
| `dresses-and-gear` | Dresses & gear |
| `practice` | Practice |
| `schools-and-teachers` | Schools & teachers |
| `competitions` | Competitions |
| `other` | Other |

The same file exports `PARENT_GUIDELINES`, the one guideline sentence shown
on the list and new-question pages.

## 3. App

- `src/lib/validation.ts`: `questionSchema` (title 5–140, body 10–4000,
  category enum) and `replySchema` (body 1–4000), built on the existing
  `text()` helper so cleaning/trimming matches the DB checks.
- `src/app/parents/actions.ts`: `createQuestion` (redirects to the new
  question), `deleteQuestion` (redirects to the list), `createReply`,
  `deleteReply`. All use `requireUser`, zod validation, and the existing
  rate limiter (5 questions/hour, 20 replies/hour per account), and rely
  on RLS as the real permission check.
- `src/app/parents/page.tsx` (`/parents`): public list, newest first.
  Text search `q` over title + body (via the existing `searchTerm`
  sanitizer), category filter, reply counts, author display names,
  guideline line, and an "Ask a question" button.
- `src/app/parents/new/page.tsx` (`/parents/new`): the ask form
  (title, category, body) with the guideline line. Signed-out visitors get
  a friendly sign-in / create-account prompt, not an error or a redirect.
- `src/app/parents/[id]/page.tsx` (`/parents/[id]`): the question and its
  replies, oldest first. Signed-in users get a reply form; signed-out
  visitors get a sign-in prompt. Authors see a delete button on their own
  question and replies.
- Navigation: "Parents" in the desktop nav (`src/app/layout.tsx`), the
  mobile bottom nav (`src/components/bottom-nav.tsx`), and a numbered
  section card on the homepage (`src/app/page.tsx`).

Guideline line (exact): "Be kind, no selling (the marketplace is for
that), and please don't share children's full names or photos."

## 4. Tests

- Unit: `tests/unit/lib.test.ts` — `questionSchema` / `replySchema`
  accept/reject cases (bounds, trimming, unknown category).
- RLS: `tests/rls/rls.test.ts` — public read of visible rows only, no
  anonymous posting, no posting as someone else, authors manage only
  their own posts, hidden threads reject new replies, platform admin
  (aal2) can hide/delete, admin flag without aal2 cannot. Run with
  `TEST_DATABASE_URL=… npm run test:rls`; they skip nothing but need a
  local Postgres, same as the choreography tests.

## 4b. Pinning (added Nov 22, 2026)

- Migration `20261122000000_parent_question_pinning.sql` adds
  `is_pinned boolean not null default false` to `parent_questions`,
  plus an index on `(is_pinned desc, created_at desc)`. No policy
  changes: the existing update policy already covers the column.
- The list orders pinned questions first, then newest first, within
  search and category filters too, and shows a "Pinned" badge. The
  detail page shows the same badge.
- `setQuestionPinned` in `src/app/parents/actions.ts` is platform
  admin only (`account.isPlatformAdmin`, with `requireUser` enforcing
  MFA aal2, matching `private.is_platform_admin()`). The control
  renders on the detail page only for platform admins.
- Both pages query `is_pinned` with a fallback to the pre-migration
  column list, so the board keeps working until the owner applies the
  migration in the SQL Editor.

## 5. Acceptance criteria

- `npm run typecheck`, `npm run lint`, `npm test`, `npm run build` pass.
- A signed-out visitor can read questions and replies but is prompted to
  sign in before asking or replying.
- A signed-in parent can ask, reply, and delete their own posts, and
  cannot touch anyone else's.
- A hidden question and its replies disappear for everyone except the
  author and platform admins.
