-- School directory seed — Mid-Atlantic (NY, NJ, PA, DE, MD, DC, VA): 122 locations
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Every row below was verified 2026-11-12 from IDTANA Find a School / state
-- pages, Mid-Atlantic Region result PDFs, Planxti school pages, the FeisWorx
-- school list (name universe), and each school's own website / place listing.
-- No address was invented. Street address + ZIP are shown ONLY where the
-- school itself or a place listing tied to the school publishes them;
-- otherwise the row is city-only. See
-- research_notes/irish-dance-schools-all-us/mid-atlantic.md for sources and
-- the full "Unverified / partial" list — nothing from that section is seeded
-- here. West Virginia has no verified school (0 rows; IDTANA's WV page
-- returns zero results).
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
--
-- Counts: NY 41, NJ 16, PA 21, DE 8, MD 16, DC 3, VA 17 (122 total; the
-- research file lists 123 verified — 1 row was dropped as a duplicate of the
-- Ohio seed, see below). Street precision 47, city precision 75.
--
-- Completeness (from the research file): NY partial, best-covered state (41)
-- but smaller upstate schools unverified. NJ partial (16) — south Jersey not
-- found, may be a gap. PA partial (21) — central PA (Harrisburg / State
-- College / Scranton) not found, likely a gap. DE partial but small (8).
-- MD partial (16) — Eastern Shore only Salisbury; southern and western MD
-- thin. DC thin but plausibly near-complete (3). VA partial (17) — northern
-- VA and Hampton Roads covered; Richmond / Roanoke / Charlottesville /
-- western VA largely unverified. WV not covered (0).
--
-- website_url is NULL for 52 rows: 41 because the schools' sites are
-- http-only as published (An Clár, Francis Academy, Inishfree NY, O'Donnell
-- Academy, Rince Na Sonas, Rince Na Tiarna, Rochester Academy, Westfall
-- Boyle O'Rourke, Devrin Academy, Shea-Jennings, McHugh School,
-- McAleer-Paulson, Culkin School, Hunt School, O'Grady-Quinlan South, Teelin
-- School, Westfall Boyle Academy, District Irish Dance Academy DC, Rhythm of
-- Ireland, Shannon Dunne Dance, and others), 10 because no website was found
-- (Hagen Kavanagh, Aine Celtic Academy, O'Grady-Quinlan Easton/Bethlehem/
-- Allentown/Hatfield, Egan School Baltimore, Bracken School McLean, Maple
-- O'Callaghan DC, Tribe Irish Dance Academy), and 1 because the Acosta
-- School's site was unresolvable from this environment on 2026-11-12 (not
-- proven dead — re-check before linking). Every https URL kept here was
-- checked live on 2026-11-12 (HTTP 200).
--
-- Coordinates: US Census Geocoder (Public_AR_Current benchmark) for street
-- addresses. City-only rows have NO coordinates unless a verified ZIP was
-- available: the Census Geocoder cannot resolve a bare "City, ST" (tested —
-- it returns No_Match), and no Mid-Atlantic city-only row carries a verified
-- ZIP, so there was no Zippopotam.us fallback to use. Those rows keep
-- latitude/longitude/geo_precision/geo_source NULL rather than invented
-- coordinates; the schools remain listed and searchable by city.
-- Street addresses that failed to geocode and have no verified ZIP (kept as
-- published, no coordinates): DeNogla Academy of Irish Dance, Verona NJ
-- (546 Bloomfield Ave) and Woodcliff Lake NJ (21 Broadway); McDonald School
-- of Irish Dance, Onondaga NY, matched under Syracuse, NY (5108 Velasko Rd,
-- Syracuse 13215 — the research file itself says "Syracuse area"), and that
-- Census matched address is in the row comment.
-- Rose & Sword Academy, Williamsburg VA, carries its street address
-- (3715 Strawberry Plains Rd, 23188) from the WIDA list in
-- canada-open-platform.md — the WIDA entry for the same school was merged
-- here rather than seeded twice. The two files disagree on the website
-- scheme (Mid-Atlantic lists https://roseandswordacademy.com, WIDA lists it
-- http-only); the https URL is kept here because it returned HTTP 200 on a
-- live check on 2026-11-12.
-- Caveats carried from the research file: O'Grady-Quinlan satellites
-- (Bethlehem, Allentown, Hatfield) come from a 2014 article and may be
-- stale; Shovlin Academy Dormont's street address comes from a 2007 schedule
-- and may have changed; Bracken School McLean is city-only on a weak source
-- (FeisWorx name + dancewami); Morgan Legacy Academy's current trading name
-- vs McGrath Morgan is unconfirmed (both domains appear in the file).
--
-- Dropped as a duplicate of the Ohio seed (schools_ohio_seed.sql):
-- DeNogla Academy of Irish Dance, Little Falls NJ (Ohio seed has DeNogla
-- Academy, Little Falls). Nothing else in this file duplicates the Ohio seed.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists, so the file is safe to re-run. Status is 'unclaimed'
-- (default) — these listings have not been claimed by the schools.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Acosta School of Irish Music & Dance', 'acosta-school-of-irish-music-dance-belle-harbor', 'Belle Harbor', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Acosta School of Irish Music & Dance' and city = 'Belle Harbor'
);
-- Acosta School of Irish Music & Dance, Belle Harbor: Belle Harbor, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Clár School of Irish Dance', 'an-clar-school-of-irish-dance-albany', 'Albany', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Clár School of Irish Dance' and city = 'Albany'
);
-- An Clár School of Irish Dance, Albany: Albany, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ciara Greene School of Irish Dance', 'ciara-greene-school-of-irish-dance-bayside', 'Bayside', 'New York', 'United States', 'https://www.ciaragreeneschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ciara Greene School of Irish Dance' and city = 'Bayside'
);
-- Ciara Greene School of Irish Dance, Bayside: Bayside, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ciara Greene School of Irish Dance', 'ciara-greene-school-of-irish-dance-middle-village', 'Middle Village', 'New York', 'United States', 'https://www.ciaragreeneschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ciara Greene School of Irish Dance' and city = 'Middle Village'
);
-- Ciara Greene School of Irish Dance, Middle Village: Middle Village, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ciara Greene School of Irish Dance', 'ciara-greene-school-of-irish-dance-kings-park', 'Kings Park', 'New York', 'United States', 'https://www.ciaragreeneschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ciara Greene School of Irish Dance' and city = 'Kings Park'
);
-- Ciara Greene School of Irish Dance, Kings Park: Kings Park, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ciara Greene School of Irish Dance', 'ciara-greene-school-of-irish-dance-smithtown', 'Smithtown', 'New York', 'United States', 'https://www.ciaragreeneschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ciara Greene School of Irish Dance' and city = 'Smithtown'
);
-- Ciara Greene School of Irish Dance, Smithtown: Smithtown, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann na Cara / Harris-Grieco Academy of Irish Dance', 'clann-na-cara-harris-grieco-academy-of-irish-dance-kenmore', 'Kenmore', 'New York', 'United States', 'https://www.buffaloirishdance.com',
  '2958 Delaware Ave', null, 42.964680, -78.870349, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Clann na Cara / Harris-Grieco Academy of Irish Dance' and city = 'Kenmore'
);
-- Clann na Cara / Harris-Grieco Academy of Irish Dance, Kenmore: 2958 DELAWARE AVE, KENMORE, NY, 14217

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann na Cara / Harris-Grieco Academy of Irish Dance', 'clann-na-cara-harris-grieco-academy-of-irish-dance-williamsville', 'Williamsville', 'New York', 'United States', 'https://www.buffaloirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann na Cara / Harris-Grieco Academy of Irish Dance' and city = 'Williamsville'
);
-- Clann na Cara / Harris-Grieco Academy of Irish Dance, Williamsville: Williamsville, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann na Cara / Harris-Grieco Academy of Irish Dance', 'clann-na-cara-harris-grieco-academy-of-irish-dance-orchard-park', 'Orchard Park', 'New York', 'United States', 'https://www.buffaloirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann na Cara / Harris-Grieco Academy of Irish Dance' and city = 'Orchard Park'
);
-- Clann na Cara / Harris-Grieco Academy of Irish Dance, Orchard Park: Orchard Park, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Donny Golden School', 'donny-golden-school-brooklyn', 'Brooklyn', 'New York', 'United States', 'https://www.donnygoldenschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Donny Golden School' and city = 'Brooklyn'
);
-- Donny Golden School, Brooklyn: Brooklyn, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dunleavy Irish Dance', 'dunleavy-irish-dance-rochester', 'Rochester', 'New York', 'United States', 'https://www.dunleavyirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dunleavy Irish Dance' and city = 'Rochester'
);
-- Dunleavy Irish Dance, Rochester: Rochester, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dunleavy Irish Dance', 'dunleavy-irish-dance-pittsford', 'Pittsford', 'New York', 'United States', 'https://www.dunleavyirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dunleavy Irish Dance' and city = 'Pittsford'
);
-- Dunleavy Irish Dance, Pittsford: Pittsford, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dunleavy Irish Dance', 'dunleavy-irish-dance-mendon', 'Mendon', 'New York', 'United States', 'https://www.dunleavyirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dunleavy Irish Dance' and city = 'Mendon'
);
-- Dunleavy Irish Dance, Mendon: Mendon, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dunleavy Irish Dance', 'dunleavy-irish-dance-fairport', 'Fairport', 'New York', 'United States', 'https://www.dunleavyirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dunleavy Irish Dance' and city = 'Fairport'
);
-- Dunleavy Irish Dance, Fairport: Fairport, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Francis Academy of Irish Dance', 'francis-academy-of-irish-dance-syracuse', 'Syracuse', 'New York', 'United States', null,
  '433 Tompkins St #35', null, 43.047049, -76.184077, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Francis Academy of Irish Dance' and city = 'Syracuse'
);
-- Francis Academy of Irish Dance, Syracuse: 433 TOMPKINS ST, SYRACUSE, NY, 13204

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hagen Kavanagh School of Irish Dance', 'hagen-kavanagh-school-of-irish-dance-long-beach', 'Long Beach', 'New York', 'United States', null,
  '727B W Park Ave', '11561', 40.588419, -73.685086, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Hagen Kavanagh School of Irish Dance' and city = 'Long Beach'
);
-- Hagen Kavanagh School of Irish Dance, Long Beach: 727B W PARK AVE, LONG BEACH, NY, 11561

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dancing (NY)', 'inishfree-school-of-irish-dancing-ny-massapequa', 'Massapequa', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dancing (NY)' and city = 'Massapequa'
);
-- Inishfree School of Irish Dancing (NY), Massapequa: Massapequa, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dancing (NY)', 'inishfree-school-of-irish-dancing-ny-port-jefferson', 'Port Jefferson', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dancing (NY)' and city = 'Port Jefferson'
);
-- Inishfree School of Irish Dancing (NY), Port Jefferson: Port Jefferson, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dancing (NY)', 'inishfree-school-of-irish-dancing-ny-selden', 'Selden', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dancing (NY)' and city = 'Selden'
);
-- Inishfree School of Irish Dancing (NY), Selden: Selden, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dancing (NY)', 'inishfree-school-of-irish-dancing-ny-shoreham', 'Shoreham', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dancing (NY)' and city = 'Shoreham'
);
-- Inishfree School of Irish Dancing (NY), Shoreham: Shoreham, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dancing (NY)', 'inishfree-school-of-irish-dancing-ny-sayville', 'Sayville', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dancing (NY)' and city = 'Sayville'
);
-- Inishfree School of Irish Dancing (NY), Sayville: Sayville, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dancing (NY)', 'inishfree-school-of-irish-dancing-ny-bronx', 'Bronx', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dancing (NY)' and city = 'Bronx'
);
-- Inishfree School of Irish Dancing (NY), Bronx: Bronx, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inishfree School of Irish Dancing (NY)', 'inishfree-school-of-irish-dancing-ny-rockland-county', 'Rockland County', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inishfree School of Irish Dancing (NY)' and city = 'Rockland County'
);
-- Inishfree School of Irish Dancing (NY), Rockland County: Rockland County, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kender Academy of Irish Dance', 'kender-academy-of-irish-dance-farmingdale', 'Farmingdale', 'New York', 'United States', 'https://www.kenderacademy.com',
  '97 Hempstead Turnpike', '11735', 40.729962, -73.462138, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kender Academy of Irish Dance' and city = 'Farmingdale'
);
-- Kender Academy of Irish Dance, Farmingdale: 97 HEMPSTEAD TPKE, FARMINGDALE, NY, 11735

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McDonald School of Irish Dance', 'mcdonald-school-of-irish-dance-onondaga', 'Onondaga', 'New York', 'United States', 'https://cnyirishdance.com',
  '5108 Velasko Rd', null, 43.017862, -76.184529, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McDonald School of Irish Dance' and city = 'Onondaga'
);
-- McDonald School of Irish Dance, Onondaga: 5108 VELASKO RD, SYRACUSE, NY, 13215

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McDonald School of Irish Dance', 'mcdonald-school-of-irish-dance-marcellus', 'Marcellus', 'New York', 'United States', 'https://cnyirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McDonald School of Irish Dance' and city = 'Marcellus'
);
-- McDonald School of Irish Dance, Marcellus: Marcellus, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGough Academy', 'mcgough-academy-eastchester', 'Eastchester', 'New York', 'United States', 'https://www.mcgoughacademy.com',
  '281 White Plains Rd', '10709', 40.949008, -73.818323, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGough Academy' and city = 'Eastchester'
);
-- McGough Academy, Eastchester: 281 WHITE PLAINS RD, EASTCHESTER, NY, 10709

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McManus Irish Dance', 'mcmanus-irish-dance-long-island-city', 'Long Island City', 'New York', 'United States', 'https://www.mcmanusirishdance.com',
  '10-40 Jackson Ave', null, 40.742209, -73.953140, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McManus Irish Dance' and city = 'Long Island City'
);
-- McManus Irish Dance, Long Island City: 10-40 JACKSON AVE, LONG ISLAND CITY, NY, 11101

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Niall O''Leary School of Irish Dance', 'niall-oleary-school-of-irish-dance-new-york', 'New York', 'New York', 'United States', 'https://nialloleary.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Niall O''Leary School of Irish Dance' and city = 'New York'
);
-- Niall O'Leary School of Irish Dance, New York: New York, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Donnell Academy of Irish Dance', 'odonnell-academy-of-irish-dance-long-island-city', 'Long Island City', 'New York', 'United States', null,
  '25-25 Borden Ave', '11101', 40.739420, -73.944310, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Donnell Academy of Irish Dance' and city = 'Long Island City'
);
-- O'Donnell Academy of Irish Dance, Long Island City: 25-25 BORDEN AVE, LONG ISLAND CITY, NY, 11101

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Quigley Academy of Irish Dance', 'quigley-academy-of-irish-dance-cooperstown', 'Cooperstown', 'New York', 'United States', 'https://www.quigleyacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Quigley Academy of Irish Dance' and city = 'Cooperstown'
);
-- Quigley Academy of Irish Dance, Cooperstown: Cooperstown, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Na Sonas School of Irish Dance', 'rince-na-sonas-school-of-irish-dance-liverpool', 'Liverpool', 'New York', 'United States', null,
  '604 Old Liverpool Rd', '13090', 43.089831, -76.190077, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rince Na Sonas School of Irish Dance' and city = 'Liverpool'
);
-- Rince Na Sonas School of Irish Dance, Liverpool: 604 OLD LIVERPOOL RD, LIVERPOOL, NY, 13088

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Na Tiarna School of Irish Dance', 'rince-na-tiarna-school-of-irish-dance-south-buffalo', 'South Buffalo', 'New York', 'United States', null,
  '245 Abbott Rd', null, 42.854534, -78.820969, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rince Na Tiarna School of Irish Dance' and city = 'South Buffalo'
);
-- Rince Na Tiarna School of Irish Dance, South Buffalo: 245 ABBOTT RD, BUFFALO, NY, 14220

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Na Tiarna School of Irish Dance', 'rince-na-tiarna-school-of-irish-dance-williamsville', 'Williamsville', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Na Tiarna School of Irish Dance' and city = 'Williamsville'
);
-- Rince Na Tiarna School of Irish Dance, Williamsville: Williamsville, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Na Tiarna School of Irish Dance', 'rince-na-tiarna-school-of-irish-dance-hamburg', 'Hamburg', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Na Tiarna School of Irish Dance' and city = 'Hamburg'
);
-- Rince Na Tiarna School of Irish Dance, Hamburg: Hamburg, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Na Tiarna School of Irish Dance', 'rince-na-tiarna-school-of-irish-dance-east-aurora', 'East Aurora', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Na Tiarna School of Irish Dance' and city = 'East Aurora'
);
-- Rince Na Tiarna School of Irish Dance, East Aurora: East Aurora, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Na Tiarna School of Irish Dance', 'rince-na-tiarna-school-of-irish-dance-gates', 'Gates', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Na Tiarna School of Irish Dance' and city = 'Gates'
);
-- Rince Na Tiarna School of Irish Dance, Gates: Gates, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rochester Academy of Irish Dance', 'rochester-academy-of-irish-dance-rochester', 'Rochester', 'New York', 'United States', null,
  '1598 Penfield Rd', null, 43.134885, -77.495684, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rochester Academy of Irish Dance' and city = 'Rochester'
);
-- Rochester Academy of Irish Dance, Rochester: 1598 PENFIELD RD, ROCHESTER, NY, 14625

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Westfall Boyle O''Rourke Irish Dance Academy', 'westfall-boyle-orourke-irish-dance-academy-white-plains', 'White Plains', 'New York', 'United States', null,
  '611 W Hartsdale Ave', '10607', 41.038034, -73.810597, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Westfall Boyle O''Rourke Irish Dance Academy' and city = 'White Plains'
);
-- Westfall Boyle O'Rourke Irish Dance Academy, White Plains: 611 W HARTSDALE RD, WHITE PLAINS, NY, 10607

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Westfall Boyle O''Rourke Irish Dance Academy', 'westfall-boyle-orourke-irish-dance-academy-new-rochelle', 'New Rochelle', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Westfall Boyle O''Rourke Irish Dance Academy' and city = 'New Rochelle'
);
-- Westfall Boyle O'Rourke Irish Dance Academy, New Rochelle: New Rochelle, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeNogla Academy of Irish Dance', 'denogla-academy-of-irish-dance-yonkers', 'Yonkers', 'New York', 'United States', 'https://www.denogla-academy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'DeNogla Academy of Irish Dance' and city = 'Yonkers'
);
-- DeNogla Academy of Irish Dance, Yonkers: Yonkers, NY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Clár School of Irish Dance', 'an-clar-school-of-irish-dance-stanhope', 'Stanhope', 'New Jersey', 'United States', null,
  '17 US 206', '07874', 40.923313, -74.718670, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'An Clár School of Irish Dance' and city = 'Stanhope'
);
-- An Clár School of Irish Dance, Stanhope: 17 US HWY 206, STANHOPE, NJ, 07874

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'D''Arcy School of Irish Dance', 'darcy-school-of-irish-dance-wall-township', 'Wall Township', 'New Jersey', 'United States', 'https://darcyirishdanceclassesnj.com',
  '2400 Belmar Blvd', null, 40.175941, -74.060685, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'D''Arcy School of Irish Dance' and city = 'Wall Township'
);
-- D'Arcy School of Irish Dance, Wall Township: 2400 BELMAR BLVD, WALL TOWNSHIP, NJ, 07719

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'D''Arcy School of Irish Dance', 'darcy-school-of-irish-dance-brick', 'Brick', 'New Jersey', 'United States', 'https://darcyirishdanceclassesnj.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'D''Arcy School of Irish Dance' and city = 'Brick'
);
-- D'Arcy School of Irish Dance, Brick: Brick, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'D''Arcy School of Irish Dance', 'darcy-school-of-irish-dance-fair-haven', 'Fair Haven', 'New Jersey', 'United States', 'https://darcyirishdanceclassesnj.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'D''Arcy School of Irish Dance' and city = 'Fair Haven'
);
-- D'Arcy School of Irish Dance, Fair Haven: Fair Haven, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeNogla Academy of Irish Dance', 'denogla-academy-of-irish-dance-verona', 'Verona', 'New Jersey', 'United States', 'https://www.denogla-academy.com',
  '546 Bloomfield Ave', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'DeNogla Academy of Irish Dance' and city = 'Verona'
);
-- DeNogla Academy of Irish Dance, Verona: 546 Bloomfield Ave, Verona, NJ (street address did not match Census (batch + single-lookup variants); no verified ZIP, so no coordinates — kept as published)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeNogla Academy of Irish Dance', 'denogla-academy-of-irish-dance-woodcliff-lake', 'Woodcliff Lake', 'New Jersey', 'United States', 'https://www.denogla-academy.com',
  '21 Broadway', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'DeNogla Academy of Irish Dance' and city = 'Woodcliff Lake'
);
-- DeNogla Academy of Irish Dance, Woodcliff Lake: 21 Broadway, Woodcliff Lake, NJ (street address did not match Census (batch + single-lookup variants); no verified ZIP, so no coordinates — kept as published)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Devrin Academy of Irish Dance', 'devrin-academy-of-irish-dance-point-pleasant', 'Point Pleasant', 'New Jersey', 'United States', null,
  '632 Ocean Rd', null, 40.081303, -74.051649, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Devrin Academy of Irish Dance' and city = 'Point Pleasant'
);
-- Devrin Academy of Irish Dance, Point Pleasant: 632 OCEAN RD, PT PLEASANT, NJ, 08742

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Devrin Academy of Irish Dance', 'devrin-academy-of-irish-dance-brielle', 'Brielle', 'New Jersey', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Devrin Academy of Irish Dance' and city = 'Brielle'
);
-- Devrin Academy of Irish Dance, Brielle: Brielle, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Devrin Academy of Irish Dance', 'devrin-academy-of-irish-dance-island-heights', 'Island Heights', 'New Jersey', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Devrin Academy of Irish Dance' and city = 'Island Heights'
);
-- Devrin Academy of Irish Dance, Island Heights: Island Heights, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Heritage Irish Dance Company', 'heritage-irish-dance-company-green-brook', 'Green Brook', 'New Jersey', 'United States', 'https://www.heritageirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Heritage Irish Dance Company' and city = 'Green Brook'
);
-- Heritage Irish Dance Company, Green Brook: Green Brook, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Heritage Irish Dance Company', 'heritage-irish-dance-company-clinton', 'Clinton', 'New Jersey', 'United States', 'https://www.heritageirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Heritage Irish Dance Company' and city = 'Clinton'
);
-- Heritage Irish Dance Company, Clinton: Clinton, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Heritage Irish Dance Company', 'heritage-irish-dance-company-summit', 'Summit', 'New Jersey', 'United States', 'https://www.heritageirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Heritage Irish Dance Company' and city = 'Summit'
);
-- Heritage Irish Dance Company, Summit: Summit, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Heritage Irish Dance Company', 'heritage-irish-dance-company-woodbridge', 'Woodbridge', 'New Jersey', 'United States', 'https://www.heritageirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Heritage Irish Dance Company' and city = 'Woodbridge'
);
-- Heritage Irish Dance Company, Woodbridge: Woodbridge, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Lenahan School of Irish Dance', 'lenahan-school-of-irish-dance-sparta', 'Sparta', 'New Jersey', 'United States', 'https://www.lenahanschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Lenahan School of Irish Dance' and city = 'Sparta'
);
-- Lenahan School of Irish Dance, Sparta: Sparta, NJ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Lynn Academy of Irish Dance', 'lynn-academy-of-irish-dance-hillsborough', 'Hillsborough', 'New Jersey', 'United States', 'https://www.lynnacademy.com',
  '3 Jill Ct, Building 15, Unit 16', '08844', 40.492888, -74.641497, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Lynn Academy of Irish Dance' and city = 'Hillsborough'
);
-- Lynn Academy of Irish Dance, Hillsborough: 3 JILL CT, HILLSBOROUGH, NJ, 08844

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shea-Jennings School of Irish Dance', 'shea-jennings-school-of-irish-dance-garwood', 'Garwood', 'New Jersey', 'United States', null,
  '102 North Ave', '07027', 40.654258, -74.318178, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Shea-Jennings School of Irish Dance' and city = 'Garwood'
);
-- Shea-Jennings School of Irish Dance, Garwood: 102 NORTH AVE, GARWOOD, NJ, 07027

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Aine Celtic Academy of Irish Dance', 'aine-celtic-academy-of-irish-dance-erie', 'Erie', 'Pennsylvania', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Aine Celtic Academy of Irish Dance' and city = 'Erie'
);
-- Aine Celtic Academy of Irish Dance, Erie: Erie, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Aisling Mor Academy of Irish Dance', 'aisling-mor-academy-of-irish-dance-hatfield', 'Hatfield', 'Pennsylvania', 'United States', 'https://www.aislingmoracademy.com',
  '2501 Bethlehem Pike', null, 40.298705, -75.284466, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Aisling Mor Academy of Irish Dance' and city = 'Hatfield'
);
-- Aisling Mor Academy of Irish Dance, Hatfield: 2501 BETHLEHEM PIKE, HATFIELD, PA, 19440

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bell School of Irish Dance', 'bell-school-of-irish-dance-pittsburgh', 'Pittsburgh', 'Pennsylvania', 'United States', 'https://www.bellschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bell School of Irish Dance' and city = 'Pittsburgh'
);
-- Bell School of Irish Dance, Pittsburgh: Pittsburgh, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Burke-Connolly Academy of Irish Dance', 'burke-connolly-academy-of-irish-dance-pittsburgh', 'Pittsburgh', 'Pennsylvania', 'United States', 'https://www.burkeconnolly.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Burke-Connolly Academy of Irish Dance' and city = 'Pittsburgh'
);
-- Burke-Connolly Academy of Irish Dance, Pittsburgh: Pittsburgh, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeNogla Academy of Irish Dance', 'denogla-academy-of-irish-dance-stroudsburg', 'Stroudsburg', 'Pennsylvania', 'United States', 'https://www.denogla-academy.com',
  '11 Foundry St #104', null, 40.981188, -75.204864, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'DeNogla Academy of Irish Dance' and city = 'Stroudsburg'
);
-- DeNogla Academy of Irish Dance, Stroudsburg: 11 FOUNDRY ST, STROUDSBURG, PA, 18360

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hooley School of Irish Dance', 'hooley-school-of-irish-dance-brownstown', 'Brownstown', 'Pennsylvania', 'United States', 'https://www.hooleyirishdance.com',
  '1 S State St', null, 40.125352, -76.214208, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Hooley School of Irish Dance' and city = 'Brownstown'
);
-- Hooley School of Irish Dance, Brownstown: 1 N STATE ST, BROWNSTOWN, PA, 17508

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hooley School of Irish Dance', 'hooley-school-of-irish-dance-west-reading', 'West Reading', 'Pennsylvania', 'United States', 'https://www.hooleyirishdance.com',
  '511 Reading Ave', null, 40.336848, -75.948467, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Hooley School of Irish Dance' and city = 'West Reading'
);
-- Hooley School of Irish Dance, West Reading: 511 READING AVE, WEST READING, PA, 19611

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGough Academy', 'mcgough-academy-glen-mills', 'Glen Mills', 'Pennsylvania', 'United States', 'https://www.mcgoughacademy.com',
  '364 Wilmington Pike', null, 39.857055, -75.542232, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGough Academy' and city = 'Glen Mills'
);
-- McGough Academy, Glen Mills: 364 WILMINGTON W CHESTER PIKE, GLEN MILLS, PA, 19342

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGough Academy', 'mcgough-academy-king-of-prussia', 'King of Prussia', 'Pennsylvania', 'United States', 'https://www.mcgoughacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGough Academy' and city = 'King of Prussia'
);
-- McGough Academy, King of Prussia: King of Prussia, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGough Academy', 'mcgough-academy-west-chester', 'West Chester', 'Pennsylvania', 'United States', 'https://www.mcgoughacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGough Academy' and city = 'West Chester'
);
-- McGough Academy, West Chester: West Chester, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McHugh School of Irish Dance', 'mchugh-school-of-irish-dance-aston', 'Aston', 'Pennsylvania', 'United States', null,
  '6 Crozerville Rd', null, 39.877035, -75.463913, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McHugh School of Irish Dance' and city = 'Aston'
);
-- McHugh School of Irish Dance, Aston: 6 CROZERVILLE RD, ASTON, PA, 19014

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Niall O''Leary School of Irish Dance', 'niall-oleary-school-of-irish-dance-philadelphia', 'Philadelphia', 'Pennsylvania', 'United States', 'https://nialloleary.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Niall O''Leary School of Irish Dance' and city = 'Philadelphia'
);
-- Niall O'Leary School of Irish Dance, Philadelphia: Philadelphia, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Grady-Quinlan Academy of Irish Dance', 'ogrady-quinlan-academy-of-irish-dance-easton', 'Easton', 'Pennsylvania', 'United States', null,
  '228 W Canal St', null, 40.683984, -75.211982, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Grady-Quinlan Academy of Irish Dance' and city = 'Easton'
);
-- O'Grady-Quinlan Academy of Irish Dance, Easton: 228 W CANAL ST, EASTON, PA, 18042

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Grady-Quinlan Academy of Irish Dance', 'ogrady-quinlan-academy-of-irish-dance-bethlehem', 'Bethlehem', 'Pennsylvania', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Grady-Quinlan Academy of Irish Dance' and city = 'Bethlehem'
);
-- O'Grady-Quinlan Academy of Irish Dance, Bethlehem: Bethlehem, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Grady-Quinlan Academy of Irish Dance', 'ogrady-quinlan-academy-of-irish-dance-allentown', 'Allentown', 'Pennsylvania', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Grady-Quinlan Academy of Irish Dance' and city = 'Allentown'
);
-- O'Grady-Quinlan Academy of Irish Dance, Allentown: Allentown, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Grady-Quinlan Academy of Irish Dance', 'ogrady-quinlan-academy-of-irish-dance-hatfield', 'Hatfield', 'Pennsylvania', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Grady-Quinlan Academy of Irish Dance' and city = 'Hatfield'
);
-- O'Grady-Quinlan Academy of Irish Dance, Hatfield: Hatfield, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Na Tiarna School of Irish Dance', 'rince-na-tiarna-school-of-irish-dance-erie', 'Erie', 'Pennsylvania', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Na Tiarna School of Irish Dance' and city = 'Erie'
);
-- Rince Na Tiarna School of Irish Dance, Erie: Erie, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shovlin Academy of Irish Dance', 'shovlin-academy-of-irish-dance-pittsburgh', 'Pittsburgh', 'Pennsylvania', 'United States', 'https://shovlinacademy.com',
  '1444 Hillsdale Ave', '15216', 40.394098, -80.037308, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Shovlin Academy of Irish Dance' and city = 'Pittsburgh'
);
-- Shovlin Academy of Irish Dance, Pittsburgh: 1444 HILLSDALE AVE, PITTSBURGH, PA, 15216

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shovlin Academy of Irish Dance', 'shovlin-academy-of-irish-dance-johnstown', 'Johnstown', 'Pennsylvania', 'United States', 'https://shovlinacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Shovlin Academy of Irish Dance' and city = 'Johnstown'
);
-- Shovlin Academy of Irish Dance, Johnstown: Johnstown, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tribe Irish Dance Academy', 'tribe-irish-dance-academy-lehigh-valley', 'Lehigh Valley', 'Pennsylvania', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Tribe Irish Dance Academy' and city = 'Lehigh Valley'
);
-- Tribe Irish Dance Academy, Lehigh Valley: Lehigh Valley, PA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Traditional Irish Dance Academy', 'traditional-irish-dance-academy-pittsburgh', 'Pittsburgh', 'Pennsylvania', 'United States', 'https://tradirishdance.com',
  '300 Camp Horne Rd', null, 40.517408, -80.093461, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Traditional Irish Dance Academy' and city = 'Pittsburgh'
);
-- Traditional Irish Dance Academy, Pittsburgh: 300 CAMP HORNE RD, PITTSBURGH, PA, 15202

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hester Academy of Irish Dance', 'hester-academy-of-irish-dance-wyoming', 'Wyoming', 'Delaware', 'United States', 'https://www.hesteracademy.com',
  '200 Southern Blvd', null, 39.115952, -75.561827, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Hester Academy of Irish Dance' and city = 'Wyoming'
);
-- Hester Academy of Irish Dance, Wyoming: 200 SOUTHERN BLVD, WYOMING, DE, 19934

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McAleer-Paulson School of Irish Dance', 'mcaleer-paulson-school-of-irish-dance-wilmington', 'Wilmington', 'Delaware', 'United States', null,
  '838 N Market St', null, 39.743877, -75.548862, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McAleer-Paulson School of Irish Dance' and city = 'Wilmington'
);
-- McAleer-Paulson School of Irish Dance, Wilmington: 838 N MARKET ST, WILMINGTON, DE, 19801

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McAleer-Paulson School of Irish Dance', 'mcaleer-paulson-school-of-irish-dance-claymont', 'Claymont', 'Delaware', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McAleer-Paulson School of Irish Dance' and city = 'Claymont'
);
-- McAleer-Paulson School of Irish Dance, Claymont: Claymont, DE (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McAleer-Paulson School of Irish Dance', 'mcaleer-paulson-school-of-irish-dance-lewes', 'Lewes', 'Delaware', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McAleer-Paulson School of Irish Dance' and city = 'Lewes'
);
-- McAleer-Paulson School of Irish Dance, Lewes: Lewes, DE (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McAleer-Paulson School of Irish Dance', 'mcaleer-paulson-school-of-irish-dance-newark', 'Newark', 'Delaware', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McAleer-Paulson School of Irish Dance' and city = 'Newark'
);
-- McAleer-Paulson School of Irish Dance, Newark: Newark, DE (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGough Academy', 'mcgough-academy-lewes', 'Lewes', 'Delaware', 'United States', 'https://www.mcgoughacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGough Academy' and city = 'Lewes'
);
-- McGough Academy, Lewes: Lewes, DE (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGough Academy', 'mcgough-academy-rehoboth-beach', 'Rehoboth Beach', 'Delaware', 'United States', 'https://www.mcgoughacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGough Academy' and city = 'Rehoboth Beach'
);
-- McGough Academy, Rehoboth Beach: Rehoboth Beach, DE (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McHugh School of Irish Dance', 'mchugh-school-of-irish-dance-wilmington', 'Wilmington', 'Delaware', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McHugh School of Irish Dance' and city = 'Wilmington'
);
-- McHugh School of Irish Dance, Wilmington: Wilmington, DE (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Culkin School of Traditional Irish Dance', 'culkin-school-of-traditional-irish-dance-rockville', 'Rockville', 'Maryland', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Culkin School of Traditional Irish Dance' and city = 'Rockville'
);
-- Culkin School of Traditional Irish Dance, Rockville: Rockville, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Culkin School of Traditional Irish Dance', 'culkin-school-of-traditional-irish-dance-glen-echo', 'Glen Echo', 'Maryland', 'United States', null,
  '7300 MacArthur Blvd', null, 38.969763, -77.141549, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Culkin School of Traditional Irish Dance' and city = 'Glen Echo'
);
-- Culkin School of Traditional Irish Dance, Glen Echo: 7300 MACARTHUR BLVD, GLEN ECHO, MD, 20812

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Egan School of Irish Dance', 'egan-school-of-irish-dance-baltimore', 'Baltimore', 'Maryland', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Egan School of Irish Dance' and city = 'Baltimore'
);
-- Egan School of Irish Dance, Baltimore: Baltimore, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hunt School of Irish Dance', 'hunt-school-of-irish-dance-crofton', 'Crofton', 'Maryland', 'United States', null,
  '2431 Crofton Ln, Suite 11', '21114', 39.014904, -76.698406, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Hunt School of Irish Dance' and city = 'Crofton'
);
-- Hunt School of Irish Dance, Crofton: 2431 CROFTON LN, CROFTON, MD, 21114

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-damascus', 'Damascus', 'Maryland', 'United States', 'https://mcgrathirishdance.com',
  '9719 Beall Ave', null, 39.292113, -77.201643, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Damascus'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Damascus: 9719 BEALL AVE, DAMASCUS, MD, 20872

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-bethesda', 'Bethesda', 'Maryland', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Bethesda'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Bethesda: Bethesda, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-frederick', 'Frederick', 'Maryland', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Frederick'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Frederick: Frederick, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-millersville', 'Millersville', 'Maryland', 'United States', 'https://legacyirishdance.com',
  '1035 Benfield Blvd', null, 39.094482, -76.630192, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Millersville'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Millersville: 1035 BENFIELD BLVD, MILLERSVILLE, MD, 21108

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-rockville', 'Rockville', 'Maryland', 'United States', 'https://legacyirishdance.com',
  '5050 Nicholson Ln, Suite D', null, 39.046183, -77.103752, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Rockville'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Rockville: 5050 NICHOLSON LN, ROCKVILLE, MD, 20852

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McHale School of Irish Dance', 'mchale-school-of-irish-dance-lutherville', 'Lutherville', 'Maryland', 'United States', 'https://www.mchaleirishdance.net',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McHale School of Irish Dance' and city = 'Lutherville'
);
-- McHale School of Irish Dance, Lutherville: Lutherville, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGough Academy', 'mcgough-academy-bethesda', 'Bethesda', 'Maryland', 'United States', 'https://www.mcgoughacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGough Academy' and city = 'Bethesda'
);
-- McGough Academy, Bethesda: Bethesda, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Grady-Quinlan Academy of Irish Dance (South)', 'ogrady-quinlan-academy-of-irish-dance-south-owings', 'Owings', 'Maryland', 'United States', null,
  '7653 Binnacle Ln', null, 38.686258, -76.610708, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Grady-Quinlan Academy of Irish Dance (South)' and city = 'Owings'
);
-- O'Grady-Quinlan Academy of Irish Dance (South), Owings: 7653 BINNACLE LN, OWINGS, MD, 20736

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Teelin School of Irish Dance', 'teelin-school-of-irish-dance-columbia', 'Columbia', 'Maryland', 'United States', null,
  '9221 Rumsey Rd', '21045', 39.234781, -76.822954, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Teelin School of Irish Dance' and city = 'Columbia'
);
-- Teelin School of Irish Dance, Columbia: 9221 RUMSEY RD, COLUMBIA, MD, 21045

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Westfall Boyle Academy of Irish Dance', 'westfall-boyle-academy-of-irish-dance-salisbury', 'Salisbury', 'Maryland', 'United States', null,
  '799 N Salisbury Blvd #1400', null, 38.372577, -75.593423, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Westfall Boyle Academy of Irish Dance' and city = 'Salisbury'
);
-- Westfall Boyle Academy of Irish Dance, Salisbury: 799 N SALISBURY BLVD, SALISBURY, MD, 21801

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Westfall Boyle Academy of Irish Dance', 'westfall-boyle-academy-of-irish-dance-rockville', 'Rockville', 'Maryland', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Westfall Boyle Academy of Irish Dance' and city = 'Rockville'
);
-- Westfall Boyle Academy of Irish Dance, Rockville: Rockville, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'District Irish Dance Academy', 'district-irish-dance-academy-rockville', 'Rockville', 'Maryland', 'United States', 'https://www.districtirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'District Irish Dance Academy' and city = 'Rockville'
);
-- District Irish Dance Academy, Rockville: Rockville, MD (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'District Irish Dance Academy', 'district-irish-dance-academy-washington', 'Washington', 'District of Columbia', 'United States', null,
  '4435 Wisconsin Ave NW, LL10', null, 38.947405, -77.079309, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'District Irish Dance Academy' and city = 'Washington'
);
-- District Irish Dance Academy, Washington: 4435 WISCONSIN AVE NW, WASHINGTON, DC, 20016

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maple O''Callaghan Academy of Irish Dance', 'maple-ocallaghan-academy-of-irish-dance-washington', 'Washington', 'District of Columbia', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maple O''Callaghan Academy of Irish Dance' and city = 'Washington'
);
-- Maple O'Callaghan Academy of Irish Dance, Washington: Washington, DC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shannon Dunne Dance', 'shannon-dunne-dance-washington', 'Washington', 'District of Columbia', 'United States', null,
  '316 F St NE', null, 38.897392, -77.001749, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Shannon Dunne Dance' and city = 'Washington'
);
-- Shannon Dunne Dance, Washington: 316 F ST NE, WASHINGTON, DC, 20002

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Boyle School of Irish Dance', 'boyle-school-of-irish-dance-manassas', 'Manassas', 'Virginia', 'United States', 'https://www.boyleschool.com',
  '13767 Coronado Ct', '20112', 38.655072, -77.415106, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Boyle School of Irish Dance' and city = 'Manassas'
);
-- Boyle School of Irish Dance, Manassas: 13767 CORONADO CT, MANASSAS, VA, 20112

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Boyle School of Irish Dance', 'boyle-school-of-irish-dance-alexandria', 'Alexandria', 'Virginia', 'United States', 'https://www.boyleschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Boyle School of Irish Dance' and city = 'Alexandria'
);
-- Boyle School of Irish Dance, Alexandria: Alexandria, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Boyle School of Irish Dance', 'boyle-school-of-irish-dance-chantilly', 'Chantilly', 'Virginia', 'United States', 'https://www.boyleschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Boyle School of Irish Dance' and city = 'Chantilly'
);
-- Boyle School of Irish Dance, Chantilly: Chantilly, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Boyle School of Irish Dance', 'boyle-school-of-irish-dance-herndon', 'Herndon', 'Virginia', 'United States', 'https://www.boyleschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Boyle School of Irish Dance' and city = 'Herndon'
);
-- Boyle School of Irish Dance, Herndon: Herndon, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Boyle School of Irish Dance', 'boyle-school-of-irish-dance-reston', 'Reston', 'Virginia', 'United States', 'https://www.boyleschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Boyle School of Irish Dance' and city = 'Reston'
);
-- Boyle School of Irish Dance, Reston: Reston, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bracken School', 'bracken-school-mclean', 'McLean', 'Virginia', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bracken School' and city = 'McLean'
);
-- Bracken School, McLean: McLean, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Foley Academy of Irish Dance', 'foley-academy-of-irish-dance-reston', 'Reston', 'Virginia', 'United States', 'https://foleyirishdance.com',
  '11260 Roger Bacon Dr', '20190', 38.951533, -77.334790, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Foley Academy of Irish Dance' and city = 'Reston'
);
-- Foley Academy of Irish Dance, Reston: 11260 ROGER BACON DR, RESTON, VA, 20190

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-falls-church', 'Falls Church', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  '900 S Washington St #B101', null, 38.879130, -77.182571, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Falls Church'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Falls Church: 900 S WASHINGTON ST, FALLS CHURCH, VA, 22046

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-fairfax-station', 'Fairfax Station', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Fairfax Station'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Fairfax Station: Fairfax Station, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-manassas', 'Manassas', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Manassas'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Manassas: Manassas, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-lorton', 'Lorton', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Lorton'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Lorton: Lorton, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-purcellville', 'Purcellville', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Purcellville'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Purcellville: Purcellville, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-berryville', 'Berryville', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Berryville'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Berryville: Berryville, VA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Neill-James School of Irish Dancing', 'oneill-james-school-of-irish-dancing-arlington', 'Arlington', 'Virginia', 'United States', 'https://www.oneilljamesschool.com',
  '6406 16th St N', '22205', 38.881609, -77.154687, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Neill-James School of Irish Dancing' and city = 'Arlington'
);
-- O'Neill-James School of Irish Dancing, Arlington: 6406 16TH ST N, ARLINGTON, VA, 22205

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Neill-James School of Irish Dancing', 'oneill-james-school-of-irish-dancing-falls-church', 'Falls Church', 'Virginia', 'United States', 'https://www.oneilljamesschool.com',
  '115 E Fairfax St', null, 38.880515, -77.170880, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Neill-James School of Irish Dancing' and city = 'Falls Church'
);
-- O'Neill-James School of Irish Dancing, Falls Church: 115 E FAIRFAX ST, FALLS CHURCH, VA, 22046

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rhythm of Ireland School of Irish Dance', 'rhythm-of-ireland-school-of-irish-dance-virginia-beach', 'Virginia Beach', 'Virginia', 'United States', null,
  '629 N Lynnhaven Rd', '23452', 36.853867, -76.087572, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rhythm of Ireland School of Irish Dance' and city = 'Virginia Beach'
);
-- Rhythm of Ireland School of Irish Dance, Virginia Beach: 629 N LYNNHAVEN RD, VIRGINIA BEACH, VA, 23452

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rose & Sword Academy of Irish Dance', 'rose-sword-academy-of-irish-dance-williamsburg', 'Williamsburg', 'Virginia', 'United States', 'https://roseandswordacademy.com',
  '3715 Strawberry Plains Rd', '23188', 37.265681, -76.741140, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rose & Sword Academy of Irish Dance' and city = 'Williamsburg'
);
-- Rose & Sword Academy of Irish Dance, Williamsburg: 3715 STRAWBERRY PLAINS RD, WILLIAMSBURG, VA, 23188
