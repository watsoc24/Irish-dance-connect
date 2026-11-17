-- School choreography (staff-only). The owner applies migrations in the
-- Supabase SQL Editor; this file is NOT applied automatically.
--
-- Nothing in this table is public: only admins of the owning school can
-- read or write rows. The is_published flag is stored only; it has no
-- public effect in this phase (sharing with dancers comes later).

create table public.school_choreography (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id) on delete cascade,
  created_by uuid not null default auth.uid() references auth.users(id),
  title text not null check (char_length(btrim(title)) between 2 and 120),
  dance text not null,
  level text not null,
  notes text check (notes is null or char_length(notes) <= 2000),
  video_url text check (video_url is null or (video_url ~* '^https://[^\s]+$' and char_length(video_url) <= 300)),
  is_published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger school_choreography_updated_at before update on public.school_choreography
  for each row execute function private.set_updated_at();
create index school_choreography_school_idx on public.school_choreography (school_id);

alter table public.school_choreography enable row level security;

-- Staff-only: only admins of the owning school can see or change rows.
-- No policy for anon, so anonymous visitors cannot read any choreography.
create policy school_choreography_select on public.school_choreography for select to authenticated
  using (private.is_school_admin(school_id));
create policy school_choreography_insert on public.school_choreography for insert to authenticated
  with check (private.is_school_admin(school_id));
create policy school_choreography_update on public.school_choreography for update to authenticated
  using (private.is_school_admin(school_id))
  with check (private.is_school_admin(school_id));
create policy school_choreography_delete on public.school_choreography for delete to authenticated
  using (private.is_school_admin(school_id));
