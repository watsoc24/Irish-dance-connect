-- Pinning for the "Ask a Parent" board. The owner applies migrations
-- in the Supabase SQL Editor; this file is NOT applied automatically.
--
-- A pinned question sorts above every other question on the board.
-- Pinning is a platform admin action: the pin server action requires a
-- platform admin account, on top of the existing parent_questions_update
-- policy (author or platform admin). No policy changes are needed.

alter table public.parent_questions
  add column is_pinned boolean not null default false;

-- Board ordering: pinned first, then newest first.
create index parent_questions_pinned_idx on public.parent_questions (is_pinned desc, created_at desc);
