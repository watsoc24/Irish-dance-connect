-- Feis calendar seed — curated listings (verified 2026-11-12)
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Each row was verified live on 2026-11-12 from Planxti, the IDTANA regional
-- calendars, FeisWeb, QuickFeis, FeisWorx, iFeis, FeisInfo, or the feis's own
-- website / syllabus. Registration URLs were opened and confirmed loading.
-- Entry-close dates are recorded in the comments only — feis_events has no
-- column for them — so they must be re-checked on the organizer's site.
--
-- Idempotent: a row is inserted only when no published/pending row with the
-- same name and starts_on already exists, so the file is safe to re-run.
-- status is 'published' (the usual admin-review step is skipped here because
-- every row below was verified by the curator); host_school_id and
-- submitted_by are NULL because these listings come from public calendars,
-- not from a school admin submission.
--
-- ONE ROW WAS DELIBERATELY LEFT OUT: Minnesota State Championships 2026 —
-- its venue and registration platform could only be confirmed from a 2023
-- syllabus, not from a 2026 source, so it did not meet the verification bar.
-- ===========================================================================

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Petri Foundation Feis 2026', '2026-11-14', '2026-11-15',
  'Fred Astaire Dance Studio', 'White Plains', 'New York', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Petri Foundation Feis 2026' and starts_on = '2026-11-14'
);
-- Source: planxti.com/feiseanna/petrifoundationfeis/2026 and feisweb.com.
-- Entries closed 2026-11-09. Venue per the 2026 syllabus / FeisWeb (White
-- Plains); Planxti lists a different Mineola venue — syllabus wins.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Hooley Harvest Feis 2026', '2026-11-14', '2026-11-14',
  'Morgantown Classic Auto Mall', 'Morgantown', 'Pennsylvania', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Hooley Harvest Feis 2026' and starts_on = '2026-11-14'
);
-- Source: feisweb.com; syllabus at assets.planxti.com.
-- Entries closed 2026-11-01 (syllabus; a regional schedule says Nov 9).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Carolina Fall Championships and Feis 2026', '2026-11-14', '2026-11-14',
  'Embassy Suites by Hilton Greensboro Airport', 'Greensboro', 'North Carolina', 'United States',
  'https://www.ifeis.net/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Carolina Fall Championships and Feis 2026' and starts_on = '2026-11-14'
);
-- Source: planxti.com/feiseanna/carolinafallchampionshipsandfeis/2026.
-- Entries closed 2026-10-31. iFeis is the named registration platform;
-- its homepage renders thinly in a text fetch, so re-check it in a browser.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'St. Paul Autumn Feis 2026', '2026-11-15', '2026-11-15',
  'Mall of America', 'Bloomington', 'Minnesota', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'St. Paul Autumn Feis 2026' and starts_on = '2026-11-15'
);
-- Source: planxti.com/feiseanna/stpaulautumnfeis/2026. Mall of America is in
-- Bloomington, MN (Planxti's header says Bloomington).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Feis ATL 2026', '2026-11-21', '2026-11-21',
  'Renaissance Waverly Hotel', 'Atlanta', 'Georgia', 'United States',
  'https://www.feisatl.com', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Feis ATL 2026' and starts_on = '2026-11-21'
);
-- Source: feisatl.com (verified loading; it links registration to iFeis) and
-- its syllabus at assets.planxti.com. Entries closed 2026-11-03.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Feile na Nollaig 2026', '2026-12-05', '2026-12-05',
  'Westin Mission Hills Golf Resort & Spa', 'Rancho Mirage', 'California', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Feile na Nollaig 2026' and starts_on = '2026-12-05'
);
-- Source: FeisWorx syllabus (mail.feisworx.com/feis/FeileNaNollaig2026Syllabus.pdf)
-- and the Western US region feis list. Entries close 2026-11-13.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Christmas Star Feis 2026', '2026-12-06', '2026-12-06',
  'West Bridgewater Middle-Senior High School', 'West Bridgewater', 'Massachusetts', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Christmas Star Feis 2026' and starts_on = '2026-12-06'
);
-- Source: FeisWeb (Dec 6, 2026, West Bridgewater, MA; entries close Nov 30
-- at 6:00 PM) and the host school's 2026 flyer (West Bridgewater
-- Middle-Senior High School, 155 West Center St.). The NEIDT regional page
-- lists a different venue (Whitman Hanson, Hanson) — the host flyer and
-- FeisWeb agree on West Bridgewater, so that venue is used here.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Wisconsin WinterFeis 2027', '2027-01-16', '2027-01-16',
  'Baird Center', 'Milwaukee', 'Wisconsin', 'United States',
  'https://www.quickfeis.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Wisconsin WinterFeis 2027' and starts_on = '2027-01-16'
);
-- Source: bairdcenter.com calendar (Jan 16, 2027, 8:00am, Cashel Dennehy
-- School) and the WinterFeis syllabus (registration via QuickFeis;
-- details at www.winterfeis.com).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'St. Brigid''s Feis 2027', '2027-01-17', '2027-01-17',
  'Baird Center', 'Milwaukee', 'Wisconsin', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'St. Brigid''s Feis 2027' and starts_on = '2027-01-17'
);
-- Source: kinsellairishdance.com/feisanna (Jan 17, 2027, Baird Center).
-- The page's "www.quickfeis.com" link text actually points to feisworx.com,
-- so the registration URL here is the real click target, FeisWorx.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Feis on the Gulf 2027', '2027-01-23', '2027-01-23',
  'Hilton St. Petersburg Bayfront', 'St. Petersburg', 'Florida', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Feis on the Gulf 2027' and starts_on = '2027-01-23'
);
-- Source: FeisWorx syllabus (mail.feisworx.com/feis/FeisOnTheGulf2027Syllabus.pdf).
-- Entries close 2027-01-08.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Hawaii State Feis 2027', '2027-01-23', '2027-01-23',
  'Hyatt Regency Waikiki Beach Resort and Spa', 'Honolulu', 'Hawaii', 'United States',
  'https://www.feisinfo.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Hawaii State Feis 2027' and starts_on = '2027-01-23'
);
-- Source: feisinfo.com upcoming table (Jan 23, 2027, Honolulu).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Florida State Championships 2027', '2027-01-24', '2027-01-24',
  'Hilton St. Petersburg Bayfront', 'St. Petersburg', 'Florida', 'United States',
  'https://www.feisworx.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Florida State Championships 2027' and starts_on = '2027-01-24'
);
-- Source: FeisWorx syllabus (mail.feisworx.com/feis/FloridaState2027Syllabus.pdf).
-- Entries close 2027-01-08.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Aloha Championships 2027', '2027-01-24', '2027-01-24',
  'Hyatt Regency Waikiki Beach Resort and Spa', 'Honolulu', 'Hawaii', 'United States',
  'https://www.feisinfo.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Aloha Championships 2027' and starts_on = '2027-01-24'
);
-- Source: feisinfo.com upcoming table (Jan 24, 2027, Honolulu). FeisInfo
-- labels it "Aloha Championships 2026" but dates it Jan 24, 2027.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Chocolatetown Feis 2027', '2027-01-30', '2027-01-30',
  'Hershey Lodge', 'Hershey', 'Pennsylvania', 'United States',
  'https://hersheyfeis.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Chocolatetown Feis 2027' and starts_on = '2027-01-30'
);
-- Source: hersheyfeis.com (verified loading; registration begins Oct 24, 2026
-- on FeisWeb) and feisweb.com. Entries close 2027-01-25.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Sweetest Feis on Earth 2027', '2027-01-31', '2027-01-31',
  'Hershey Lodge', 'Hershey', 'Pennsylvania', 'United States',
  'https://hersheyfeis.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Sweetest Feis on Earth 2027' and starts_on = '2027-01-31'
);
-- Source: hersheyfeis.com and feisweb.com. Entries close 2027-01-25.

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Murray Academy Winter Feis 2027', '2027-02-06', '2027-02-06',
  'Cooperative Middle School', 'Stratham', 'New Hampshire', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Murray Academy Winter Feis 2027' and starts_on = '2027-02-06'
);
-- Source: NEIDT 2026 listing (venue) and feisweb.com (2027 date, Stratham,
-- entries close Jan 29, 2027).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Murray Academy Feis 2027', '2027-02-07', '2027-02-07',
  'Cooperative Middle School', 'Stratham', 'New Hampshire', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Murray Academy Feis 2027' and starts_on = '2027-02-07'
);
-- Source: NEIDT 2026 listing (venue) and feisweb.com (2027 date, Stratham,
-- entries close Jan 29, 2027).

insert into public.feis_events
  (name, starts_on, ends_on, venue_name, city, region, country, registration_url, host_school_id, status, submitted_by)
select
  'Rose & Shamrock Feis 2027', '2027-02-13', '2027-02-13',
  'Lancaster Mennonite High School', 'Lancaster', 'Pennsylvania', 'United States',
  'https://feisweb.com/', null, 'published', null
where not exists (
  select 1 from public.feis_events
  where name = 'Rose & Shamrock Feis 2027' and starts_on = '2027-02-13'
);
-- Source: 2027 syllabus (palomaboosterclub.com) and the Kender Academy
-- feis schedule. Registration via FeisWeb.
