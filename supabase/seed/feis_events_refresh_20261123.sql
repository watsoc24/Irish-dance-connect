-- Feis calendar weekly refresh — verified 2026-11-23
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project.
-- Found by diffing the FULL listings on FeisWorx (homepage current +
-- "watch for" lists, fetched in full 2026-11-23), QuickFeis, FeisWeb,
-- Planxti, IDTANA (US archive + regional calendars), FeisInfo and the
-- feiseanna's own websites against the calendar, for US feiseanna from
-- 2026-11-23 through 2027-03-23.
-- Same idempotent pattern as feis_events_seed.sql: a row is inserted only
-- when no row with the same name and starts_on already exists.
-- Venue rule: venue_name is NULL wherever the verifying source did not
-- show a 2027 venue; a prior year's venue is never carried over.
-- ===========================================================================

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Avalon Winterfeis 2027', '2027-01-18', '2027-01-18',
  'The Avalon Ballroom', 'Boulder', 'Colorado', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Avalon Winterfeis 2027' and starts_on = '2027-01-18'
);
-- Source: the feis's own site (sites.google.com/view/winterfeis26):
-- "Avalon Winterfeis 2027, Monday, January 18, The Avalon Ballroom,
-- 6185 Arapahoe Road, Boulder, CO 80303; registration to open on
-- FeisWorx.com no later than November 25, 2026." Also listed on the
-- FeisWorx homepage "watch for" list (Jan 18, Boulder, CO).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'John & Maureen Kennelly Memorial Feis 2027', '2027-01-18', '2027-01-18',
  null, 'San Francisco', 'California', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'John & Maureen Kennelly Memorial Feis 2027' and starts_on = '2027-01-18'
);
-- Source: FeisWorx homepage "watch for" list (Jan 18, San Francisco, CA).
-- Venue NOT shown for 2027, so venue_name is NULL; the 2026 venue
-- (United Irish Cultural Center) must not be carried over.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Queen City Mini-Feis 2027', '2027-01-30', '2027-01-30',
  'Irish Heritage Center of Cincinnati', 'Cincinnati', 'Ohio', 'United States',
  'https://www.ericksonirishdance.com/queen-city-feis/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Queen City Mini-Feis 2027' and starts_on = '2027-01-30'
);
-- Source: the feis's own site (ericksonirishdance.com/queen-city-feis):
-- "2027 Queen City Mini-Feis: Saturday - January 30th" at the Irish
-- Heritage Center of Cincinnati; a NEW grades-only feis (cap 200).
-- Registration platform not yet published (2027 syllabus pending), so
-- registration_url is the feis's own page, as with Feis ATL 2026.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Shelley Wasatch Winterfeis 2027', '2027-02-06', '2027-02-06',
  null, 'Draper', 'Utah', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Shelley Wasatch Winterfeis 2027' and starts_on = '2027-02-06'
);
-- Source: FeisWorx homepage, Current Western US Region Feiseanna
-- (Feb 6, Draper, UT). Venue not shown for 2027; NULL on purpose.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'St. Louis Irish Arts Feis 2027', '2027-02-12', '2027-02-13',
  null, 'St. Louis', 'Missouri', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'St. Louis Irish Arts Feis 2027' and starts_on = '2027-02-12'
);
-- Source: FeisWorx homepage "watch for" list (Feb 12-13, St Louis, MO).
-- Venue not shown; NULL on purpose. First part of the St. Louis weekend;
-- St. Louis Winter Feis follows on Feb 14 at the same city.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'San Diego Winter Feis 2027', '2027-02-13', '2027-02-13',
  null, 'San Diego', 'California', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'San Diego Winter Feis 2027' and starts_on = '2027-02-13'
);
-- Source: FeisWorx homepage "watch for" list (Feb 13, San Diego, CA)
-- [Open Platform]. Venue not shown; NULL on purpose. Clan Rince Feis
-- follows on Feb 14 in the same city.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'New Mexico State Championships 2027', '2027-02-13', '2027-02-13',
  null, 'Albuquerque', 'New Mexico', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'New Mexico State Championships 2027' and starts_on = '2027-02-13'
);
-- Source: FeisWorx homepage "watch for" list (Feb 13, Albuquerque, NM).
-- Venue not shown; NULL on purpose. Feis on the Rio Grande follows on
-- Feb 14 in the same city.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Clan Rince Feis 2027', '2027-02-14', '2027-02-14',
  null, 'San Diego', 'California', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Clan Rince Feis 2027' and starts_on = '2027-02-14'
);
-- Source: FeisWorx homepage "watch for" list (Feb 14, San Diego, CA)
-- [Open Platform]. Venue not shown; NULL on purpose. Second day of the
-- San Diego Winter Feis weekend.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Feis on the Rio Grande 2027', '2027-02-14', '2027-02-14',
  null, 'Albuquerque', 'New Mexico', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Feis on the Rio Grande 2027' and starts_on = '2027-02-14'
);
-- Source: FeisWorx homepage "watch for" list (Feb 14, Albuquerque, NM).
-- Venue not shown; NULL on purpose. Second day of the New Mexico State
-- Championships weekend.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'St. Louis Winter Feis 2027', '2027-02-14', '2027-02-14',
  null, 'St. Louis', 'Missouri', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'St. Louis Winter Feis 2027' and starts_on = '2027-02-14'
);
-- Source: FeisWorx homepage "watch for" list (Feb 14, St Louis, MO).
-- Venue not shown; NULL on purpose. Follows the St. Louis Irish Arts
-- Feis (Feb 12-13) in the same city.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Texas State Championship & Feis 2027', '2027-02-27', '2027-02-27',
  null, 'Coppell', 'Texas', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Texas State Championship & Feis 2027' and starts_on = '2027-02-27'
);
-- Source: FeisWorx homepage "watch for" list (Feb 27, Coppell, TX).
-- This is the 2027 edition the Nov 20 gap audit listed as "checked but
-- not verified"; FeisWorx now publishes it. Venue not shown; NULL on
-- purpose. Cowtown Feis follows on Feb 28 in the same city.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Cowtown Feis 2027', '2027-02-28', '2027-02-28',
  null, 'Coppell', 'Texas', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Cowtown Feis 2027' and starts_on = '2027-02-28'
);
-- Source: FeisWorx homepage "watch for" list (Feb 28, Coppell, TX).
-- Venue not shown; NULL on purpose. Second day of the Texas State
-- Championship & Feis weekend.
