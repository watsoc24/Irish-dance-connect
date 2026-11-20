-- Parent questions ("Ask a Parent" Q&A board). The owner applies
-- migrations in the Supabase SQL Editor; this file is NOT applied
-- automatically.
--
-- Questions and replies are public to read (signed-out visitors included)
-- unless hidden. Only signed-in users can post, and only as themselves.
-- Authors can change or delete their own posts; platform admins
-- (private.is_platform_admin(), which requires MFA aal2) can change or
-- delete any row — setting is_hidden = true is how a post is taken down
-- in this phase. Hiding a question hides its whole thread: replies are
-- only readable (and can only be added) while their question is readable.

create table public.parent_questions (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (char_length(btrim(title)) between 5 and 140),
  body text not null check (char_length(btrim(body)) between 10 and 4000),
  category text not null check (category in (
    'getting-started', 'feis-day', 'dresses-and-gear', 'practice',
    'schools-and-teachers', 'competitions', 'other')),
  is_hidden boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger parent_questions_updated_at before update on public.parent_questions
  for each row execute function private.set_updated_at();
create index parent_questions_created_idx on public.parent_questions (created_at desc);
create index parent_questions_category_idx on public.parent_questions (category);

create table public.parent_replies (
  id uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.parent_questions(id) on delete cascade,
  author_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  body text not null check (char_length(btrim(body)) between 1 and 4000),
  is_hidden boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger parent_replies_updated_at before update on public.parent_replies
  for each row execute function private.set_updated_at();
create index parent_replies_question_idx on public.parent_replies (question_id, created_at);

alter table public.parent_questions enable row level security;
alter table public.parent_replies enable row level security;

-- Questions: visible rows are public; authors also see their own hidden
-- rows; platform admins see everything so they can review and hide.
create policy parent_questions_select on public.parent_questions for select to anon, authenticated
  using (is_hidden = false or author_id = (select auth.uid()) or private.is_platform_admin());
create policy parent_questions_insert on public.parent_questions for insert to authenticated
  with check (author_id = (select auth.uid()));
create policy parent_questions_update on public.parent_questions for update to authenticated
  using (author_id = (select auth.uid()) or private.is_platform_admin())
  with check (author_id = (select auth.uid()) or private.is_platform_admin());
create policy parent_questions_delete on public.parent_questions for delete to authenticated
  using (author_id = (select auth.uid()) or private.is_platform_admin());

-- Replies: same visibility as questions, plus the parent question must
-- itself be readable by the same rule, so a hidden question's thread
-- disappears with it and nothing new can be added to it.
create policy parent_replies_select on public.parent_replies for select to anon, authenticated
  using (
    (is_hidden = false or author_id = (select auth.uid()) or private.is_platform_admin())
    and exists (
      select 1 from public.parent_questions q
      where q.id = question_id
        and (q.is_hidden = false or q.author_id = (select auth.uid()) or private.is_platform_admin())
    )
  );
create policy parent_replies_insert on public.parent_replies for insert to authenticated
  with check (
    author_id = (select auth.uid())
    and exists (
      select 1 from public.parent_questions q
      where q.id = question_id and q.is_hidden = false
    )
  );
create policy parent_replies_update on public.parent_replies for update to authenticated
  using (author_id = (select auth.uid()) or private.is_platform_admin())
  with check (author_id = (select auth.uid()) or private.is_platform_admin());
create policy parent_replies_delete on public.parent_replies for delete to authenticated
  using (author_id = (select auth.uid()) or private.is_platform_admin());
