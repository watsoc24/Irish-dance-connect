-- School directory seed — Southern Region (NC, SC, GA, FL, AL, MS, LA, TX, TN, AR, OK): 99 locations
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Every row below was verified 2026-11-12 from the IDTANA-Southern Region
-- teachers list, IDTANA Find a School / state pages, the FeisWorx school list
-- (name universe), each school's own website / class portal, and Planxti
-- school pages where findable. No address was invented. Street address + ZIP
-- are shown ONLY where the school itself (own site, its GoStudioPro class
-- portal, or its own published description) gives them; otherwise the row is
-- city-only. See research_notes/irish-dance-schools-all-us/southern.md for
-- sources and the full "Unverified / partial" list — nothing from that
-- section is seeded here. VA and WV are excluded (Mid-Atlantic file).
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
--
-- Counts: NC 16, SC 6, GA 6, FL 30, AL 4, MS 2, LA 1, TX 22, TN 6, AR 3,
-- OK 3 (99 total; the research file lists 100 verified — 1 row was dropped
-- as a duplicate of the Ohio seed, see below). Street precision 15, city
-- precision 84. No Southern state is claimed complete in the research file;
-- several rows carry current-status caveats (Connick-Reid Raleigh, Carpenter
-- Woodstock GA, Drake Norcross GA — see below).
--
-- website_url is NULL for 22 rows: 18 because the schools' sites are
-- http-only as published (Inis Cairde, Drake School Norcross GA, Drake Irish
-- Dance FL, Drake School Celtic Traditions AL, Inishfree Austin TX, Inishfree
-- Dallas TX, McTeggart Houston, McTeggart North Texas, Scott-Ellis,
-- McCafferty Academy, O'Donovan School), 1 because no website was found
-- (Breffni Academy, Miami Shores FL), 1 because its https URL returned HTTP
-- 404 on a live check (McLane School, Richardson TX), and 2 because their
-- site was unresolvable from this environment on 2026-11-12 (Shandon-O'Regan
-- McKinney + Allen TX — not proven dead, re-check before linking). Every
-- other https URL kept here was checked live on 2026-11-12 (HTTP 200).
--
-- Coordinates: US Census Geocoder (Public_AR_Current benchmark) for street
-- addresses. City-only rows have NO coordinates unless a verified ZIP was
-- available: the Census Geocoder cannot resolve a bare "City, ST" (tested —
-- it returns No_Match), and no Southern city-only row carries a verified
-- ZIP, so there was no Zippopotam.us fallback to use. Those rows keep
-- latitude/longitude/geo_precision/geo_source NULL rather than invented
-- coordinates; the schools remain listed and searchable by city.
-- Street addresses that failed to geocode: none in this file. Watters School
-- of Irish Dance, Ocoee FL (415 N Clarke Rd, 34761) and Gainesville FL
-- (16 NW 7th Ave, 32601), are seeded at street precision from the school's
-- own site (wattersschool.com, fetched 2026-11-12), which publishes both
-- studio addresses — the research file had kept them city-only.
-- Caveats carried from the research file: Connick School & Reid Academy,
-- Raleigh NC, appears only in older material (current status unconfirmed);
-- Carpenter Academy, Woodstock GA, appears only in an older location list
-- (not in the 2026 Eventeny list); Drake School, Norcross GA, has a
-- "Permanently Closed" directory listing for its old address, though the
-- Southern Region list and IDTANA still list Drake in GA, so the row is kept
-- city-only; Maccrossan School, Ocean Springs MS, is not on the Southern
-- Region list — verify directly with the school before featuring it.
--
-- Dropped as a duplicate of the Ohio seed (schools_ohio_seed.sql):
-- Burke Connolly Academy of Irish Dance (Atlanta Irish Dance), Atlanta GA
-- (Ohio seed has Atlanta Irish Dance (Burke Connolly), Atlanta). Nothing
-- else in this file duplicates the Ohio seed.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists, so the file is safe to re-run. Status is 'unclaimed'
-- (default) — these listings have not been claimed by the schools.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Aoibhneas Chroi School of Irish Dance', 'aoibhneas-chroi-school-of-irish-dance-mooresville', 'Mooresville', 'North Carolina', 'United States', 'https://www.acirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Aoibhneas Chroi School of Irish Dance' and city = 'Mooresville'
);
-- Aoibhneas Chroi School of Irish Dance, Mooresville: Mooresville, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carpenter Academy of Irish Dance', 'carpenter-academy-of-irish-dance-asheville', 'Asheville', 'North Carolina', 'United States', 'https://www.carpenteririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carpenter Academy of Irish Dance' and city = 'Asheville'
);
-- Carpenter Academy of Irish Dance, Asheville: Asheville, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy', 'connick-school-reid-academy-charlotte', 'Charlotte', 'North Carolina', 'United States', 'https://www.connickschool.com/',
  '12243 Nations Ford Road', '28134', 35.099156, -80.917386, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy' and city = 'Charlotte'
);
-- Connick School & Reid Academy, Charlotte: 12243 NATIONS FORD RD, PINEVILLE, NC, 28134

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy', 'connick-school-reid-academy-cornelius', 'Cornelius', 'North Carolina', 'United States', 'https://www.connickschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy' and city = 'Cornelius'
);
-- Connick School & Reid Academy, Cornelius: Cornelius, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy', 'connick-school-reid-academy-denver', 'Denver', 'North Carolina', 'United States', 'https://www.connickschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy' and city = 'Denver'
);
-- Connick School & Reid Academy, Denver: Denver, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy', 'connick-school-reid-academy-huntersville', 'Huntersville', 'North Carolina', 'United States', 'https://www.connickschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy' and city = 'Huntersville'
);
-- Connick School & Reid Academy, Huntersville: Huntersville, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy', 'connick-school-reid-academy-raleigh', 'Raleigh', 'North Carolina', 'United States', 'https://www.connickschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy' and city = 'Raleigh'
);
-- Connick School & Reid Academy, Raleigh: Raleigh, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hamlin School of Irish Dance', 'hamlin-school-of-irish-dance-cameron', 'Cameron', 'North Carolina', 'United States', 'https://www.hamlinirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Hamlin School of Irish Dance' and city = 'Cameron'
);
-- Hamlin School of Irish Dance, Cameron: Cameron, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hamlin School of Irish Dance', 'hamlin-school-of-irish-dance-southern-pines', 'Southern Pines', 'North Carolina', 'United States', 'https://www.hamlinirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Hamlin School of Irish Dance' and city = 'Southern Pines'
);
-- Hamlin School of Irish Dance, Southern Pines: Southern Pines, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inis Cairde School of Irish Dance', 'inis-cairde-school-of-irish-dance-raleigh', 'Raleigh', 'North Carolina', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inis Cairde School of Irish Dance' and city = 'Raleigh'
);
-- Inis Cairde School of Irish Dance, Raleigh: Raleigh, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kilpatrick Irish Dance School', 'kilpatrick-irish-dance-school-fuquay-varina', 'Fuquay-Varina', 'North Carolina', 'United States', 'https://kilpatrickirishdance.com/',
  '202 North Main St', '27526', 35.586712, -78.799823, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kilpatrick Irish Dance School' and city = 'Fuquay-Varina'
);
-- Kilpatrick Irish Dance School, Fuquay-Varina: 202 N MAIN ST, FUQUAY VARINA, NC, 27526

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Triggle Academy of Irish Dance', 'triggle-academy-of-irish-dance-cary', 'Cary', 'North Carolina', 'United States', 'https://triggleacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Triggle Academy of Irish Dance' and city = 'Cary'
);
-- Triggle Academy of Irish Dance, Cary: Cary, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Triggle Academy of Irish Dance', 'triggle-academy-of-irish-dance-chapel-hill', 'Chapel Hill', 'North Carolina', 'United States', 'https://triggleacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Triggle Academy of Irish Dance' and city = 'Chapel Hill'
);
-- Triggle Academy of Irish Dance, Chapel Hill: Chapel Hill, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Walsh Kelley School of Irish Dancing', 'walsh-kelley-school-of-irish-dancing-charlotte', 'Charlotte', 'North Carolina', 'United States', 'https://www.walshkelleyschool.com/',
  '5668 International Dr', '28270', 35.135597, -80.779519, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Walsh Kelley School of Irish Dancing' and city = 'Charlotte'
);
-- Walsh Kelley School of Irish Dancing, Charlotte: 5668 INTERNATIONAL DR, CHARLOTTE, NC, 28270

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Walsh Kelley School of Irish Dancing', 'walsh-kelley-school-of-irish-dancing-greensboro', 'Greensboro', 'North Carolina', 'United States', 'https://www.walshkelleyschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Walsh Kelley School of Irish Dancing' and city = 'Greensboro'
);
-- Walsh Kelley School of Irish Dancing, Greensboro: Greensboro, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Walsh Kelley School of Irish Dancing', 'walsh-kelley-school-of-irish-dancing-wilmington', 'Wilmington', 'North Carolina', 'United States', 'https://www.walshkelleyschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Walsh Kelley School of Irish Dancing' and city = 'Wilmington'
);
-- Walsh Kelley School of Irish Dancing, Wilmington: Wilmington, NC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy (Connick-Reid)', 'connick-school-reid-academy-connick-reid-lexington', 'Lexington', 'South Carolina', 'United States', 'https://www.connickschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy (Connick-Reid)' and city = 'Lexington'
);
-- Connick School & Reid Academy (Connick-Reid), Lexington: Lexington, SC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy (Connick-Reid)', 'connick-school-reid-academy-connick-reid-columbia', 'Columbia', 'South Carolina', 'United States', 'https://www.connickschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy (Connick-Reid)' and city = 'Columbia'
);
-- Connick School & Reid Academy (Connick-Reid), Columbia: Columbia, SC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Connick School & Reid Academy (Connick-Reid)', 'connick-school-reid-academy-connick-reid-spartanburg', 'Spartanburg', 'South Carolina', 'United States', 'https://www.connickschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Connick School & Reid Academy (Connick-Reid)' and city = 'Spartanburg'
);
-- Connick School & Reid Academy (Connick-Reid), Spartanburg: Spartanburg, SC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Legacy Irish Dance Academy', 'legacy-irish-dance-academy-mt-pleasant', 'Mt. Pleasant', 'South Carolina', 'United States', 'https://legacyirishdance.com/',
  '561 Belle Station Blvd', null, 32.842342, -79.854280, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Legacy Irish Dance Academy' and city = 'Mt. Pleasant'
);
-- Legacy Irish Dance Academy, Mt. Pleasant: 561 BELLE STATION BLVD, MT PLEASANT, SC, 29464

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Legacy Irish Dance Academy', 'legacy-irish-dance-academy-summerville', 'Summerville', 'South Carolina', 'United States', 'https://legacyirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Legacy Irish Dance Academy' and city = 'Summerville'
);
-- Legacy Irish Dance Academy, Summerville: Summerville, SC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Keefe Academy of Irish Dance', 'okeefe-academy-of-irish-dance-summerville', 'Summerville', 'South Carolina', 'United States', 'https://www.okeefeacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Keefe Academy of Irish Dance' and city = 'Summerville'
);
-- O'Keefe Academy of Irish Dance, Summerville: Summerville, SC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carpenter Academy of Irish Dance', 'carpenter-academy-of-irish-dance-buford', 'Buford', 'Georgia', 'United States', 'https://www.carpenteririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carpenter Academy of Irish Dance' and city = 'Buford'
);
-- Carpenter Academy of Irish Dance, Buford: Buford, GA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carpenter Academy of Irish Dance', 'carpenter-academy-of-irish-dance-athens', 'Athens', 'Georgia', 'United States', 'https://www.carpenteririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carpenter Academy of Irish Dance' and city = 'Athens'
);
-- Carpenter Academy of Irish Dance, Athens: Athens, GA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carpenter Academy of Irish Dance', 'carpenter-academy-of-irish-dance-woodstock', 'Woodstock', 'Georgia', 'United States', 'https://www.carpenteririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carpenter Academy of Irish Dance' and city = 'Woodstock'
);
-- Carpenter Academy of Irish Dance, Woodstock: Woodstock, GA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Drake School of Irish Dance', 'drake-school-of-irish-dance-norcross', 'Norcross', 'Georgia', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Drake School of Irish Dance' and city = 'Norcross'
);
-- Drake School of Irish Dance, Norcross: Norcross, GA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Legacy Irish Dance Academy', 'legacy-irish-dance-academy-savannah', 'Savannah', 'Georgia', 'United States', 'https://legacyirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Legacy Irish Dance Academy' and city = 'Savannah'
);
-- Legacy Irish Dance Academy, Savannah: Savannah, GA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)', 'sarah-costello-irish-dance-academy-usa-central-florida-irish-dance-augusta', 'Augusta', 'Georgia', 'United States', 'https://www.centralfloridairishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)' and city = 'Augusta'
);
-- Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance), Augusta: Augusta, GA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carpenter Academy of Irish Dance', 'carpenter-academy-of-irish-dance-fort-walton-beach', 'Fort Walton Beach', 'Florida', 'United States', 'https://www.carpenteririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carpenter Academy of Irish Dance' and city = 'Fort Walton Beach'
);
-- Carpenter Academy of Irish Dance, Fort Walton Beach: Fort Walton Beach, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carpenter Academy of Irish Dance', 'carpenter-academy-of-irish-dance-panama-city', 'Panama City', 'Florida', 'United States', 'https://www.carpenteririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carpenter Academy of Irish Dance' and city = 'Panama City'
);
-- Carpenter Academy of Irish Dance, Panama City: Panama City, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Drake Irish Dance', 'drake-irish-dance-coral-springs', 'Coral Springs', 'Florida', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Drake Irish Dance' and city = 'Coral Springs'
);
-- Drake Irish Dance, Coral Springs: Coral Springs, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Drake Irish Dance', 'drake-irish-dance-fort-lauderdale', 'Fort Lauderdale', 'Florida', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Drake Irish Dance' and city = 'Fort Lauderdale'
);
-- Drake Irish Dance, Fort Lauderdale: Fort Lauderdale, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ealaiontoir School of Irish Arts', 'ealaiontoir-school-of-irish-arts-winter-garden', 'Winter Garden', 'Florida', 'United States', 'https://ealaiontoirschool.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ealaiontoir School of Irish Arts' and city = 'Winter Garden'
);
-- Ealaiontoir School of Irish Arts, Winter Garden: Winter Garden, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-orlando', 'Orlando', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Orlando'
);
-- Finnegan Academy of Irish Dance, Orlando: Orlando, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-sarasota', 'Sarasota', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Sarasota'
);
-- Finnegan Academy of Irish Dance, Sarasota: Sarasota, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-lakewood-ranch', 'Lakewood Ranch', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Lakewood Ranch'
);
-- Finnegan Academy of Irish Dance, Lakewood Ranch: Lakewood Ranch, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-tampa', 'Tampa', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Tampa'
);
-- Finnegan Academy of Irish Dance, Tampa: Tampa, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-sarasota', 'Sarasota', 'Florida', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Sarasota'
);
-- Kavanagh Porter Academy of Irish Dance, Sarasota: Sarasota, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-naples', 'Naples', 'Florida', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Naples'
);
-- Kavanagh Porter Academy of Irish Dance, Naples: Naples, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-saint-augustine-beach', 'Saint Augustine Beach', 'Florida', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Saint Augustine Beach'
);
-- Kavanagh Porter Academy of Irish Dance, Saint Augustine Beach: Saint Augustine Beach, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly Academy of Irish Dance', 'kelly-academy-of-irish-dance-fort-lauderdale', 'Fort Lauderdale', 'Florida', 'United States', 'https://www.kellyacademyofirishdance.com/',
  '937 West Commercial Blvd', '33309', 26.188598, -80.156040, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kelly Academy of Irish Dance' and city = 'Fort Lauderdale'
);
-- Kelly Academy of Irish Dance, Fort Lauderdale: 937 W COMMERCIAL BLVD, FORT LAUDERDALE, FL, 33309

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Magennis Academy of Irish Dance', 'magennis-academy-of-irish-dance-melbourne', 'Melbourne', 'Florida', 'United States', 'https://magennisdanceacademy.com/',
  '814 W. New Haven Ave', '32901', 28.078896, -80.635031, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Magennis Academy of Irish Dance' and city = 'Melbourne'
);
-- Magennis Academy of Irish Dance, Melbourne: 814 W NEW HAVEN AVE, MELBOURNE, FL, 32901

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Magennis Academy of Irish Dance', 'magennis-academy-of-irish-dance-orlando', 'Orlando', 'Florida', 'United States', 'https://magennisdanceacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Magennis Academy of Irish Dance' and city = 'Orlando'
);
-- Magennis Academy of Irish Dance, Orlando: Orlando, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Montgomery Frank Academy of Irish Dance', 'montgomery-frank-academy-of-irish-dance-orlando', 'Orlando', 'Florida', 'United States', 'https://www.themontgomeryfrankacademy.com/',
  '11602 Lake Underhill Rd, Suite 126', '32825', 28.546195, -81.219144, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Montgomery Frank Academy of Irish Dance' and city = 'Orlando'
);
-- Montgomery Frank Academy of Irish Dance, Orlando: 11602 LAKE UNDERHILL RD, ORLANDO, FL, 32825

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Montgomery Frank Academy of Irish Dance', 'montgomery-frank-academy-of-irish-dance-viera', 'Viera', 'Florida', 'United States', 'https://www.themontgomeryfrankacademy.com/',
  '5555 US Highway 1', '32955', 28.265663, -80.689369, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Montgomery Frank Academy of Irish Dance' and city = 'Viera'
);
-- Montgomery Frank Academy of Irish Dance, Viera: 5555 US HWY 1, VIERA, FL, 32955

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Niall O''Leary School of Irish Dance', 'niall-oleary-school-of-irish-dance-miami', 'Miami', 'Florida', 'United States', 'https://nialloleary.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Niall O''Leary School of Irish Dance' and city = 'Miami'
);
-- Niall O'Leary School of Irish Dance, Miami: Miami, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-tampa', 'Tampa', 'Florida', 'United States', 'https://www.scariffschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'Tampa'
);
-- Scariff Locklier Leonelli School of Irish Dance, Tampa: Tampa, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-palm-harbor', 'Palm Harbor', 'Florida', 'United States', 'https://www.scariffschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'Palm Harbor'
);
-- Scariff Locklier Leonelli School of Irish Dance, Palm Harbor: Palm Harbor, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-st-petersburg', 'St. Petersburg', 'Florida', 'United States', 'https://www.scariffschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'St. Petersburg'
);
-- Scariff Locklier Leonelli School of Irish Dance, St. Petersburg: St. Petersburg, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)', 'sarah-costello-irish-dance-academy-usa-central-florida-irish-dance-celebration', 'Celebration', 'Florida', 'United States', 'https://www.centralfloridairishdance.com/',
  '851 Celebration Ave', '34747', 28.317808, -81.544783, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)' and city = 'Celebration'
);
-- Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance), Celebration: 851 CELEBRATION AVE, CELEBRATION, FL, 34747

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)', 'sarah-costello-irish-dance-academy-usa-central-florida-irish-dance-st-cloud', 'St. Cloud', 'Florida', 'United States', 'https://www.centralfloridairishdance.com/',
  '3001 17th St', '34769', 28.242359, -81.304090, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)' and city = 'St. Cloud'
);
-- Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance), St. Cloud: 3001 17TH ST, SAINT CLOUD, FL, 34769

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)', 'sarah-costello-irish-dance-academy-usa-central-florida-irish-dance-winter-park', 'Winter Park', 'Florida', 'United States', 'https://www.centralfloridairishdance.com/',
  '1015 S Orlando Ave', null, 28.588376, -81.365043, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)' and city = 'Winter Park'
);
-- Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance), Winter Park: 1015 S ORLANDO AVE, WINTER PARK, FL, 32789

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)', 'sarah-costello-irish-dance-academy-usa-central-florida-irish-dance-winter-garden', 'Winter Garden', 'Florida', 'United States', 'https://www.centralfloridairishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)' and city = 'Winter Garden'
);
-- Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance), Winter Garden: Winter Garden, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)', 'sarah-costello-irish-dance-academy-usa-central-florida-irish-dance-lake-nona', 'Lake Nona', 'Florida', 'United States', 'https://www.centralfloridairishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance)' and city = 'Lake Nona'
);
-- Sarah Costello Irish Dance Academy USA (Central Florida Irish Dance), Lake Nona: Lake Nona, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tir na Greine School of Irish Dance', 'tir-na-greine-school-of-irish-dance-palm-city', 'Palm City', 'Florida', 'United States', 'https://www.irishdanceflorida.net/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Tir na Greine School of Irish Dance' and city = 'Palm City'
);
-- Tir na Greine School of Irish Dance, Palm City: Palm City, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Watters School of Irish Dance', 'watters-school-of-irish-dance-ocoee', 'Ocoee', 'Florida', 'United States', 'https://www.wattersschool.com/',
  '415 N Clarke Rd', '34761', 28.575814, -81.517356, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Watters School of Irish Dance' and city = 'Ocoee'
);
-- Watters School of Irish Dance, Ocoee: 415 N CLARKE RD, OCOEE, FL, 34761

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Watters School of Irish Dance', 'watters-school-of-irish-dance-gainesville', 'Gainesville', 'Florida', 'United States', 'https://www.wattersschool.com/',
  '16 NW 7th Ave', '32601', 29.658103, -82.325205, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Watters School of Irish Dance' and city = 'Gainesville'
);
-- Watters School of Irish Dance, Gainesville: 16 NW 7TH AVE, GAINESVILLE, FL, 32601

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Breffni Academy of Irish Dance', 'breffni-academy-of-irish-dance-miami-shores', 'Miami Shores', 'Florida', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Breffni Academy of Irish Dance' and city = 'Miami Shores'
);
-- Breffni Academy of Irish Dance, Miami Shores: Miami Shores, FL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Drake School of Irish Dance (Celtic Traditions)', 'drake-school-of-irish-dance-celtic-traditions-opelika', 'Opelika', 'Alabama', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Drake School of Irish Dance (Celtic Traditions)' and city = 'Opelika'
);
-- Drake School of Irish Dance (Celtic Traditions), Opelika: Opelika, AL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Drake School of Irish Dance (Celtic Traditions)', 'drake-school-of-irish-dance-celtic-traditions-birmingham', 'Birmingham', 'Alabama', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Drake School of Irish Dance (Celtic Traditions)' and city = 'Birmingham'
);
-- Drake School of Irish Dance (Celtic Traditions), Birmingham: Birmingham, AL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Drake School of Irish Dance (Celtic Traditions)', 'drake-school-of-irish-dance-celtic-traditions-pelham', 'Pelham', 'Alabama', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Drake School of Irish Dance (Celtic Traditions)' and city = 'Pelham'
);
-- Drake School of Irish Dance (Celtic Traditions), Pelham: Pelham, AL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Southern Irish Dance', 'southern-irish-dance-madison', 'Madison', 'Alabama', 'United States', 'https://www.southernirishdancetn.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Southern Irish Dance' and city = 'Madison'
);
-- Southern Irish Dance, Madison: Madison, AL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Niall O''Leary School of Irish Dance', 'niall-oleary-school-of-irish-dance-diberville', 'D''Iberville', 'Mississippi', 'United States', 'https://niallolearyms.com/',
  '10598 D''Iberville Blvd', '39540', 30.440904, -88.898226, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Niall O''Leary School of Irish Dance' and city = 'D''Iberville'
);
-- Niall O'Leary School of Irish Dance, D'Iberville: 10598 DIBERVILLE BLVD, DIBERVILLE, MS, 39540

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maccrossan School of Irish Dance', 'maccrossan-school-of-irish-dance-ocean-springs', 'Ocean Springs', 'Mississippi', 'United States', 'https://www.maccrossanirishdance.jigsy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maccrossan School of Irish Dance' and city = 'Ocean Springs'
);
-- Maccrossan School of Irish Dance, Ocean Springs: Ocean Springs, MS (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Muggivan School of Irish Dance', 'muggivan-school-of-irish-dance-new-orleans', 'New Orleans', 'Louisiana', 'United States', 'https://muggivanirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Muggivan School of Irish Dance' and city = 'New Orleans'
);
-- Muggivan School of Irish Dance, New Orleans: New Orleans, LA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cass-Barrington Academy of Irish Dance', 'cass-barrington-academy-of-irish-dance-houston', 'Houston', 'Texas', 'United States', 'https://www.cass-barrington.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cass-Barrington Academy of Irish Dance' and city = 'Houston'
);
-- Cass-Barrington Academy of Irish Dance, Houston: Houston, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cass-Barrington Academy of Irish Dance', 'cass-barrington-academy-of-irish-dance-the-woodlands', 'The Woodlands', 'Texas', 'United States', 'https://www.cass-barrington.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cass-Barrington Academy of Irish Dance' and city = 'The Woodlands'
);
-- Cass-Barrington Academy of Irish Dance, The Woodlands: The Woodlands, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cass-Barrington Academy of Irish Dance', 'cass-barrington-academy-of-irish-dance-katy', 'Katy', 'Texas', 'United States', 'https://www.cass-barrington.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cass-Barrington Academy of Irish Dance' and city = 'Katy'
);
-- Cass-Barrington Academy of Irish Dance, Katy: Katy, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cass-Barrington Academy of Irish Dance', 'cass-barrington-academy-of-irish-dance-pearland', 'Pearland', 'Texas', 'United States', 'https://www.cass-barrington.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cass-Barrington Academy of Irish Dance' and city = 'Pearland'
);
-- Cass-Barrington Academy of Irish Dance, Pearland: Pearland, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Kelly School of Irish Dance', 'clann-kelly-school-of-irish-dance-houston', 'Houston', 'Texas', 'United States', 'https://www.clannkelly.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Kelly School of Irish Dance' and city = 'Houston'
);
-- Clann Kelly School of Irish Dance, Houston: Houston, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Gildea School of Irish Dance', 'gildea-school-of-irish-dance-corpus-christi', 'Corpus Christi', 'Texas', 'United States', 'https://www.ccirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Gildea School of Irish Dance' and city = 'Corpus Christi'
);
-- Gildea School of Irish Dance, Corpus Christi: Corpus Christi, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance', 'inishfree-school-of-irish-dance-austin', 'Austin', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance' and city = 'Austin'
);
-- Inishfree School of Irish Dance, Austin: Austin, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance', 'inishfree-school-of-irish-dance-san-antonio', 'San Antonio', 'Texas', 'United States', 'https://www.inishfreesanantonio.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance' and city = 'San Antonio'
);
-- Inishfree School of Irish Dance, San Antonio: San Antonio, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance', 'inishfree-school-of-irish-dance-round-rock', 'Round Rock', 'Texas', 'United States', 'https://inishfreetx.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance' and city = 'Round Rock'
);
-- Inishfree School of Irish Dance, Round Rock: Round Rock, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance (Emerald School)', 'inishfree-school-of-irish-dance-emerald-school-dallas', 'Dallas', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance (Emerald School)' and city = 'Dallas'
);
-- Inishfree School of Irish Dance (Emerald School), Dallas: Dallas, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance', 'inishfree-school-of-irish-dance-fort-worth', 'Fort Worth', 'Texas', 'United States', 'https://inishfreetx.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance' and city = 'Fort Worth'
);
-- Inishfree School of Irish Dance, Fort Worth: Fort Worth, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance', 'inishfree-school-of-irish-dance-frisco', 'Frisco', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance' and city = 'Frisco'
);
-- Inishfree School of Irish Dance, Frisco: Frisco, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance', 'inishfree-school-of-irish-dance-carrollton', 'Carrollton', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance' and city = 'Carrollton'
);
-- Inishfree School of Irish Dance, Carrollton: Carrollton, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dance', 'inishfree-school-of-irish-dance-flower-mound', 'Flower Mound', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dance' and city = 'Flower Mound'
);
-- Inishfree School of Irish Dance, Flower Mound: Flower Mound, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Irish Dance Center', 'irish-dance-center-houston', 'Houston', 'Texas', 'United States', 'https://www.irishdancecenter.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Irish Dance Center' and city = 'Houston'
);
-- Irish Dance Center, Houston: Houston, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maguire Academy of Irish Dance', 'maguire-academy-of-irish-dance-dallas', 'Dallas', 'Texas', 'United States', 'https://maguireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maguire Academy of Irish Dance' and city = 'Dallas'
);
-- Maguire Academy of Irish Dance, Dallas: Dallas, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maguire Academy of Irish Dance', 'maguire-academy-of-irish-dance-houston', 'Houston', 'Texas', 'United States', 'https://maguireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maguire Academy of Irish Dance' and city = 'Houston'
);
-- Maguire Academy of Irish Dance, Houston: Houston, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McLane School of Irish Dance', 'mclane-school-of-irish-dance-richardson', 'Richardson', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McLane School of Irish Dance' and city = 'Richardson'
);
-- McLane School of Irish Dance, Richardson: Richardson, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers of South Texas (Houston)', 'mcteggart-irish-dancers-of-south-texas-houston', 'Houston', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers of South Texas (Houston)' and city = 'Houston'
);
-- McTeggart Irish Dancers of South Texas (Houston), Houston: Houston, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers of North Texas', 'mcteggart-irish-dancers-of-north-texas-hurst', 'Hurst', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers of North Texas' and city = 'Hurst'
);
-- McTeggart Irish Dancers of North Texas, Hurst: Hurst, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shandon-O''Regan Irish Dance Academy', 'shandon-oregan-irish-dance-academy-mckinney', 'McKinney', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Shandon-O''Regan Irish Dance Academy' and city = 'McKinney'
);
-- Shandon-O'Regan Irish Dance Academy, McKinney: McKinney, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shandon-O''Regan Irish Dance Academy', 'shandon-oregan-irish-dance-academy-allen', 'Allen', 'Texas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Shandon-O''Regan Irish Dance Academy' and city = 'Allen'
);
-- Shandon-O'Regan Irish Dance Academy, Allen: Allen, TX (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Southern Irish Dance', 'southern-irish-dance-brentwood', 'Brentwood', 'Tennessee', 'United States', 'https://www.southernirishdancetn.com/',
  '1710 General George Patton Drive, #107', '37027', 35.966459, -86.819553, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Southern Irish Dance' and city = 'Brentwood'
);
-- Southern Irish Dance, Brentwood: 1710 GENERAL GEORGE PATTON DR, BRENTWOOD, TN, 37027

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Southern Irish Dance', 'southern-irish-dance-nolensville', 'Nolensville', 'Tennessee', 'United States', 'https://www.southernirishdancetn.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Southern Irish Dance' and city = 'Nolensville'
);
-- Southern Irish Dance, Nolensville: Nolensville, TN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Southern Irish Dance', 'southern-irish-dance-chattanooga', 'Chattanooga', 'Tennessee', 'United States', 'https://www.southernirishdancetn.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Southern Irish Dance' and city = 'Chattanooga'
);
-- Southern Irish Dance, Chattanooga: Chattanooga, TN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scott-Ellis School of Irish Dance', 'scott-ellis-school-of-irish-dance-nashville', 'Nashville', 'Tennessee', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scott-Ellis School of Irish Dance' and city = 'Nashville'
);
-- Scott-Ellis School of Irish Dance, Nashville: Nashville, TN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Nashville Irish Step Dancers', 'nashville-irish-step-dancers-nashville', 'Nashville', 'Tennessee', 'United States', 'https://www.nashvilleirishstepdancers.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Nashville Irish Step Dancers' and city = 'Nashville'
);
-- Nashville Irish Step Dancers, Nashville: Nashville, TN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Ríoga (Kristin Butke Irish Dance)', 'clann-rioga-kristin-butke-irish-dance-nashville', 'Nashville', 'Tennessee', 'United States', 'https://kristinbutkeirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Ríoga (Kristin Butke Irish Dance)' and city = 'Nashville'
);
-- Clann Ríoga (Kristin Butke Irish Dance), Nashville: Nashville, TN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McCafferty Academy of Irish Dance', 'mccafferty-academy-of-irish-dance-little-rock', 'Little Rock', 'Arkansas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McCafferty Academy of Irish Dance' and city = 'Little Rock'
);
-- McCafferty Academy of Irish Dance, Little Rock: Little Rock, AR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Donovan School of Irish Dance', 'odonovan-school-of-irish-dance-sherwood', 'Sherwood', 'Arkansas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Donovan School of Irish Dance' and city = 'Sherwood'
);
-- O'Donovan School of Irish Dance, Sherwood: Sherwood, AR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Arkansas Academy of Irish Dance', 'rince-arkansas-academy-of-irish-dance-fayetteville', 'Fayetteville', 'Arkansas', 'United States', 'https://rincearkansas.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Arkansas Academy of Irish Dance' and city = 'Fayetteville'
);
-- Rince Arkansas Academy of Irish Dance, Fayetteville: Fayetteville, AR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goode Academy of Irish Dance', 'goode-academy-of-irish-dance-tulsa', 'Tulsa', 'Oklahoma', 'United States', 'https://www.thegoodeacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Goode Academy of Irish Dance' and city = 'Tulsa'
);
-- Goode Academy of Irish Dance, Tulsa: Tulsa, OK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McCafferty Academy of Irish Dance', 'mccafferty-academy-of-irish-dance-tahlequah', 'Tahlequah', 'Oklahoma', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McCafferty Academy of Irish Dance' and city = 'Tahlequah'
);
-- McCafferty Academy of Irish Dance, Tahlequah: Tahlequah, OK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dance (Oklahoma)', 'mcteggart-irish-dance-oklahoma-oklahoma-city', 'Oklahoma City', 'Oklahoma', 'United States', 'https://www.mcteggartokc.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dance (Oklahoma)' and city = 'Oklahoma City'
);
-- McTeggart Irish Dance (Oklahoma), Oklahoma City: Oklahoma City, OK (city-only)
