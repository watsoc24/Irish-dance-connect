-- Feis calendar gap fill — verified 2026-11-20
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project.
-- Found by diffing the FULL listings on QuickFeis, IDTANA (directory
-- profiles and regional calendars), Planxti, FeisWeb and FeisWorx against
-- the calendar on 2026-11-20: 14 upcoming US feiseanna the original
-- hand-picked seed missed, most of them second-day companion feiseanna.
-- Full research: ~/workspace/research_notes/feis-calendar-gap-20261120/report.md
-- Same idempotent pattern as feis_events_seed.sql: a row is inserted only
-- when no row with the same name and starts_on already exists.
-- ===========================================================================

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Hotlanta Feis 2026', '2026-11-22', '2026-11-22',
  'Renaissance Waverly Hotel', 'Atlanta', 'Georgia', 'United States',
  'https://www.ifeis.net/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Hotlanta Feis 2026' and starts_on = '2026-11-22'
);
-- Source: Planxti homepage card and feisatl.com/hotlanta-feis. Companion to
-- Feis ATL (Nov 21), which the original seed had on its own.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'IDTANA Southern Region Mini Feis 2026', '2026-12-06', '2026-12-06',
  'Hilton Anatole', 'Dallas', 'Texas', 'United States',
  'https://www.quickfeis.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'IDTANA Southern Region Mini Feis 2026' and starts_on = '2026-12-06'
);
-- Source: QuickFeis homepage (first FUTURE FEISEE entry) and
-- southernregionirishdance.org/sro-2026. Note: restricted to Southern
-- Region dancers not in solo championships, plus eligible siblings; held
-- alongside the Southern Oireachtas but is a grades feis, not the major.
-- feis_events has no notes column, so the restriction lives in this comment.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Christmas Feis 2026', '2026-12-06', '2026-12-06',
  'Westin Mission Hills Golf Resort & Spa', 'Rancho Mirage', 'California', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Christmas Feis 2026' and starts_on = '2026-12-06'
);
-- Source: Western US Region feiseanna page (westernusregion.com/feiseanna,
-- lists "05 Feile na Nollaig / 06 Christmas Feis") and claddaghdance.com.
-- Second day of the Feile na Nollaig weekend the seed already listed.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Pittsburgh Winter Feis 2026', '2026-12-26', '2026-12-26',
  'Hyatt Regency', 'Coraopolis', 'Pennsylvania', 'United States',
  'https://www.quickfeis.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Pittsburgh Winter Feis 2026' and starts_on = '2026-12-26'
);
-- Source: QuickFeis homepage OPEN REGISTRATIONS (first feis listed there)
-- and the feis syllabus PDF on quickfeis.com. Venue is in Coraopolis
-- (Pittsburgh airport area) despite the Pittsburgh branding.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Pittsburgh Snow Feis 2026', '2026-12-27', '2026-12-27',
  'Hyatt Regency', 'Coraopolis', 'Pennsylvania', 'United States',
  'https://www.quickfeis.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Pittsburgh Snow Feis 2026' and starts_on = '2026-12-27'
);
-- Source: QuickFeis homepage OPEN REGISTRATIONS and the feis syllabus PDF
-- on quickfeis.com. Second day of the Pittsburgh Winter Feis weekend.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Portland New Year''s Feis 2027', '2027-01-16', '2027-01-16',
  'Sheraton Portland Airport Hotel', 'Portland', 'Oregon', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Portland New Year''s Feis 2027' and starts_on = '2027-01-16'
);
-- Source: IDTANA directory profile idtana.org/events/portland-new-years-feis-3.
-- IDTANA spells the hotel "Sherton"; the hotel's correct name is used here.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Northwest Winterfeis 2027', '2027-01-17', '2027-01-17',
  'Sheraton Portland Airport Hotel', 'Portland', 'Oregon', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Northwest Winterfeis 2027' and starts_on = '2027-01-17'
);
-- Source: IDTANA directory profile idtana.org/events/northwest-winterfeis-3.
-- Second day of the Portland New Year's Feis weekend, same hotel.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Fairfield County Championships 2027', '2027-01-23', '2027-01-23',
  null, 'New Canaan', 'Connecticut', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Fairfield County Championships 2027' and starts_on = '2027-01-23'
);
-- Source: FeisWeb homepage competition list. Venue NOT shown on FeisWeb, so
-- venue_name is NULL on purpose; the 2026 venue (Saxe Middle School) was a
-- weather-postponement venue and must not be carried over.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'North Coast Feis 2027', '2027-02-06', '2027-02-06',
  'Hotel Cleveland', 'Cleveland', 'Ohio', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'North Coast Feis 2027' and starts_on = '2027-02-06'
);
-- Source: IDTANA directory profile idtana.org/events/north-coast-feis-3.
-- (Grade exams follow on Feb 7 at the same venue; exams are not a feis and
-- are deliberately not listed.)

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'O''Rourke Winter Feis 2027', '2027-02-06', '2027-02-07',
  'Fred Astaire Studio', 'White Plains', 'New York', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'O''Rourke Winter Feis 2027' and starts_on = '2027-02-06'
);
-- Source: FeisWeb homepage list and the Mid-Atlantic Region schedule.
-- FLAG: FeisWeb shows the feis running thru Mon Feb 8, 2027; the MAR
-- schedule shows Sat-Sun Feb 6-7 only, matching the 2026 pattern. The
-- regional schedule's dates are used here; re-check before February.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Feis Na Nollag 2027', '2027-02-13', '2027-02-14',
  'Irish American Center', 'Mineola', 'New York', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Feis Na Nollag 2027' and starts_on = '2027-02-13'
);
-- Source: Mid-Atlantic schedule (via kenderacademy.com/feis-schedule.html),
-- venue corroborated by MAR's own calendar PDF.
-- FLAG: the current MAR schedule says entries run on FeisWeb; MAR's 2026
-- calendar said FeisWorx. FeisWeb is used; re-check before February.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Newport Feis 2027', '2027-02-27', '2027-02-27',
  'Newport Harbor Island Resort', 'Newport', 'Rhode Island', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Newport Feis 2027' and starts_on = '2027-02-27'
);
-- Source: FeisWeb homepage competition list. First day of the Newport
-- weekend; Ocean State Feis follows on Feb 28 at the same resort.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Ocean State Feis 2027', '2027-02-28', '2027-02-28',
  'Newport Harbor Island Resort', 'Newport', 'Rhode Island', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Ocean State Feis 2027' and starts_on = '2027-02-28'
);
-- Source: FeisWeb homepage competition list. Second day of the Newport
-- weekend, same resort as Newport Feis (Feb 27).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Inishfree Feis 2027', '2027-02-28', '2027-02-28',
  'B.P.O. Elks Lodge #2162', 'Massapequa', 'New York', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Inishfree Feis 2027' and starts_on = '2027-02-28'
);
-- Source: Mid-Atlantic schedule (via kenderacademy.com/feis-schedule.html)
-- and FeisWeb.
