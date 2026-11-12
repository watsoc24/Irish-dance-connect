-- School directory seed — New England (CT, MA, ME, NH, RI, VT): 66 locations
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Every row below was verified 2026-11-12 from the NEIDT state school lists
-- (neidt.org/schools-*), IDTANA Find a School, each school's own website,
-- and the FeisWorx school list as a name-universe cross-check. No address
-- was invented. Street address + ZIP are shown ONLY where the school itself
-- published them; otherwise the row is city-only. See
-- research_notes/irish-dance-schools-all-us/new-england.md for sources and
-- the full "Unverified / partial" list — nothing from that section is seeded
-- here (closed/merged schools, names with no verifiable location).
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
--
-- Counts: CT 16, MA 38, ME 1, NH 3, RI 6, VT 2 (66 total; the research file
-- lists 69 verified — 3 rows were dropped as duplicates of the Ohio seed,
-- see below). Street precision 25, city precision 41.
--
-- Completeness (from the research file): Maine complete (1 — Stillson is the
-- only certified school in the state). New Hampshire complete for NEIDT names
-- (3). Vermont complete for NEIDT names (2) but thin — Garrett's site looks
-- stale (2020 content) and McFadden's current studio city is uncertain
-- (Burlington vs Williston). Rhode Island complete for NEIDT names (6).
-- Connecticut nearly complete (16; Doherty Petri Bethel is included but its
-- current CT status is uncertain — the school's current bio lists only NY
-- studios). Massachusetts partial (38) — several MA rows are city-only
-- because the schools do not publish a street address, and small/independent
-- programs are very likely still missing.
--
-- website_url is NULL for 14 rows: 12 because the schools' sites are
-- http-only as published (Ashurst, Forbes, Heavey Quinn, Lenihan, Murphy,
-- Petrocelli, McHale, McFadden, Thorne, BoSoma) and 2 because no website was
-- found (Anam Cara, Black Rose). Facebook-only schools keep their https
-- Facebook URL (Horgan Academy, Dunleavy Boyle). The Kelly School's domain
-- is flagged http-only in the research file's counts section, but the file's
-- own table lists it as https and it returned HTTP 200 on a live check, so
-- its https URL is kept. Every other website URL was checked live
-- over https on 2026-11-12 and returned HTTP 200.
--
-- Coordinates: US Census Geocoder (Public_AR_Current benchmark) for street
-- addresses. City-only rows have NO coordinates unless a verified ZIP was
-- available: the Census Geocoder cannot resolve a bare "City, ST" (tested —
-- it returns No_Match), and no New England city-only row carries a verified
-- ZIP, so there was no Zippopotam.us fallback to use. Those rows keep
-- latitude/longitude/geo_precision/geo_source NULL rather than invented
-- coordinates; the schools remain listed and searchable by city.
-- Street addresses that failed to geocode: none in this file except
-- O'Shea-Chaplin Newton (105 Rumford Ave), which matched under Auburndale, MA
-- (a village of Newton — the research file itself says "(Auburndale, Newton)");
-- the Census matched address is in the row comment. Scoil Rince Bréifne
-- Ó Ruairc, Pittsfield, carries its street address (395 North St, 01201)
-- from the CRN list (Terpsichore Dance Center schedule) — the NEIDT/NE file
-- itself only had a PO Box, and the CRN entry for the same school under its
-- old Breffny name was merged here rather than seeded twice.
--
-- Dropped as duplicates of the Ohio seed (schools_ohio_seed.sql):
-- Haley School of Irish Dance, Whitman; Sullivan-Stewart School of Irish
-- Dance, Plainville; Woods School of Irish Dance, Boston (same school as the
-- Ohio seed's Woods, South Boston — the NE file's own note says South
-- Boston). Nothing else in this file duplicates the Ohio seed.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists, so the file is safe to re-run. Status is 'unclaimed'
-- (default) — these listings have not been claimed by the schools.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Anam Cara Irish Dance School', 'anam-cara-irish-dance-school-stamford', 'Stamford', 'Connecticut', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Anam Cara Irish Dance School' and city = 'Stamford'
);
-- Anam Cara Irish Dance School, Stamford: Stamford, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ashurst Academy of Irish Dance', 'ashurst-academy-of-irish-dance-newtown', 'Newtown', 'Connecticut', 'United States', null,
  '3 Simm Lane', null, 41.390383, -73.289444, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ashurst Academy of Irish Dance' and city = 'Newtown'
);
-- Ashurst Academy of Irish Dance, Newtown: 3 SIMM LN, NEWTOWN, CT, 06470

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brennan-Lucey Irish Dance Academy', 'brennan-lucey-irish-dance-academy-fairfield', 'Fairfield', 'Connecticut', 'United States', 'https://www.brennanlucey.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brennan-Lucey Irish Dance Academy' and city = 'Fairfield'
);
-- Brennan-Lucey Irish Dance Academy, Fairfield: Fairfield, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brennan-Lucey Irish Dance Academy', 'brennan-lucey-irish-dance-academy-milford', 'Milford', 'Connecticut', 'United States', 'https://www.brennanlucey.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brennan-Lucey Irish Dance Academy' and city = 'Milford'
);
-- Brennan-Lucey Irish Dance Academy, Milford: Milford, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brennan-Lucey Irish Dance Academy', 'brennan-lucey-irish-dance-academy-hamden', 'Hamden', 'Connecticut', 'United States', 'https://www.brennanlucey.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brennan-Lucey Irish Dance Academy' and city = 'Hamden'
);
-- Brennan-Lucey Irish Dance Academy, Hamden: Hamden, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-bethel', 'Bethel', 'Connecticut', 'United States', 'https://petrischool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'Bethel'
);
-- Doherty Petri School of Irish Dance, Bethel: Bethel, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Gray School of Irish Dance', 'gray-school-of-irish-dance-old-saybrook', 'Old Saybrook', 'Connecticut', 'United States', 'https://www.grayschool.com/',
  '881 Boston Post Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Gray School of Irish Dance' and city = 'Old Saybrook'
);
-- Gray School of Irish Dance, Old Saybrook: 881 Boston Post Rd, Old Saybrook, CT (street address did not match Census (batch + single-lookup variants); no verified ZIP, so no coordinates — kept as published)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Griffith Academy of Irish Dance', 'griffith-academy-of-irish-dance-wethersfield', 'Wethersfield', 'Connecticut', 'United States', 'https://griffithacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Griffith Academy of Irish Dance' and city = 'Wethersfield'
);
-- Griffith Academy of Irish Dance, Wethersfield: Wethersfield, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harney Pender Keady Academy of Irish Dance', 'harney-pender-keady-academy-of-irish-dance-stamford', 'Stamford', 'Connecticut', 'United States', 'https://penderkeady.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Harney Pender Keady Academy of Irish Dance' and city = 'Stamford'
);
-- Harney Pender Keady Academy of Irish Dance, Stamford: Stamford, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Horgan Academy of Irish Dance', 'horgan-academy-of-irish-dance-naugatuck', 'Naugatuck', 'Connecticut', 'United States', 'https://www.facebook.com/440412346001405/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Horgan Academy of Irish Dance' and city = 'Naugatuck'
);
-- Horgan Academy of Irish Dance, Naugatuck: Naugatuck, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Lenihan School of Irish Dance', 'lenihan-school-of-irish-dance-fairfield', 'Fairfield', 'Connecticut', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Lenihan School of Irish Dance' and city = 'Fairfield'
);
-- Lenihan School of Irish Dance, Fairfield: Fairfield, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mulcahy Academy of Irish Dance', 'mulcahy-academy-of-irish-dance-glastonbury', 'Glastonbury', 'Connecticut', 'United States', 'https://mulcahyacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mulcahy Academy of Irish Dance' and city = 'Glastonbury'
);
-- Mulcahy Academy of Irish Dance, Glastonbury: Glastonbury, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Luimni', 'scoil-rince-luimni-south-windsor', 'South Windsor', 'Connecticut', 'United States', 'https://www.irishdancect.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Luimni' and city = 'South Windsor'
);
-- Scoil Rince Luimni, South Windsor: South Windsor, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shamrock School of Irish Dance', 'shamrock-school-of-irish-dance-plainville', 'Plainville', 'Connecticut', 'United States', 'https://www.shamrockdancect.com/',
  '75 East St', '06062', 41.669254, -72.861022, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Shamrock School of Irish Dance' and city = 'Plainville'
);
-- Shamrock School of Irish Dance, Plainville: 75 EAST ST, PLAINVILLE, CT, 06062

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Spirited Soles Irish Dance Academy', 'spirited-soles-irish-dance-academy-niantic', 'Niantic', 'Connecticut', 'United States', 'https://www.spiritedsolesirishdance.com/',
  '6 Liberty Way', null, 41.318603, -72.244343, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Spirited Soles Irish Dance Academy' and city = 'Niantic'
);
-- Spirited Soles Irish Dance Academy, Niantic: 6 LIBERTY WAY, NIANTIC, CT, 06357

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Thorne Academy of Irish Dance', 'thorne-academy-of-irish-dance-danbury', 'Danbury', 'Connecticut', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Thorne Academy of Irish Dance' and city = 'Danbury'
);
-- Thorne Academy of Irish Dance, Danbury: Danbury, CT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Black Rose Academy of Irish Dance', 'black-rose-academy-of-irish-dance-chicopee', 'Chicopee', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Black Rose Academy of Irish Dance' and city = 'Chicopee'
);
-- Black Rose Academy of Irish Dance, Chicopee: Chicopee, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'BoSoma School of Irish Dance', 'bosoma-school-of-irish-dance-georgetown', 'Georgetown', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'BoSoma School of Irish Dance' and city = 'Georgetown'
);
-- BoSoma School of Irish Dance, Georgetown: Georgetown, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'BoSoma School of Irish Dance', 'bosoma-school-of-irish-dance-hamilton', 'Hamilton', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'BoSoma School of Irish Dance' and city = 'Hamilton'
);
-- BoSoma School of Irish Dance, Hamilton: Hamilton, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-quincy', 'Quincy', 'Massachusetts', 'United States', 'https://www.bradyacademy.com/',
  '164 Bellevue Rd', '02171', 42.297197, -71.008417, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Quincy'
);
-- Brady Academy of Irish Dance, Quincy: 164 BELLEVUE RD, QUINCY, MA, 02171

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-milton', 'Milton', 'Massachusetts', 'United States', 'https://www.bradyacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Milton'
);
-- Brady Academy of Irish Dance, Milton: Milton, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cassin Academy of Irish Dance', 'cassin-academy-of-irish-dance-west-springfield', 'West Springfield', 'Massachusetts', 'United States', 'https://www.cassinirishdance.com/',
  '63 Myron St', '01089', 42.133006, -72.628411, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Cassin Academy of Irish Dance' and city = 'West Springfield'
);
-- Cassin Academy of Irish Dance, West Springfield: 63 MYRON ST, WEST SPRINGFIELD, MA, 01089

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cassin Academy of Irish Dance', 'cassin-academy-of-irish-dance-east-longmeadow', 'East Longmeadow', 'Massachusetts', 'United States', 'https://www.cassinirishdance.com/',
  '84 Porter Rd', '01028', 42.074797, -72.496655, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Cassin Academy of Irish Dance' and city = 'East Longmeadow'
);
-- Cassin Academy of Irish Dance, East Longmeadow: 84 PORTER RD, EAST LONGMEADOW, MA, 01028

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Claddagh School of Irish Dance', 'claddagh-school-of-irish-dance-springfield', 'Springfield', 'Massachusetts', 'United States', 'https://claddaghschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Claddagh School of Irish Dance' and city = 'Springfield'
);
-- Claddagh School of Irish Dance, Springfield: Springfield, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Lir Academy', 'clann-lir-academy-hingham', 'Hingham', 'Massachusetts', 'United States', 'https://clannliracademy.com/',
  '38 Whiting St', '02043', 42.175529, -70.888690, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Clann Lir Academy' and city = 'Hingham'
);
-- Clann Lir Academy, Hingham: 38 WHITING ST, HINGHAM, MA, 02043

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Lir Academy', 'clann-lir-academy-scituate', 'Scituate', 'Massachusetts', 'United States', 'https://clannliracademy.com/',
  '465 First Parish Rd', '02066', 42.196774, -70.766145, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Clann Lir Academy' and city = 'Scituate'
);
-- Clann Lir Academy, Scituate: 465 1ST PARISH RD, SCITUATE, MA, 02066

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dunleavy Boyle Academy of Irish Dance', 'dunleavy-boyle-academy-of-irish-dance-hanover', 'Hanover', 'Massachusetts', 'United States', 'https://www.facebook.com/SouthShoreIrishDanceAcademy',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dunleavy Boyle Academy of Irish Dance' and city = 'Hanover'
);
-- Dunleavy Boyle Academy of Irish Dance, Hanover: Hanover, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Forbes School of Irish Dance', 'forbes-school-of-irish-dance-quincy', 'Quincy', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Forbes School of Irish Dance' and city = 'Quincy'
);
-- Forbes School of Irish Dance, Quincy: Quincy, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goulding School of Irish Dance', 'goulding-school-of-irish-dance-medford', 'Medford', 'Massachusetts', 'United States', 'https://gouldingschoolofirishdance.com/',
  '467 High St', null, 42.421188, -71.131971, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Goulding School of Irish Dance' and city = 'Medford'
);
-- Goulding School of Irish Dance, Medford: 467 HIGH ST, MEDFORD, MA, 02155

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goulding School of Irish Dance', 'goulding-school-of-irish-dance-needham', 'Needham', 'Massachusetts', 'United States', 'https://gouldingschoolofirishdance.com/',
  '20 Junction St', null, 42.273326, -71.237648, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Goulding School of Irish Dance' and city = 'Needham'
);
-- Goulding School of Irish Dance, Needham: 20 JUNCTION ST, NEEDHAM, MA, 02492

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley School of Irish Dance', 'haley-school-of-irish-dance-braintree', 'Braintree', 'Massachusetts', 'United States', 'https://mhaleyirishdance.wixsite.com/haley-school-of-iris',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haley School of Irish Dance' and city = 'Braintree'
);
-- Haley School of Irish Dance, Braintree: Braintree, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley School of Irish Dance', 'haley-school-of-irish-dance-canton', 'Canton', 'Massachusetts', 'United States', 'https://mhaleyirishdance.wixsite.com/haley-school-of-iris',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haley School of Irish Dance' and city = 'Canton'
);
-- Haley School of Irish Dance, Canton: Canton, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley School of Irish Dance', 'haley-school-of-irish-dance-duxbury', 'Duxbury', 'Massachusetts', 'United States', 'https://mhaleyirishdance.wixsite.com/haley-school-of-iris',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haley School of Irish Dance' and city = 'Duxbury'
);
-- Haley School of Irish Dance, Duxbury: Duxbury, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley School of Irish Dance', 'haley-school-of-irish-dance-sandwich', 'Sandwich', 'Massachusetts', 'United States', 'https://mhaleyirishdance.wixsite.com/haley-school-of-iris',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haley School of Irish Dance' and city = 'Sandwich'
);
-- Haley School of Irish Dance, Sandwich: Sandwich, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harney-Crawford Academy of Irish Dance', 'harney-crawford-academy-of-irish-dance-walpole', 'Walpole', 'Massachusetts', 'United States', 'https://www.harneycrawford.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Harney-Crawford Academy of Irish Dance' and city = 'Walpole'
);
-- Harney-Crawford Academy of Irish Dance, Walpole: Walpole, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Heavey Quinn Academy of Irish Dance', 'heavey-quinn-academy-of-irish-dance-chelmsford', 'Chelmsford', 'Massachusetts', 'United States', null,
  '11 Progress Ave', '01824', 42.596778, -71.322509, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Heavey Quinn Academy of Irish Dance' and city = 'Chelmsford'
);
-- Heavey Quinn Academy of Irish Dance, Chelmsford: 11 PROGRESS AVE, CHELMSFORD, MA, 01824

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Heavey Quinn Academy of Irish Dance', 'heavey-quinn-academy-of-irish-dance-framingham', 'Framingham', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Heavey Quinn Academy of Irish Dance' and city = 'Framingham'
);
-- Heavey Quinn Academy of Irish Dance, Framingham: Framingham, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree Massachusetts School of Irish Dance', 'inishfree-massachusetts-school-of-irish-dance-west-concord', 'West Concord', 'Massachusetts', 'United States', 'https://www.inishfreema.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree Massachusetts School of Irish Dance' and city = 'West Concord'
);
-- Inishfree Massachusetts School of Irish Dance, West Concord: West Concord, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kanaley School of Irish Dance', 'kanaley-school-of-irish-dance-east-wareham', 'East Wareham', 'Massachusetts', 'United States', 'https://www.kanaleyschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kanaley School of Irish Dance' and city = 'East Wareham'
);
-- Kanaley School of Irish Dance, East Wareham: East Wareham, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kanaley School of Irish Dance', 'kanaley-school-of-irish-dance-yarmouth', 'Yarmouth', 'Massachusetts', 'United States', 'https://www.kanaleyschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kanaley School of Irish Dance' and city = 'Yarmouth'
);
-- Kanaley School of Irish Dance, Yarmouth: Yarmouth, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Keane O''Brien Academy of Irish Dance', 'keane-obrien-academy-of-irish-dance-holbrook', 'Holbrook', 'Massachusetts', 'United States', 'https://keaneobrienacademy.com/',
  '424 N Franklin St', '02343', 42.166537, -71.006887, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Keane O''Brien Academy of Irish Dance' and city = 'Holbrook'
);
-- Keane O'Brien Academy of Irish Dance, Holbrook: 424 N FRANKLIN ST, HOLBROOK, MA, 02343

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Keane O''Brien Academy of Irish Dance', 'keane-obrien-academy-of-irish-dance-north-reading', 'North Reading', 'Massachusetts', 'United States', 'https://keaneobrienacademy.com/',
  '52 Main St', '01864', 42.569079, -71.109106, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Keane O''Brien Academy of Irish Dance' and city = 'North Reading'
);
-- Keane O'Brien Academy of Irish Dance, North Reading: 52 MAIN ST, NORTH READING, MA, 01864

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGonagle School of Irish Dance', 'mcgonagle-school-of-irish-dance-wakefield', 'Wakefield', 'Massachusetts', 'United States', 'https://mcgonagleschool.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGonagle School of Irish Dance' and city = 'Wakefield'
);
-- McGonagle School of Irish Dance, Wakefield: Wakefield, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McHale School of Irish Dance', 'mchale-school-of-irish-dance-woburn', 'Woburn', 'Massachusetts', 'United States', null,
  '905 Main St', '01801', 42.508829, -71.160685, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McHale School of Irish Dance' and city = 'Woburn'
);
-- McHale School of Irish Dance, Woburn: 905 MAIN ST, WOBURN, MA, 01801

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McInerney School of Irish Dance', 'mcinerney-school-of-irish-dance-shrewsbury', 'Shrewsbury', 'Massachusetts', 'United States', 'https://www.mcinerneyirishdance.com/',
  '246 Boston Tpke Ste 4', null, 42.275227, -71.741867, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McInerney School of Irish Dance' and city = 'Shrewsbury'
);
-- McInerney School of Irish Dance, Shrewsbury: 246 BOSTON TPKE, SHREWSBURY, MA, 01545

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murphy Academy of Irish Dance', 'murphy-academy-of-irish-dance-south-grafton', 'South Grafton', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murphy Academy of Irish Dance' and city = 'South Grafton'
);
-- Murphy Academy of Irish Dance, South Grafton: South Grafton, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-melrose', 'Melrose', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'Melrose'
);
-- O'Shea-Chaplin Academy of Irish Dance, Melrose: Melrose, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-newton', 'Newton', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  '105 Rumford Ave', null, 42.358563, -71.242684, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'Newton'
);
-- O'Shea-Chaplin Academy of Irish Dance, Newton: 105 RUMFORD AVE, AUBURNDALE, MA, 02466

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-quincy', 'Quincy', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'Quincy'
);
-- O'Shea-Chaplin Academy of Irish Dance, Quincy: Quincy, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-reading', 'Reading', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'Reading'
);
-- O'Shea-Chaplin Academy of Irish Dance, Reading: Reading, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-watertown', 'Watertown', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'Watertown'
);
-- O'Shea-Chaplin Academy of Irish Dance, Watertown: Watertown, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Petrocelli Academy of Irish Dance', 'petrocelli-academy-of-irish-dance-pembroke', 'Pembroke', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Petrocelli Academy of Irish Dance' and city = 'Pembroke'
);
-- Petrocelli Academy of Irish Dance, Pembroke: Pembroke, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Bréifne Ó Ruairc', 'scoil-rince-breifne-o-ruairc-pittsfield', 'Pittsfield', 'Massachusetts', 'United States', 'https://irishdanceberks.com/',
  '395 North St', '01201', 42.454220, -73.252471, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Bréifne Ó Ruairc' and city = 'Pittsfield'
);
-- Scoil Rince Bréifne Ó Ruairc, Pittsfield: 395 NORTH ST, PITTSFIELD, MA, 01201

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sullivan School of Irish Dance', 'sullivan-school-of-irish-dance-newton', 'Newton', 'Massachusetts', 'United States', 'https://sullivanirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sullivan School of Irish Dance' and city = 'Newton'
);
-- Sullivan School of Irish Dance, Newton: Newton, MA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Stillson School of Irish Dance', 'stillson-school-of-irish-dance-portland', 'Portland', 'Maine', 'United States', 'https://www.stillsonirishdance.com/',
  '34 Gray St', '04112', 43.650239, -70.263073, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Stillson School of Irish Dance' and city = 'Portland'
);
-- Stillson School of Irish Dance, Portland: 34 GRAY ST, PORTLAND, ME, 04102

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Fíor Academy of Irish Dance', 'fior-academy-of-irish-dance-nashua', 'Nashua', 'New Hampshire', 'United States', 'https://fioracademy.com/',
  '116 Perimeter Rd', '03063', 42.779727, -71.518853, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Fíor Academy of Irish Dance' and city = 'Nashua'
);
-- Fíor Academy of Irish Dance, Nashua: 116 PERIMETER RD, NASHUA, NH, 03063

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McDonough-Grimes Irish Dance', 'mcdonough-grimes-irish-dance-dover', 'Dover', 'New Hampshire', 'United States', 'https://www.nhirishdance.com/',
  '97 New Rochester Rd', '03820', 43.228499, -70.895650, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McDonough-Grimes Irish Dance' and city = 'Dover'
);
-- McDonough-Grimes Irish Dance, Dover: 97 NEW ROCHESTER RD, DOVER, NH, 03820

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Academy of Irish Dance', 'murray-academy-of-irish-dance-exeter', 'Exeter', 'New Hampshire', 'United States', 'https://www.murrayacademy.com/',
  '10 Continental Dr, Building 2', null, 42.995117, -70.972437, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Murray Academy of Irish Dance' and city = 'Exeter'
);
-- Murray Academy of Irish Dance, Exeter: 10 CONTINENTAL DR, EXETER, NH, 03833

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Lir Academy', 'clann-lir-academy-middletown', 'Middletown', 'Rhode Island', 'United States', 'https://clannliracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Lir Academy' and city = 'Middletown'
);
-- Clann Lir Academy, Middletown: Middletown, RI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Lir Academy', 'clann-lir-academy-providence', 'Providence', 'Rhode Island', 'United States', 'https://clannliracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Lir Academy' and city = 'Providence'
);
-- Clann Lir Academy, Providence: Providence, RI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goulding School of Irish Dance', 'goulding-school-of-irish-dance-peace-dale', 'Peace Dale', 'Rhode Island', 'United States', 'https://gouldingschoolofirishdance.com/',
  '325 Columbia St', null, 41.448641, -71.495767, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Goulding School of Irish Dance' and city = 'Peace Dale'
);
-- Goulding School of Irish Dance, Peace Dale: 325 COLUMBIA ST, PEACE DALE, RI, 02879

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance', 'kelly-school-of-irish-dance-coventry', 'Coventry', 'Rhode Island', 'United States', 'https://www.thekellyschoolofirishdance.com/',
  '73 Sandy Bottom Rd', '02816', 41.687060, -71.560928, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance' and city = 'Coventry'
);
-- Kelly School of Irish Dance, Coventry: 73 SANDY BOTTOM RD, COVENTRY, RI, 02816

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance', 'kelly-school-of-irish-dance-cranston', 'Cranston', 'Rhode Island', 'United States', 'https://www.thekellyschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance' and city = 'Cranston'
);
-- Kelly School of Irish Dance, Cranston: Cranston, RI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance', 'kelly-school-of-irish-dance-bristol', 'Bristol', 'Rhode Island', 'United States', 'https://www.thekellyschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance' and city = 'Bristol'
);
-- Kelly School of Irish Dance, Bristol: Bristol, RI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Garrett School of Irish Dance', 'garrett-school-of-irish-dance-montpelier', 'Montpelier', 'Vermont', 'United States', 'https://sites.google.com/view/garrettschool',
  '115 Main St', null, 44.260896, -72.574542, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Garrett School of Irish Dance' and city = 'Montpelier'
);
-- Garrett School of Irish Dance, Montpelier: 115 MAIN ST, MONTPELIER, VT, 05602

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McFadden Academy of Irish Dance', 'mcfadden-academy-of-irish-dance-burlington', 'Burlington', 'Vermont', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McFadden Academy of Irish Dance' and city = 'Burlington'
);
-- McFadden Academy of Irish Dance, Burlington: Burlington, VT (city-only)
