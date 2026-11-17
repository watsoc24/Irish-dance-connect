-- School directory seed — IDTANA audit supplemental locations (219 locations)
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Reconciled 2026-11-12 from the seven regional IDTANA audit reports in
-- ~/workspace/research_notes/irish-dance-schools-idtana-audit/ (New England,
-- Mid-Atlantic, Southern, Mid-America, Western US, Western Canada,
-- Eastern Canada). Deduplicated by name + state/province + city across
-- reports; cross-report overlaps resolved per report (PA schools,
-- VA/WV schools, Doherty Petri, Morgan Legacy, Kristin Butke merged
-- May 2026 into Clann Ríoga — seeded under the CLANN RÍOGA name, not
-- Butke; Rince Na Tiarna NY belongs to Mid-Atlantic, not Eastern Canada;
-- Murphy Irish Dancers, CA belongs to Western US, not Mid-America).
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
-- 219 new rows on top of the 591 seeded rows (projected total 810):
-- 188 United States, 22 Canada, 9 Mexico
-- (first Mexico rows in the directory). 103 rows carry a verified street
-- address; 116 are city-only (no street address published anywhere
-- checked). 92 rows have coordinates.
--
-- postal_code is US 5-digit ZIP only: it is set ONLY where a report verified
-- the ZIP. Canadian/Mexican postals are recorded in the trailing comment of
-- the row they belong to, never in the column (schema constraint).
--
-- website_url is NULL where the school has no website, a Facebook/Instagram-
-- only presence, or an http-only / dead / unreachable site (schema requires
-- https://). Every https URL below was checked live over https on 2026-11-12
-- by the regional auditors and returned HTTP 200, except where the row
-- comment says otherwise.
--
-- Coordinates: US Census Geocoder (Public_AR_Current benchmark) for US street
-- addresses; Nominatim (OpenStreetMap) for Canadian street addresses, at
-- max 1 req/sec. Where neither geocoder could match a verified street
-- address, latitude/longitude/geo_precision/geo_source are all NULL and the
-- street text is kept (see the ungeocoded list at the foot of this header).
-- No coordinates were invented.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists, so the file is safe to re-run. Status is 'unclaimed'
-- (default) — these listings have not been claimed by the schools.
-- EXCEPTION: the two Royal Academy of Irish Dance, Charlotte NC rows
-- (Bellhaven Blvd and Monroe Rd) guard on slug instead of name+city,
-- because two locations of one school in one city would otherwise let the
-- first insert block the second. They are still idempotent on re-run.
-- (The directory already contains one pre-existing same-name+city set:
-- Blakey O'Brien Irish Dance, Calgary has three seeded rows for three
-- neighbourhood studios — that predates this file and is untouched here.)
--
-- DO NOT SEED (reports say closed / merged / unverifiable) — none of these
-- appear as rows below:
--   Closed: Smyth School, Richfield OH (likely closed); Fahey School,
--     Midlothian VA (closed Aug 1, 2024); McElligott School, Stroudsburg PA
--     (permanently closed); Donna Means School, Escondido CA (permanently
--     closed); Gartland School, Danbury CT (defunct 2019-2023); Millennium
--     School, Monroe/Georgetown CT (defunct); Sheeaun Academy, CT (defunct,
--     merged into Ashurst); Bracken School MA branch (gone; school now AZ
--     only); Nevin Academy, Hingham MA (retired, transitioned to Clann Lir).
--   Merged/absorbed: O'Shaughnessy Academy (merged into West Coast Academy
--     2026); Power Academy (absorbed into McNulty LA); Sutherland School
--     (merged into Jackie Flynn, Apr 2022); River City School, Saskatoon SK
--     (merged into seeded SASK Irish Dance — its address is folded into that
--     row in the updates file instead); Goggin-Carroll (= seeded
--     Goggin-Stewart, ON); McElhatton School, Edmonton AB (unverified —
--     no website/social, no 2025-26 activity found).
--   Unverifiable / not confirmed currently operating: Connolly Academy,
--     Hanover MA (site dead, listing says Permanently Closed); Scoil Rince
--     Naomh Attracta, Boston MA (no evidence since ~2013); Proto-Casano
--     School, MA (last trace 2021); Crossroads Irish Dancers, Langhorne PA;
--     Gallagher School, Scranton PA; Jordan-Hunt School, Erdenheim PA /
--     Oaklyn NJ (IDTANA-only addresses, no corroboration); Tir na Nog Irish
--     Dance, Central PA; Bergin Academy, Bayside NY; McNiff School, Queens /
--     Mt. Kisco NY; Scoil Rince Saoirse, Yonkers NY; Harris-Grieco Clarence NY
--     (no address, no own-site corroboration); Cumascaigh School, Yorktown VA
--     (appears closed); DeNogla Academy, Charleston SC (own site: NJ/NY/PA
--     only); Scariff Locklier Leonelli, Wesley Chapel FL (own site: Tampa /
--     St. Pete / Palm Harbor only); Goode Academy, Stillwater OK (last trace
--     ~2016); Bell School-South, Fuquay-Varina/Raleigh NC (likely defunct);
--     King O'Sullivan School, GA (no 2025-26 evidence); Aisling S.R., FL
--     (no city/website/traces); Coshquin School, Mexico (no city/website);
--     Maple O'Callaghan Academy, VA (no VA venue verifiable); Kelly Gallagher
--     School, NC (not a separate school — co-director of seeded Connick &
--     Reid); Ashden Irish Dance, Prince Albert SK (partly verified only —
--     no 2025-26 activity record; confirm with WCIDTA first); Blakey School,
--     Kamloops BC (IDTANA + WCIDTA list it, own homepage does not name it);
--     Blakey School, Regina SK / Beach Academy of Irish Dance, Regina
--     (membership unconfirmed); O'Brien School, Duncan BC (likely former
--     location — own site: Victoria + Ladner only); Haran School Tri-Cities
--     WA (IDTANA names no Tri-Cities city); Connolly Academy, Littleton CO
--     (merged Avoca Connolly site lists Lakewood + Longmont only).
--   Not IDTANA/regional-council listed (out of scope for this audit, not
--     seeded): Mulkerin School (West Haven CT); Lynn Academy (Stamford CT);
--     The Kenny Academy (MA); Duffy Academy (Northampton MA); Greenway
--     Academy (MA); Carney Academy (MA); McBride School (CA Bay Area);
--     Wasatch Back Irish Dance (Heber City UT); Ré Nua Irish Dance (Denver
--     CO); Irish Dance Idaho (Boise ID); Rohan Murphy Irish Dance Academy
--     (Danville/Pleasant Hill CA); O'Connor School of Irish Dancing
--     (Thousand Oaks CA); Bernadette Short NDG/Montreal location; Celtic
--     Academy Canada Orangeville/Walkerton/Guelph locations; Burke Connolly
--     Atlanta-area venues Marietta/Decatur/Sandy Springs (coordinator
--     decision pending); Heritage Madison/Middletown/Wharton NJ, McGough
--     Philadelphia/Bronxville/Downingtown/New York NY, Rince Na Tiarna
--     Orchard Park/Amherst/Tonawanda NY, Hester Magnolia DE, Harris-Grieco
--     Clarence NY, Morgan Legacy Falls Church Ballet Nova / Baltimore MD
--     (all explicitly rejected by the Mid-Atlantic report as stale or
--     conflicting); Cannon Fairview Park OH (same operation as seeded
--     Olmsted Falls/Cleveland rows); Inishfree School, Mexico (no city
--     given); McNulty School of Irish Dance, LA (feisworx-only lead) and
--     McTeggart, Louisiana (feisworx-only, no IDTANA post).
--
-- FLAGGED ROWS SEEDED WITH A CAVEAT (see the row comment; parent to confirm):
--   Bradigan Irish Dance, Mexico City — listing marks Possibly Temporarily
--     Closed; Instagram is the live presence.
--   Smith Irish Dance, Lehi UT — thinnest verification (IDTANA + listings
--     only; site http-only, unreachable over https).
--   Mountain Eire Irish Dance, Woodland Park CO — one listing marks it
--     Permanently Closed; live own site + IDTANA win, listing looks stale.
--   Pride of Erin Ceili Dancers, San Diego CA — verified weekly ceil class,
--     but a social ceil group, not a CLRG step-dance school.
--   Young Academy of Irish Dance, Montreal QC — city unresolved (Montreal
--     evidence vs a business listing pinning it to Carleton North, NB);
--     seeded as Montreal per IDTANA.
--   McCormack Fay Academy, Chicago IL — IDTANA gives no class city
--     (Illinois & Indiana); seeded as Chicago with this flag.
--   Inis Acla School, Memphis TN — address conflict unresolved (IDTANA
--     venue 1705 Poplar Ave vs listing 820 Herbert Rd); seeded city-only.
--   Celtic Steps, Colorado Springs CO — own site shows 4701 Centennial Blvd
--     in the schedule and 4705 in a duplicated contact block; 4701 used.
--   Royal Academy, Charlotte NC (Bellhaven Blvd) — ZIP conflict: IDTANA
--     28216 vs own-site footer 28206; 28216 corroborated by a listing.
--   Cass-Barrington, Webster TX — listing-sourced address 355 E Nasa Rd 1
--     Unit 355 NOT used (unverified lead); seeded city-only.
--   Ryan School, New Orleans LA — listed as New Orleans/Metairie; seeded
--     as New Orleans. Scoil Rince Mahoney, St. Albert AB — city from a
--     business listing, WCIDTA says Edmonton & Area only. McCormack School,
--     Sherwood Park AB — city per Strathcona County listing, pending
--     confirmation. Doherty Petri, San Diego/La Jolla CA — SD-specific site
--     used (sandiegoirishdance.com); parent site is petrischool.com.
--
-- UNGEOCODED STREET ADDRESSES (street text kept, coordinates NULL):
--   US (Census could not match): Farrell East Durham NY (Weldon House,
--     Route 145); Scoil Rince Riordan West Nyack NY (107 Strawtown Rd);
--     Hudson Wayzata MN (1250 Wayzata Blvd E); Celtic Irish Dance Academy
--     Burbank CA (7075 Vineland Ave). See also the updates file for
--     ungeocoded upgrades/corrections.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McArdle School of Irish Dance', 'mcardle-school-of-irish-dance-granby', 'Granby', 'Connecticut', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McArdle School of Irish Dance' and city = 'Granby'
);
-- McArdle School of Irish Dance, Granby: Granby, Connecticut (city-only — no street address published) — IDTANA; http-only site, no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Greene O''Leary School of Irish Dancing', 'greene-oleary-school-of-irish-dancing-dedham', 'Dedham', 'Massachusetts', 'United States', 'https://www.greeneoleary.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Greene O''Leary School of Irish Dancing' and city = 'Dedham'
);
-- Greene O'Leary School of Irish Dancing, Dedham: Dedham, Massachusetts (city-only — no street address published) — IDTANA + NEIDT; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Dwyer School of Irish Dance', 'odwyer-school-of-irish-dance-boston', 'Boston', 'Massachusetts', 'United States', 'https://www.odwyeririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Dwyer School of Irish Dance' and city = 'Boston'
);
-- O'Dwyer School of Irish Dance, Boston: Boston, Massachusetts (city-only — no street address published) — IDTANA + NEIDT; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Irish Dance Company', 'the-irish-dance-company-lancaster', 'Lancaster', 'Massachusetts', 'United States', 'https://www.theirishdancecompany.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'The Irish Dance Company' and city = 'Lancaster'
);
-- The Irish Dance Company, Lancaster: Lancaster, Massachusetts (city-only — no street address published) — Own site current location; IDTANA still says Clinton MA; former Clinton address closed, not used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-ridgefield', 'Ridgefield', 'Connecticut', 'United States', 'https://petrischool.com/',
  '722 Danbury Rd', null, 41.328535, -73.473084, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'Ridgefield'
);
-- Doherty Petri School of Irish Dance, Ridgefield: 722 DANBURY RD, RIDGEFIELD, CT, 06877 — IDTANA; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harney Pender Keady Academy of Irish Dance', 'harney-pender-keady-academy-of-irish-dance-walpole', 'Walpole', 'Massachusetts', 'United States', 'https://www.hpkacademy.com/',
  '945 Main Street', '02081', 42.146652, -71.252492, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Harney Pender Keady Academy of Irish Dance' and city = 'Walpole'
);
-- Harney Pender Keady Academy of Irish Dance, Walpole: 945 MAIN ST, WALPOLE, MA, 02081 — IDTANA; shared studio with Harney-Crawford

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Petrocelli Academy of Irish Dance', 'petrocelli-academy-of-irish-dance-milton', 'Milton', 'Massachusetts', 'United States', 'https://petrocelliacademyid.com/',
  '495 Canton Avenue', '02186', 42.254024, -71.078346, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Petrocelli Academy of Irish Dance' and city = 'Milton'
);
-- Petrocelli Academy of Irish Dance, Milton: 495 CANTON AVE, MILTON, MA, 02186 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Petrocelli Academy of Irish Dance', 'petrocelli-academy-of-irish-dance-swampscott', 'Swampscott', 'Massachusetts', 'United States', 'https://petrocelliacademyid.com/',
  '40 Monument Avenue', '01907', 42.469288, -70.917710, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Petrocelli Academy of Irish Dance' and city = 'Swampscott'
);
-- Petrocelli Academy of Irish Dance, Swampscott: 40 MONUMENT AVE, SWAMPSCOTT, MA, 01907 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Petrocelli Academy of Irish Dance', 'petrocelli-academy-of-irish-dance-dorchester', 'Dorchester', 'Massachusetts', 'United States', 'https://petrocelliacademyid.com/',
  '771 Adams Street', '02122', 42.283699, -71.055714, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Petrocelli Academy of Irish Dance' and city = 'Dorchester'
);
-- Petrocelli Academy of Irish Dance, Dorchester: 771 ADAMS ST, DORCHESTER, MA, 02122 — IDTANA; Boston (Dorchester) venue

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goulding School of Irish Dance', 'goulding-school-of-irish-dance-cranston', 'Cranston', 'Rhode Island', 'United States', 'https://gouldingschoolofirishdance.com/',
  '50 America St', '02920', 41.784101, -71.462810, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Goulding School of Irish Dance' and city = 'Cranston'
);
-- Goulding School of Irish Dance, Cranston: 50 AMERICA ST, CRANSTON, RI, 02920 — IDTANA + Kelly site; Irish Ceilidhe Club of RI

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goulding School of Irish Dance', 'goulding-school-of-irish-dance-wellesley', 'Wellesley', 'Massachusetts', 'United States', 'https://gouldingschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Goulding School of Irish Dance' and city = 'Wellesley'
);
-- Goulding School of Irish Dance, Wellesley: Wellesley, Massachusetts (city-only — no street address published) — IDTANA; St Johns Church venue, no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Keane O''Brien Academy of Irish Dance', 'keane-obrien-academy-of-irish-dance-braintree', 'Braintree', 'Massachusetts', 'United States', 'https://keaneobrienacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Keane O''Brien Academy of Irish Dance' and city = 'Braintree'
);
-- Keane O'Brien Academy of Irish Dance, Braintree: Braintree, Massachusetts (city-only — no street address published) — IDTANA; Holbrook/Braintree line, no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murphy Academy of Irish Dance', 'murphy-academy-of-irish-dance-west-boylston', 'West Boylston', 'Massachusetts', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murphy Academy of Irish Dance' and city = 'West Boylston'
);
-- Murphy Academy of Irish Dance, West Boylston: West Boylston, Massachusetts (city-only — no street address published) — IDTANA; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brennan-Lucey Irish Dance Academy', 'brennan-lucey-irish-dance-academy-orange', 'Orange', 'Connecticut', 'United States', 'https://www.brennanlucey.com/',
  '518 Boston Post Road', null, 41.257888, -73.012418, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Brennan-Lucey Irish Dance Academy' and city = 'Orange'
);
-- Brennan-Lucey Irish Dance Academy, Orange: 518 BOSTON POST RD, ORANGE, CT, 06477 — Own site; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-brighton', 'Brighton', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  '323 Washington Street', null, 42.349101, -71.152006, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'Brighton'
);
-- O'Shea-Chaplin Academy of Irish Dance, Brighton: 323 WASHINGTON ST, BRIGHTON, MA, 02135 — Own site; Star Dance Studio; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-west-roxbury', 'West Roxbury', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  '77 Stratford Street', null, 42.283034, -71.150111, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'West Roxbury'
);
-- O'Shea-Chaplin Academy of Irish Dance, West Roxbury: 77 STRATFORD ST, WEST ROXBURY, MA, 02132 — Own site; Stratford United Church; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea-Chaplin Academy of Irish Dance', 'oshea-chaplin-academy-of-irish-dance-danvers', 'Danvers', 'Massachusetts', 'United States', 'https://www.oscirishdance.com/',
  '10 Elm St', null, 42.564945, -70.936146, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Shea-Chaplin Academy of Irish Dance' and city = 'Danvers'
);
-- O'Shea-Chaplin Academy of Irish Dance, Danvers: 10 ELM ST, DANVERS, MA, 01923 — Own site; Dance Center of Danvers; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Armstrong Irish Dance Academy', 'armstrong-irish-dance-academy-winchester', 'Winchester', 'Virginia', 'United States', null,
  '33 E Gerrard St', '22601', 39.176522, -78.167973, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Armstrong Irish Dance Academy' and city = 'Winchester'
);
-- Armstrong Irish Dance Academy, Winchester: 33 E GERRARD ST, WINCHESTER, VA, 22601 — IDTANA + own site; http-only site; An Chomhdhail-affiliated; also in Southern report

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bernadette Short School of Irish Dancing', 'bernadette-short-school-of-irish-dancing-plattsburgh', 'Plattsburgh', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bernadette Short School of Irish Dancing' and city = 'Plattsburgh'
);
-- Bernadette Short School of Irish Dancing, Plattsburgh: Plattsburgh, New York (city-only — no street address published) — IDTANA; http-only site; no Plattsburgh street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clan na hÉireann Irish Dance', 'clan-na-heireann-irish-dance-baldwin-place', 'Baldwin Place', 'New York', 'United States', 'https://www.clannaheireann.com/',
  '267 Tomahawk St', null, 41.345283, -73.753129, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Clan na hÉireann Irish Dance' and city = 'Baldwin Place'
);
-- Clan na hÉireann Irish Dance, Baldwin Place: 267 TOMAHAWK ST, BALDWIN PLACE, NY, 10505 — IDTANA; no ZIP verified; successor to Kelly-Oster (closed 2020)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Coyle School of Irish Dance', 'coyle-school-of-irish-dance-norristown', 'Norristown', 'Pennsylvania', 'United States', null,
  '1341 Sandy Hill Rd', null, 40.114059, -75.322463, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Coyle School of Irish Dance' and city = 'Norristown'
);
-- Coyle School of Irish Dance, Norristown: 1341 SANDY HILL RD, NORRISTOWN, PA, 19401 — IDTANA + Facebook place listing; no ZIP verified; no standalone website

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-garden-city', 'Garden City', 'New York', 'United States', 'https://petrischool.com/',
  '66 New Hyde Park Rd', null, 40.718403, -73.679666, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'Garden City'
);
-- Doherty Petri School of Irish Dance, Garden City: 66 NEW HYDE PARK RD, GARDEN CITY, NY, 11530 — IDTANA; no ZIP published; http-only main site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-east-northport', 'East Northport', 'New York', 'United States', 'https://petrischool.com/',
  '275 Larkfield Rd', null, 40.875143, -73.324144, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'East Northport'
);
-- Doherty Petri School of Irish Dance, East Northport: 275 LARKFIELD RD, EAST NORTHPORT, NY, 11731 — IDTANA; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-hartsdale', 'Hartsdale', 'New York', 'United States', 'https://petrischool.com/',
  '611 W Hartsdale Ave', null, 41.035693, -73.809439, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'Hartsdale'
);
-- Doherty Petri School of Irish Dance, Hartsdale: 611 W HARTSDALE AVE, HARTSDALE, NY, 10530 — IDTANA; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-lancaster', 'Lancaster', 'Pennsylvania', 'United States', 'https://petrischool.com/',
  '1285 Manheim Pike', null, 40.064036, -76.324723, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'Lancaster'
);
-- Doherty Petri School of Irish Dance, Lancaster: 1285 MANHEIM PIKE, LANCASTER, PA, 17601 — IDTANA; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-parkville', 'Parkville', 'Maryland', 'United States', 'https://petrischool.com/',
  '8724 Satyr Hill Rd', null, 39.395058, -76.542807, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'Parkville'
);
-- Doherty Petri School of Irish Dance, Parkville: 8724 SATYR HILL RD, PARKVILLE, MD, 21234 — IDTANA; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Emerald Isle Academy of Irish Dance', 'emerald-isle-academy-of-irish-dance-garnet-valley', 'Garnet Valley', 'Pennsylvania', 'United States', 'https://emeraldisleacademy.com/',
  '1712 Edward Circle', '19060', 39.846351, -75.463426, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Emerald Isle Academy of Irish Dance' and city = 'Garnet Valley'
);
-- Emerald Isle Academy of Irish Dance, Garnet Valley: 1712 EDWARD CIR, GARNET VALLEY, PA, 19060 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Emerald Isle Academy of Irish Dance', 'emerald-isle-academy-of-irish-dance-absecon', 'Absecon', 'New Jersey', 'United States', 'https://emeraldisleacademy.com/',
  '307 W Absecon Blvd', null, 39.427156, -74.504241, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Emerald Isle Academy of Irish Dance' and city = 'Absecon'
);
-- Emerald Isle Academy of Irish Dance, Absecon: 307 W ABSECON BLVD, ABSECON, NJ, 08201 — IDTANA; no ZIP shown

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Emerald Isle Academy of Irish Dance', 'emerald-isle-academy-of-irish-dance-ridley-twp', 'Ridley Twp', 'Pennsylvania', 'United States', 'https://emeraldisleacademy.com/',
  '106 Swarthmore Ave', null, 39.899484, -75.330475, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Emerald Isle Academy of Irish Dance' and city = 'Ridley Twp'
);
-- Emerald Isle Academy of Irish Dance, Ridley Twp: 106 SWARTHMORE AVE, RIDLEY, PA, 19070 — IDTANA; Ridley Township; no ZIP shown

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Emerald Isle Academy of Irish Dance', 'emerald-isle-academy-of-irish-dance-woodstown', 'Woodstown', 'New Jersey', 'United States', 'https://emeraldisleacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Emerald Isle Academy of Irish Dance' and city = 'Woodstown'
);
-- Emerald Isle Academy of Irish Dance, Woodstown: Woodstown, New Jersey (city-only — no street address published) — IDTANA; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Emerald Isle Academy of Irish Dance', 'emerald-isle-academy-of-irish-dance-haddonfield', 'Haddonfield', 'New Jersey', 'United States', 'https://emeraldisleacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Emerald Isle Academy of Irish Dance' and city = 'Haddonfield'
);
-- Emerald Isle Academy of Irish Dance, Haddonfield: Haddonfield, New Jersey (city-only — no street address published) — IDTANA; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Farrell School of Irish Dance', 'the-farrell-school-of-irish-dance-albany', 'Albany', 'New York', 'United States', 'https://farrellschool.us/',
  '375 Ontario St', '12208', 42.657530, -73.785405, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The Farrell School of Irish Dance' and city = 'Albany'
);
-- The Farrell School of Irish Dance, Albany: 375 ONTARIO ST, ALBANY, NY, 12208 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Farrell School of Irish Dance', 'the-farrell-school-of-irish-dance-schenectady', 'Schenectady', 'New York', 'United States', 'https://farrellschool.us/',
  '1748 State St', '12304', 42.782270, -73.906174, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The Farrell School of Irish Dance' and city = 'Schenectady'
);
-- The Farrell School of Irish Dance, Schenectady: 1748 STATE ST, SCHENECTADY, NY, 12304 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Farrell School of Irish Dance', 'the-farrell-school-of-irish-dance-east-durham', 'East Durham', 'New York', 'United States', 'https://farrellschool.us/',
  'Weldon House, Route 145', '12423', null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'The Farrell School of Irish Dance' and city = 'East Durham'
);
-- The Farrell School of Irish Dance, East Durham: Weldon House, Route 145, East Durham, New York 12423 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Fitzpatrick School of Irish Dance', 'fitzpatrick-school-of-irish-dance-doylestown', 'Doylestown', 'Pennsylvania', 'United States', 'https://www.fitzpatrickirishdance.net/',
  '4095 Ferry Rd', '18902', 40.350801, -75.137067, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Fitzpatrick School of Irish Dance' and city = 'Doylestown'
);
-- Fitzpatrick School of Irish Dance, Doylestown: 4095 FERRY RD, DOYLESTOWN, PA, 18902 — IDTANA; distinct from Fitzpatrick School, Lake Forest IL

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goodwin Irish Dance', 'goodwin-irish-dance-east-rochester', 'East Rochester', 'New York', 'United States', null,
  '349 W Commercial St', '14445', 43.114993, -77.492337, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Goodwin Irish Dance' and city = 'East Rochester'
);
-- Goodwin Irish Dance, East Rochester: 349 W COMMERCIAL ST, EAST ROCHESTER, NY, 14445 — IDTANA + own site; http-only site; IDTANA excerpt says Rochester

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hendry Sylvester McNamara Irish Dance', 'hendry-sylvester-mcnamara-irish-dance-eastchester', 'Eastchester', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Hendry Sylvester McNamara Irish Dance' and city = 'Eastchester'
);
-- Hendry Sylvester McNamara Irish Dance, Eastchester: Eastchester, New York (city-only — no street address published) — Verified operating via 2026 NAIDC / Oireachtas results; no website or street found

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Jamieson Irish Dance', 'jamieson-irish-dance-webster', 'Webster', 'New York', 'United States', null,
  '696 Ridge Rd', '14580', 43.204013, -77.487037, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Jamieson Irish Dance' and city = 'Webster'
);
-- Jamieson Irish Dance, Webster: 696 RIDGE RD, WEBSTER, NY, 14580 — IDTANA + own site; http-only site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Jamieson Irish Dance', 'jamieson-irish-dance-gates', 'Gates', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Jamieson Irish Dance' and city = 'Gates'
);
-- Jamieson Irish Dance, Gates: Gates, New York (city-only — no street address published) — Own description confirms Gates location; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-baltimore', 'Baltimore', 'Maryland', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Baltimore'
);
-- Kavanagh Porter Academy of Irish Dance, Baltimore: Baltimore, Maryland (city-only — no street address published) — IDTANA; HQ Peachtree City GA; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Ríoga (Kristin Butke Irish Dance)', 'clann-rioga-kristin-butke-irish-dance-warrenton', 'Warrenton', 'Virginia', 'United States', 'https://kristinbutkeirishdance.com/',
  '420 Rosedale Ct', '20186', 38.718453, -77.783645, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Clann Ríoga (Kristin Butke Irish Dance)' and city = 'Warrenton'
);
-- Clann Ríoga (Kristin Butke Irish Dance), Warrenton: 420 ROSEDALE CT, WARRENTON, VA, 20186 — IDTANA + 2026 schedule; merged May 2026 into Clann Rioga; seeded under Clann Rioga name, not Butke

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Ríoga (Kristin Butke Irish Dance)', 'clann-rioga-kristin-butke-irish-dance-sterling', 'Sterling', 'Virginia', 'United States', 'https://kristinbutkeirishdance.com/',
  '23561 Overland Dr', '20166', 38.963143, -77.500810, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Clann Ríoga (Kristin Butke Irish Dance)' and city = 'Sterling'
);
-- Clann Ríoga (Kristin Butke Irish Dance), Sterling: 23561 OVERLAND DR, STERLING, VA, 20166 — Sterling/Dulles location; same merger note

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Ríoga (Kristin Butke Irish Dance)', 'clann-rioga-kristin-butke-irish-dance-front-royal', 'Front Royal', 'Virginia', 'United States', 'https://kristinbutkeirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Ríoga (Kristin Butke Irish Dance)' and city = 'Front Royal'
);
-- Clann Ríoga (Kristin Butke Irish Dance), Front Royal: Front Royal, Virginia (city-only — no street address published) — 2026 class schedule; venue name only, no street

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Ríoga (Kristin Butke Irish Dance)', 'clann-rioga-kristin-butke-irish-dance-ashburn', 'Ashburn', 'Virginia', 'United States', 'https://kristinbutkeirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Ríoga (Kristin Butke Irish Dance)' and city = 'Ashburn'
);
-- Clann Ríoga (Kristin Butke Irish Dance), Ashburn: Ashburn, Virginia (city-only — no street address published) — 2026 class schedule (Southern a1); venue name only, no street

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Ríoga (Kristin Butke Irish Dance)', 'clann-rioga-kristin-butke-irish-dance-fairfax', 'Fairfax', 'Virginia', 'United States', 'https://kristinbutkeirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Ríoga (Kristin Butke Irish Dance)' and city = 'Fairfax'
);
-- Clann Ríoga (Kristin Butke Irish Dance), Fairfax: Fairfax, Virginia (city-only — no street address published) — 2026 class schedule (Southern a1); Green Acres Center venue, no street

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clann Ríoga (Kristin Butke Irish Dance)', 'clann-rioga-kristin-butke-irish-dance-fredericksburg', 'Fredericksburg', 'Virginia', 'United States', 'https://kristinbutkeirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clann Ríoga (Kristin Butke Irish Dance)' and city = 'Fredericksburg'
);
-- Clann Ríoga (Kristin Butke Irish Dance), Fredericksburg: Fredericksburg, Virginia (city-only — no street address published) — 2026 class schedule (Southern a1); venue name only, no street

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Marie Moore School of Irish Dance', 'marie-moore-school-of-irish-dance-scotch-plains', 'Scotch Plains', 'New Jersey', 'United States', 'https://mariemooreirishdance.com/',
  '302 Park Ave', '07076', 40.652510, -74.400982, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Marie Moore School of Irish Dance' and city = 'Scotch Plains'
);
-- Marie Moore School of Irish Dance, Scotch Plains: 302 PARK AVE, SCOTCH PLAINS, NJ, 07076 — IDTANA; 302/302B Park Ave

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Marie Moore School of Irish Dance', 'marie-moore-school-of-irish-dance-ewing', 'Ewing', 'New Jersey', 'United States', 'https://mariemooreirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Marie Moore School of Irish Dance' and city = 'Ewing'
);
-- Marie Moore School of Irish Dance, Ewing: Ewing, New Jersey (city-only — no street address published) — IDTANA; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Marie Moore School of Irish Dance', 'marie-moore-school-of-irish-dance-pennington', 'Pennington', 'New Jersey', 'United States', 'https://mariemooreirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Marie Moore School of Irish Dance' and city = 'Pennington'
);
-- Marie Moore School of Irish Dance, Pennington: Pennington, New Jersey (city-only — no street address published) — Own current description adds Pennington; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Marie Moore School of Irish Dance', 'marie-moore-school-of-irish-dance-millington', 'Millington', 'New Jersey', 'United States', 'https://mariemooreirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Marie Moore School of Irish Dance' and city = 'Millington'
);
-- Marie Moore School of Irish Dance, Millington: Millington, New Jersey (city-only — no street address published) — Own current description adds Millington; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McCarthy School of Irish Dance', 'mccarthy-school-of-irish-dance-grand-island', 'Grand Island', 'New York', 'United States', null,
  '3432 Wallace Dr', '14072', 43.055473, -78.961120, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McCarthy School of Irish Dance' and city = 'Grand Island'
);
-- McCarthy School of Irish Dance, Grand Island: 3432 WALLACE DR, GRAND ISLAND, NY, 14072 — IDTANA; no standalone website, Instagram only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mise Eire', 'mise-eire-babylon', 'Babylon', 'New York', 'United States', 'https://www.miseeireirishdancers.com/',
  '27 Locust Ave', '11702', 40.701090, -73.327713, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Mise Eire' and city = 'Babylon'
);
-- Mise Eire, Babylon: 27 LOCUST AVE, BABYLON, NY, 11702 — IDTANA; 2026-27 registration live

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morse Academy of Irish Dance', 'morse-academy-of-irish-dance-plattsburgh', 'Plattsburgh', 'New York', 'United States', null,
  '4919 South Catherine St', null, 44.684122, -73.459922, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Morse Academy of Irish Dance' and city = 'Plattsburgh'
);
-- Morse Academy of Irish Dance, Plattsburgh: 4919 S CATHERINE ST, PLATTSBURGH, NY, 12901 — IDTANA; http-only site; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mulvihill-Lynch Irish Dance Studio', 'mulvihill-lynch-irish-dance-studio-lake-ronkonkoma', 'Lake Ronkonkoma', 'New York', 'United States', null,
  '709 Hawkins Ave', '11779', 40.834479, -73.109064, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Mulvihill-Lynch Irish Dance Studio' and city = 'Lake Ronkonkoma'
);
-- Mulvihill-Lynch Irish Dance Studio, Lake Ronkonkoma: 709 HAWKINS AVE, LAKE RONKONKOMA, NY, 11779 — IDTANA; http-only site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mulvihill-Lynch Irish Dance Studio', 'mulvihill-lynch-irish-dance-studio-kings-park', 'Kings Park', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mulvihill-Lynch Irish Dance Studio' and city = 'Kings Park'
);
-- Mulvihill-Lynch Irish Dance Studio, Kings Park: Kings Park, New York (city-only — no street address published) — Satellite (VFW Hall); no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mulvihill-Lynch Irish Dance Studio', 'mulvihill-lynch-irish-dance-studio-nesconset', 'Nesconset', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mulvihill-Lynch Irish Dance Studio' and city = 'Nesconset'
);
-- Mulvihill-Lynch Irish Dance Studio, Nesconset: Nesconset, New York (city-only — no street address published) — Satellite (Just Dance Studio); no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mulvihill-Lynch Irish Dance Studio', 'mulvihill-lynch-irish-dance-studio-center-moriches', 'Center Moriches', 'New York', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mulvihill-Lynch Irish Dance Studio' and city = 'Center Moriches'
);
-- Mulvihill-Lynch Irish Dance Studio, Center Moriches: Center Moriches, New York (city-only — no street address published) — Satellite (Dance Elek-tra PAC); no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Sullivan School of Irish Dancing', 'osullivan-school-of-irish-dancing-north-salem', 'North Salem', 'New York', 'United States', 'https://osullivanirishdancing.com/',
  '14 Daniel Rd', '10560', 41.345334, -73.649755, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Sullivan School of Irish Dancing' and city = 'North Salem'
);
-- O'Sullivan School of Irish Dancing, North Salem: 14 DANIEL RD, NORTH SALEM, NY, 10560 — Own site + IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Sullivan School of Irish Dancing', 'osullivan-school-of-irish-dancing-scarsdale', 'Scarsdale', 'New York', 'United States', 'https://osullivanirishdancing.com/',
  '270 Ardsley Rd', '10583', 40.992546, -73.818472, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Sullivan School of Irish Dancing' and city = 'Scarsdale'
);
-- O'Sullivan School of Irish Dancing, Scarsdale: 270 ARDSLEY RD, SCARSDALE, NY, 10583 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Sullivan School of Irish Dancing', 'osullivan-school-of-irish-dancing-brewster', 'Brewster', 'New York', 'United States', 'https://osullivanirishdancing.com/',
  '5 Vail Blvd', '10509', 41.361701, -73.573280, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Sullivan School of Irish Dancing' and city = 'Brewster'
);
-- O'Sullivan School of Irish Dancing, Brewster: 5 VAIL BLVD, BREWSTER, NY, 10509 — Own 2023-24 general-info PDF; Vails Pavilion

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Schade Academy', 'schade-academy-east-meadow', 'East Meadow', 'New York', 'United States', 'https://schadeacademy.org/',
  '266 E Meadow Ave', '11554', 40.717307, -73.562034, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Schade Academy' and city = 'East Meadow'
);
-- Schade Academy, East Meadow: 266 E MEADOW AVE, EAST MEADOW, NY, 11554 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Schade Academy', 'schade-academy-huntington', 'Huntington', 'New York', 'United States', 'https://schadeacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Schade Academy' and city = 'Huntington'
);
-- Schade Academy, Huntington: Huntington, New York (city-only — no street address published) — Own description; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Riordan', 'scoil-rince-riordan-west-nyack', 'West Nyack', 'New York', 'United States', 'https://www.scoilrinceriordan.com/',
  '107 Strawtown Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Riordan' and city = 'West Nyack'
);
-- Scoil Rince Riordan, West Nyack: 107 Strawtown Rd, West Nyack, New York — IDTANA; no ZIP verified

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Riordan', 'scoil-rince-riordan-nanuet', 'Nanuet', 'New York', 'United States', 'https://www.scoilrinceriordan.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Riordan' and city = 'Nanuet'
);
-- Scoil Rince Riordan, Nanuet: Nanuet, New York (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Irish Dance Company', 'the-irish-dance-company-north-castle', 'North Castle', 'New York', 'United States', 'https://www.theirishdancecompany.com/',
  '690 N Broadway', null, 41.055147, -73.766731, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The Irish Dance Company' and city = 'North Castle'
);
-- The Irish Dance Company, North Castle: 690 N BROADWAY, WHITE PLAINS, NY, 10603 — Directory listing; White Plains area; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Irish Dance Company', 'the-irish-dance-company-yonkers', 'Yonkers', 'New York', 'United States', 'https://www.theirishdancecompany.com/',
  '18 Boone St', null, 40.921691, -73.865326, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The Irish Dance Company' and city = 'Yonkers'
);
-- The Irish Dance Company, Yonkers: 18 BOONE ST, YONKERS, NY, 10704 — IDTANA; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Irish Dance Company', 'the-irish-dance-company-lagrangeville', 'LaGrangeville', 'New York', 'United States', 'https://www.theirishdancecompany.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'The Irish Dance Company' and city = 'LaGrangeville'
);
-- The Irish Dance Company, LaGrangeville: LaGrangeville, New York (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-burke', 'Burke', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  '9800 Old Keene Mill Rd', '22015', 38.773984, -77.283296, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Burke'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Burke: 9800 OLD KEENE MILL RD, BURKE, VA, 22015 — IDTANA; The Foundry; also in Southern report

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Morgan Legacy Academy (formerly McGrath Morgan Academy)', 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-chantilly', 'Chantilly', 'Virginia', 'United States', 'https://mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Morgan Legacy Academy (formerly McGrath Morgan Academy)' and city = 'Chantilly'
);
-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Chantilly: Chantilly, Virginia (city-only — no street address published) — IDTANA; Russell School of Ballet, Sullyfield Circle - venue only, no street number/ZIP

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeNogla Academy', 'denogla-academy-hamilton', 'Hamilton', 'New Jersey', 'United States', 'https://www.denogla-academy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'DeNogla Academy' and city = 'Hamilton'
);
-- DeNogla Academy, Hamilton: Hamilton, New Jersey (city-only — no street address published) — IDTANA excerpt only; no address corroborated - city-only add per Mid-Atlantic report

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeNogla Academy', 'denogla-academy-fishkill', 'Fishkill', 'New York', 'United States', 'https://www.denogla-academy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'DeNogla Academy' and city = 'Fishkill'
);
-- DeNogla Academy, Fishkill: Fishkill, New York (city-only — no street address published) — IDTANA excerpt only; no address corroborated - city-only add per Mid-Atlantic report

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Northshore School of Irish Dance', 'northshore-school-of-irish-dance-mandeville', 'Mandeville', 'Louisiana', 'United States', null,
  '829 Asbury Dr', '70471', 30.399061, -90.085395, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Northshore School of Irish Dance' and city = 'Mandeville'
);
-- Northshore School of Irish Dance, Mandeville: 829 ASBURY DR, MANDEVILLE, LA, 70471 — IDTANA; own site 404, Instagram active; street+ZIP corroborated by Mandeville listings

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Northshore School of Irish Dance', 'northshore-school-of-irish-dance-covington', 'Covington', 'Louisiana', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Northshore School of Irish Dance' and city = 'Covington'
);
-- Northshore School of Irish Dance, Covington: Covington, Louisiana (city-only — no street address published) — IDTANA excerpt; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Northshore School of Irish Dance', 'northshore-school-of-irish-dance-madisonville', 'Madisonville', 'Louisiana', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Northshore School of Irish Dance' and city = 'Madisonville'
);
-- Northshore School of Irish Dance, Madisonville: Madisonville, Louisiana (city-only — no street address published) — IDTANA excerpt; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Northshore School of Irish Dance', 'northshore-school-of-irish-dance-lacombe', 'Lacombe', 'Louisiana', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Northshore School of Irish Dance' and city = 'Lacombe'
);
-- Northshore School of Irish Dance, Lacombe: Lacombe, Louisiana (city-only — no street address published) — IDTANA excerpt; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ryan School of Irish Dance (Adoue Academy)', 'ryan-school-of-irish-dance-adoue-academy-covington', 'Covington', 'Louisiana', 'United States', 'https://www.irishdancelouisiana.com/',
  '301 US-190, Suite E-10', null, 30.436395, -90.083800, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ryan School of Irish Dance (Adoue Academy)' and city = 'Covington'
);
-- Ryan School of Irish Dance (Adoue Academy), Covington: 301 US HWY 190, COVINGTON, LA, 70433 — Regional-site only, no IDTANA post; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ryan School of Irish Dance (Adoue Academy)', 'ryan-school-of-irish-dance-adoue-academy-lafayette', 'Lafayette', 'Louisiana', 'United States', 'https://www.irishdancelouisiana.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ryan School of Irish Dance (Adoue Academy)' and city = 'Lafayette'
);
-- Ryan School of Irish Dance (Adoue Academy), Lafayette: Lafayette, Louisiana (city-only — no street address published) — Own site / regional site; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ryan School of Irish Dance (Adoue Academy)', 'ryan-school-of-irish-dance-adoue-academy-new-orleans', 'New Orleans', 'Louisiana', 'United States', 'https://www.irishdancelouisiana.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ryan School of Irish Dance (Adoue Academy)' and city = 'New Orleans'
);
-- Ryan School of Irish Dance (Adoue Academy), New Orleans: New Orleans, Louisiana (city-only — no street address published) — Own site / regional site lists New Orleans/Metairie; city shown as New Orleans, no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Inis Acla School of Irish Dance', 'inis-acla-school-of-irish-dance-memphis', 'Memphis', 'Tennessee', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Inis Acla School of Irish Dance' and city = 'Memphis'
);
-- Inis Acla School of Irish Dance, Memphis: Memphis, Tennessee (city-only — no street address published) — VERIFIED OPERATING but ADDRESS CONFLICT (unresolved): IDTANA venue Evergreen Theatre 1705 Poplar Ave 38104 vs listing 820 Herbert Rd studio - seeded city-only, no street, pending resolution

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Royal Academy of Irish Dance', 'royal-academy-of-irish-dance-charlotte-bellhaven-blvd', 'Charlotte', 'North Carolina', 'United States', 'https://www.royalacademyid.com/',
  '8400 Bellhaven Blvd, Ste A', '28216', 35.303916, -80.937407, 'street', 'census'
where not exists (
  select 1 from public.schools
  where slug = 'royal-academy-of-irish-dance-charlotte-bellhaven-blvd'
);
-- Royal Academy of Irish Dance, Charlotte: 8400 BELLHAVEN BLVD, CHARLOTTE, NC, 28216 — IDTANA; ZIP conflict: own-site footer says 28206, 28216 corroborated by listing - prefer 28216; slug suffixed -bellhaven-blvd (second Charlotte location)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Royal Academy of Irish Dance', 'royal-academy-of-irish-dance-davidson', 'Davidson', 'North Carolina', 'United States', 'https://www.royalacademyid.com/',
  '140 Jackson St', '28036', 35.498551, -80.850396, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Royal Academy of Irish Dance' and city = 'Davidson'
);
-- Royal Academy of Irish Dance, Davidson: 140 JACKSON ST, DAVIDSON, NC, 28036 — Own site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Royal Academy of Irish Dance', 'royal-academy-of-irish-dance-charlotte-monroe-rd', 'Charlotte', 'North Carolina', 'United States', 'https://www.royalacademyid.com/',
  '4418 Monroe Rd, Unit E', '28205', 35.194291, -80.786130, 'street', 'census'
where not exists (
  select 1 from public.schools
  where slug = 'royal-academy-of-irish-dance-charlotte-monroe-rd'
);
-- Royal Academy of Irish Dance, Charlotte: 4418 MONROE RD, CHARLOTTE, NC, 28205 — Own site; second Charlotte location; slug suffixed -monroe-rd

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rhodes Academy of Irish Dance', 'rhodes-academy-of-irish-dance-virginia-beach', 'Virginia Beach', 'Virginia', 'United States', 'https://www.rhodesirishdance.com/',
  '2927 Virginia Beach Blvd', '23452', 36.843900, -76.072763, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rhodes Academy of Irish Dance' and city = 'Virginia Beach'
);
-- Rhodes Academy of Irish Dance, Virginia Beach: 2927 VIRGINIA BEACH BLVD, VIRGINIA BEACH, VA, 23452 — IDTANA; https verified by Southern report; also in Mid-Atlantic report; Williamsburg has no address - no row

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Misneach Irish Dance Academy', 'misneach-irish-dance-academy-purcellville', 'Purcellville', 'Virginia', 'United States', 'https://misneachirishdance.com/',
  '609 E Main St', '20132', 39.136587, -77.706463, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Misneach Irish Dance Academy' and city = 'Purcellville'
);
-- Misneach Irish Dance Academy, Purcellville: 609 E MAIN ST, PURCELLVILLE, VA, 20132 — Regional-site only, no IDTANA post; ZIP confirmed

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Misneach Irish Dance Academy', 'misneach-irish-dance-academy-ashburn', 'Ashburn', 'Virginia', 'United States', 'https://misneachirishdance.com/',
  '44799 Saranac St', '20147', 39.044187, -77.451368, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Misneach Irish Dance Academy' and city = 'Ashburn'
);
-- Misneach Irish Dance Academy, Ashburn: 44799 SARANAC ST, ASHBURN, VA, 20147 — Regional-site only; ZIP confirmed

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Misneach Irish Dance Academy', 'misneach-irish-dance-academy-charles-town', 'Charles Town', 'West Virginia', 'United States', 'https://misneachirishdance.com/',
  '108 Patrick Henry Way', null, 39.300286, -77.830760, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Misneach Irish Dance Academy' and city = 'Charles Town'
);
-- Misneach Irish Dance Academy, Charles Town: 108 PATRICK HENRY WAY, CHARLES TOWN, WV, 25414 — Regional-site only; first WV row; ZIP not verified

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-winter-garden', 'Winter Garden', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Winter Garden'
);
-- Finnegan Academy of Irish Dance, Winter Garden: Winter Garden, Florida (city-only — no street address published) — IDTANA + own site; classes at host schools, no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-windermere', 'Windermere', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Windermere'
);
-- Finnegan Academy of Irish Dance, Windermere: Windermere, Florida (city-only — no street address published) — IDTANA + own site; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-winter-park', 'Winter Park', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Winter Park'
);
-- Finnegan Academy of Irish Dance, Winter Park: Winter Park, Florida (city-only — no street address published) — IDTANA + own site; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-celebration', 'Celebration', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Celebration'
);
-- Finnegan Academy of Irish Dance, Celebration: Celebration, Florida (city-only — no street address published) — IDTANA + own site; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan Academy of Irish Dance', 'finnegan-academy-of-irish-dance-clermont', 'Clermont', 'Florida', 'United States', 'https://www.finneganacademy.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan Academy of Irish Dance' and city = 'Clermont'
);
-- Finnegan Academy of Irish Dance, Clermont: Clermont, Florida (city-only — no street address published) — Own site; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-jacksonville', 'Jacksonville', 'Florida', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Jacksonville'
);
-- Kavanagh Porter Academy of Irish Dance, Jacksonville: Jacksonville, Florida (city-only — no street address published) — IDTANA; http-only site per IDTANA but https verified by Western US report; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-peachtree-city', 'Peachtree City', 'Georgia', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Peachtree City'
);
-- Kavanagh Porter Academy of Irish Dance, Peachtree City: Peachtree City, Georgia (city-only — no street address published) — IDTANA; no street published; HQ city

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-richmond', 'Richmond', 'Virginia', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Richmond'
);
-- Kavanagh Porter Academy of Irish Dance, Richmond: Richmond, Virginia (city-only — no street address published) — Own-site location list; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-springfield', 'Springfield', 'Virginia', 'United States', 'https://kavanaghporteracademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Springfield'
);
-- Kavanagh Porter Academy of Irish Dance, Springfield: Springfield, Virginia (city-only — no street address published) — Own-site location list; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cass-Barrington Academy of Irish Dance', 'cass-barrington-academy-of-irish-dance-spring', 'Spring', 'Texas', 'United States', 'https://www.cass-barrington.com/',
  '100 Cypresswood Dr, Suite 1440', '77388', 30.052748, -95.434399, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Cass-Barrington Academy of Irish Dance' and city = 'Spring'
);
-- Cass-Barrington Academy of Irish Dance, Spring: 100 CYPRESSWOOD DR, SPRING, TX, 77388 — IDTANA + place listing; own site groups as The Woodlands/Spring

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cass-Barrington Academy of Irish Dance', 'cass-barrington-academy-of-irish-dance-webster', 'Webster', 'Texas', 'United States', 'https://www.cass-barrington.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cass-Barrington Academy of Irish Dance' and city = 'Webster'
);
-- Cass-Barrington Academy of Irish Dance, Webster: Webster, Texas (city-only — no street address published) — Own site Clear Lake-Friendswood location; listing-sourced address 355 E Nasa Rd 1 Unit 355 NOT used (unverified lead, see header)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maguire Academy of Irish Dance', 'maguire-academy-of-irish-dance-mexico-city', 'Mexico City', 'Mexico City', 'Mexico', null,
  'Moras 621, Col. Del Valle', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maguire Academy of Irish Dance' and city = 'Mexico City'
);
-- Maguire Academy of Irish Dance, Mexico City: Moras 621, Col. Del Valle, Mexico City, Mexico City [postal 03100 — not stored in postal_code column] — IDTANA; maguireacademy.com dead/expired; school operating (Tucson Rotary)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bradigan Irish Dance', 'bradigan-irish-dance-mexico-city', 'Mexico City', 'Mexico City', 'Mexico', null,
  'Av. San Jerónimo 1133, San Jerónimo Lídice', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bradigan Irish Dance' and city = 'Mexico City'
);
-- Bradigan Irish Dance, Mexico City: Av. San Jerónimo 1133, San Jerónimo Lídice, Mexico City, Mexico City [postal 10200 — not stored in postal_code column] — IDTANA; OPERATING STATUS NOT FULLY CONFIRMED: listing marks Possibly Temporarily Closed, Instagram is live presence; website unreachable - seeded with this flag

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Revah Irish Dance Academy', 'revah-irish-dance-academy-mexico-city', 'Mexico City', 'Mexico City', 'Mexico', null,
  'Cima #65, Jardines del Pedregal', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Revah Irish Dance Academy' and city = 'Mexico City'
);
-- Revah Irish Dance Academy, Mexico City: Cima #65, Jardines del Pedregal, Mexico City, Mexico City — IDTANA; Instagram/Facebook only, no website

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Irish Dancing de Mexico', 'irish-dancing-de-mexico-mexico-city', 'Mexico City', 'Mexico City', 'Mexico', null,
  'Africa 35, La Concepción, Coyoacán', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Irish Dancing de Mexico' and city = 'Mexico City'
);
-- Irish Dancing de Mexico, Mexico City: Africa 35, La Concepción, Coyoacán, Mexico City, Mexico City [postal 04020 — not stored in postal_code column] — IDTANA; http-only site unreachable at check; operating status not independently confirmed (feisworx lists name)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mexican Institute of Irish Dance', 'mexican-institute-of-irish-dance-guadalajara', 'Guadalajara', 'Jalisco', 'Mexico', 'https://miid.com.mx/',
  'Av. Mexico 3300-A20', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mexican Institute of Irish Dance' and city = 'Guadalajara'
);
-- Mexican Institute of Irish Dance, Guadalajara: Av. Mexico 3300-A20, Guadalajara, Jalisco — IDTANA; live site; no postal published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtica Dance Academy', 'celtica-dance-academy-queretaro', 'Querétaro', 'Querétaro', 'Mexico', null,
  'Calzada de los Arcos 46, Col. Bosques del Acueducto', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Celtica Dance Academy' and city = 'Querétaro'
);
-- Celtica Dance Academy, Querétaro: Calzada de los Arcos 46, Col. Bosques del Acueducto, Querétaro, Querétaro [postal 76020 — not stored in postal_code column] — Own site; http-only site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtica Dance Academy', 'celtica-dance-academy-metepec', 'Metepec', 'Mexico State', 'Mexico', null,
  'Av. Tecnológico 833, Bella Vista', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Celtica Dance Academy' and city = 'Metepec'
);
-- Celtica Dance Academy, Metepec: Av. Tecnológico 833, Bella Vista, Metepec, Mexico State — IDTANA; no postal published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Arkansas Academy of Irish Dance', 'rince-arkansas-academy-of-irish-dance-springdale', 'Springdale', 'Arkansas', 'United States', 'https://rincearkansas.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Arkansas Academy of Irish Dance' and city = 'Springdale'
);
-- Rince Arkansas Academy of Irish Dance, Springdale: Springdale, Arkansas (city-only — no street address published) — IDTANA excerpt (Northwest Arkansas: Fayetteville, Springdale, Rogers); no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Arkansas Academy of Irish Dance', 'rince-arkansas-academy-of-irish-dance-rogers', 'Rogers', 'Arkansas', 'United States', 'https://rincearkansas.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince Arkansas Academy of Irish Dance' and city = 'Rogers'
);
-- Rince Arkansas Academy of Irish Dance, Rogers: Rogers, Arkansas (city-only — no street address published) — IDTANA excerpt; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Niall O''Leary School of Irish Dance', 'niall-oleary-school-of-irish-dance-mexico-city', 'Mexico City', 'Mexico City', 'Mexico', 'https://nialloleary.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Niall O''Leary School of Irish Dance' and city = 'Mexico City'
);
-- Niall O'Leary School of Irish Dance, Mexico City: Mexico City, Mexico City (city-only — no street address published) — Own site; in-person classes in Mexico since 2012; no venue published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Drake School of Irish Dance', 'drake-school-of-irish-dance-mexico-city', 'Mexico City', 'Mexico City', 'Mexico', 'https://www.drakedance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Drake School of Irish Dance' and city = 'Mexico City'
);
-- Drake School of Irish Dance, Mexico City: Mexico City, Mexico City (city-only — no street address published) — IDTANA excerpt (Atlanta, Fort Lauderdale, Mexico City); no venue published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The O''Faolain Academy of Irish Dance', 'the-ofaolain-academy-of-irish-dance-st-louis', 'St. Louis', 'Missouri', 'United States', 'https://www.ofairishdance.com/',
  '36 Kirkham Industrial Ct', '63119', 38.601113, -90.352481, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The O''Faolain Academy of Irish Dance' and city = 'St. Louis'
);
-- The O'Faolain Academy of Irish Dance, St. Louis: 36 KIRKHAM INDUSTRIAL DR, SAINT LOUIS, MO, 63119 — IDTANA; address in Webster Groves

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The O''Faolain Academy of Irish Dance', 'the-ofaolain-academy-of-irish-dance-edwardsville', 'Edwardsville', 'Illinois', 'United States', 'https://www.ofairishdance.com/',
  '2771 Rte 66 Business Park Dr', '62025', 38.759494, -90.017750, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The O''Faolain Academy of Irish Dance' and city = 'Edwardsville'
);
-- The O'Faolain Academy of Irish Dance, Edwardsville: 2771 ROUTE 66 BUSINESS PARK DR, EDWARDSVILLE, IL, 62025 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Gaelic Origins Irish Dance', 'gaelic-origins-irish-dance-ofallon', 'O''Fallon', 'Illinois', 'United States', 'https://www.gaelicorigins.com/',
  '204 Scott Troy Rd, Ste B', '62269', 38.585763, -89.874004, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Gaelic Origins Irish Dance' and city = 'O''Fallon'
);
-- Gaelic Origins Irish Dance, O'Fallon: 204 SCOTT TROY RD, O FALLON, IL, 62269 — IDTANA; live site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dillon-Gavin School of Irish Dance', 'dillon-gavin-school-of-irish-dance-arlington-heights', 'Arlington Heights', 'Illinois', 'United States', 'https://www.dillongavin.com/',
  '415 W Golf Rd', '60005', 42.051296, -87.986454, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Dillon-Gavin School of Irish Dance' and city = 'Arlington Heights'
);
-- Dillon-Gavin School of Irish Dance, Arlington Heights: 415 GOLF RD, ARLINGTON HEIGHTS, IL, 60005 — IDTANA; business listing adds Ste 56

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Foy School of Traditional Irish Dance', 'foy-school-of-traditional-irish-dance-chicago', 'Chicago', 'Illinois', 'United States', 'https://foyirishdancers.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Foy School of Traditional Irish Dance' and city = 'Chicago'
);
-- Foy School of Traditional Irish Dance, Chicago: Chicago, Illinois (city-only — no street address published) — IDTANA inquire for address; business listing 5225 W Berteau Ave has no verified ZIP - not used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hogan Irish Dance Academy', 'hogan-irish-dance-academy-arlington-heights', 'Arlington Heights', 'Illinois', 'United States', 'https://hoganirishdanceacademy.com/',
  '646 S Arthur Ave', '60005', 42.073529, -87.966146, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Hogan Irish Dance Academy' and city = 'Arlington Heights'
);
-- Hogan Irish Dance Academy, Arlington Heights: 646 S ARTHUR AVE, ARLINGTON HEIGHTS, IL, 60005 — IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Eilish Sullivan School of Irish Dance', 'eilish-sullivan-school-of-irish-dance-new-lenox', 'New Lenox', 'Illinois', 'United States', null,
  '13923 E Illinois Hwy', '60451', 41.497713, -87.953730, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Eilish Sullivan School of Irish Dance' and city = 'New Lenox'
);
-- Eilish Sullivan School of Irish Dance, New Lenox: 13923 E ILLINOIS HWY, NEW LENOX, IL, 60451 — IDTANA; no website found, Instagram only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McCormack Fay Academy of Irish Dance', 'mccormack-fay-academy-of-irish-dance-chicago', 'Chicago', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McCormack Fay Academy of Irish Dance' and city = 'Chicago'
);
-- McCormack Fay Academy of Irish Dance, Chicago: Chicago, Illinois (city-only — no street address published) — IDTANA says Illinois & Indiana, no class city published - seeded as Chicago (area) with this flag; verified operating via 2024-25 feis records; no website/address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cross Keys School of Irish Dance', 'cross-keys-school-of-irish-dance-chicago', 'Chicago', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cross Keys School of Irish Dance' and city = 'Chicago'
);
-- Cross Keys School of Irish Dance, Chicago: Chicago, Illinois (city-only — no street address published) — IDTANA inquire for address; verified via May 2026 Chicago Feis entries; practices at Chicago Gaelic Park, Oak Forest; no website/address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Onórach Mulhern Geraghty School of Irish Dance (OMG)', 'onorach-mulhern-geraghty-school-of-irish-dance-omg-westmont', 'Westmont', 'Illinois', 'United States', 'https://www.omgirishdance.com/',
  '414 Plaza Dr, Suite #303', '60559', 41.812726, -87.966149, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Onórach Mulhern Geraghty School of Irish Dance (OMG)' and city = 'Westmont'
);
-- Onórach Mulhern Geraghty School of Irish Dance (OMG), Westmont: 414 PLAZA DR, WESTMONT, IL, 60559 — IDTANA; additional location of seeded OMG school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hudson Irish Dance Academy', 'hudson-irish-dance-academy-wayzata', 'Wayzata', 'Minnesota', 'United States', null,
  '1250 Wayzata Blvd E', '55391', null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Hudson Irish Dance Academy' and city = 'Wayzata'
);
-- Hudson Irish Dance Academy, Wayzata: 1250 Wayzata Blvd E, Wayzata, Minnesota 55391 — IDTANA; additional location of seeded Hudson school; no website in seed

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Hare School of Irish Dance', 'ohare-school-of-irish-dance-chicago', 'Chicago', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Hare School of Irish Dance' and city = 'Chicago'
);
-- O'Hare School of Irish Dance, Chicago: Chicago, Illinois (city-only — no street address published) — IDTANA inquire for address; additional location of seeded O'Hare school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Hare School of Irish Dance', 'ohare-school-of-irish-dance-plymouth', 'Plymouth', 'Michigan', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Hare School of Irish Dance' and city = 'Plymouth'
);
-- O'Hare School of Irish Dance, Plymouth: Plymouth, Michigan (city-only — no street address published) — IDTANA inquire for address; additional location of seeded O'Hare school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bailey-Murray Academy', 'bailey-murray-academy-naperville', 'Naperville', 'Illinois', 'United States', 'https://baileymurrayacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bailey-Murray Academy' and city = 'Naperville'
);
-- Bailey-Murray Academy, Naperville: Naperville, Illinois (city-only — no street address published) — IDTANA inquire for address; additional location of seeded Bailey-Murray school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blackbird Academy of Irish Dance', 'blackbird-academy-of-irish-dance-oak-lawn', 'Oak Lawn', 'Illinois', 'United States', 'https://blackbirdacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Blackbird Academy of Irish Dance' and city = 'Oak Lawn'
);
-- Blackbird Academy of Irish Dance, Oak Lawn: Oak Lawn, Illinois (city-only — no street address published) — IDTANA inquire for address; additional location of seeded Blackbird school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sheila Healy Academy of Irish Dance', 'sheila-healy-academy-of-irish-dance-evanston', 'Evanston', 'Illinois', 'United States', 'https://www.sheilahealyirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sheila Healy Academy of Irish Dance' and city = 'Evanston'
);
-- Sheila Healy Academy of Irish Dance, Evanston: Evanston, Illinois (city-only — no street address published) — IDTANA inquire for address; additional location of seeded Sheila Healy school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sheila Healy Academy of Irish Dance', 'sheila-healy-academy-of-irish-dance-wilmette', 'Wilmette', 'Illinois', 'United States', 'https://www.sheilahealyirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sheila Healy Academy of Irish Dance' and city = 'Wilmette'
);
-- Sheila Healy Academy of Irish Dance, Wilmette: Wilmette, Illinois (city-only — no street address published) — IDTANA inquire for address; additional location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sheila Healy Academy of Irish Dance', 'sheila-healy-academy-of-irish-dance-winnetka', 'Winnetka', 'Illinois', 'United States', 'https://www.sheilahealyirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sheila Healy Academy of Irish Dance' and city = 'Winnetka'
);
-- Sheila Healy Academy of Irish Dance, Winnetka: Winnetka, Illinois (city-only — no street address published) — IDTANA inquire for address; additional location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Leneghan Academy of Irish Dance', 'leneghan-academy-of-irish-dance-parma-heights', 'Parma Heights', 'Ohio', 'United States', 'https://www.leneghanacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Leneghan Academy of Irish Dance' and city = 'Parma Heights'
);
-- Leneghan Academy of Irish Dance, Parma Heights: Parma Heights, Ohio (city-only — no street address published) — IDTANA lists Parma Heights; no street published; additional location of seeded Leneghan school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Richens/Timm Academy', 'richens-timm-academy-dayton', 'Dayton', 'Ohio', 'United States', 'https://www.richenstimm.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Richens/Timm Academy' and city = 'Dayton'
);
-- Richens/Timm Academy, Dayton: Dayton, Ohio (city-only — no street address published) — IDTANA; no Dayton street published; additional location of seeded Richens/Timm school

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Lavin-Cassidy School of Irish Dance', 'lavin-cassidy-school-of-irish-dance-palos-heights', 'Palos Heights', 'Illinois', 'United States', null,
  '12343 S Harlem Ave', '60463', 41.667227, -87.796486, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Lavin-Cassidy School of Irish Dance' and city = 'Palos Heights'
);
-- Lavin-Cassidy School of Irish Dance, Palos Heights: 12343 S HARLEM AVE, PALOS HEIGHTS, IL, 60463 — Own-site footer lists as main studio; additional location of seeded Lavin-Cassidy school; no website in seed

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Boyle Irish Dance Academy', 'boyle-irish-dance-academy-san-francisco', 'San Francisco', 'California', 'United States', 'https://www.boyleirishdanceacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Boyle Irish Dance Academy' and city = 'San Francisco'
);
-- Boyle Irish Dance Academy, San Francisco: San Francisco, California (city-only — no street address published) — IDTANA inquire for address; own site live

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Boyle Irish Dance Academy', 'boyle-irish-dance-academy-pacifica', 'Pacifica', 'California', 'United States', 'https://www.boyleirishdanceacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Boyle Irish Dance Academy' and city = 'Pacifica'
);
-- Boyle Irish Dance Academy, Pacifica: Pacifica, California (city-only — no street address published) — IDTANA inquire; second city per IDTANA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Irish Dance Academy', 'celtic-irish-dance-academy-burbank', 'Burbank', 'California', 'United States', 'https://www.celticirishdanceacademy.com',
  '7075 Vineland Ave', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Celtic Irish Dance Academy' and city = 'Burbank'
);
-- Celtic Irish Dance Academy, Burbank: 7075 Vineland Ave, Burbank, California — IDTANA; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-san-diego', 'San Diego', 'California', 'United States', 'https://www.sandiegoirishdance.com/',
  '5550 Carmel Mountain Rd Ste 210', null, 32.928668, -117.197403, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'San Diego'
);
-- Doherty Petri School of Irish Dance, San Diego: 5550 CARMEL MOUNTAIN RD, SAN DIEGO, CA, 92130 — IDTANA; no ZIP published; SD-specific site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Doherty Petri School of Irish Dance', 'doherty-petri-school-of-irish-dance-la-jolla', 'La Jolla', 'California', 'United States', 'https://www.sandiegoirishdance.com/',
  '5705 La Jolla Blvd', null, 32.815740, -117.270655, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Doherty Petri School of Irish Dance' and city = 'La Jolla'
);
-- Doherty Petri School of Irish Dance, La Jolla: 5705 LA JOLLA BLVD, LA JOLLA, CA, 92037 — IDTANA; no ZIP published; second San Diego-area location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance', 'kelly-school-of-irish-dance-el-segundo', 'El Segundo', 'California', 'United States', null,
  '513 Main St', '90245', 33.922428, -118.416009, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance' and city = 'El Segundo'
);
-- Kelly School of Irish Dance, El Segundo: 513 MAIN ST, EL SEGUNDO, CA, 90245 — IDTANA; site http-only and down (404) - website NULL; school active per listings

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance', 'kelly-school-of-irish-dance-torrance', 'Torrance', 'California', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance' and city = 'Torrance'
);
-- Kelly School of Irish Dance, Torrance: Torrance, California (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance', 'kelly-school-of-irish-dance-redondo-beach', 'Redondo Beach', 'California', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance' and city = 'Redondo Beach'
);
-- Kelly School of Irish Dance, Redondo Beach: Redondo Beach, California (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kennelly School of Irish Dance', 'kennelly-school-of-irish-dance-san-francisco', 'San Francisco', 'California', 'United States', 'https://www.kennellyirishdance.com',
  '2700 45th Ave', null, 37.736175, -122.503081, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kennelly School of Irish Dance' and city = 'San Francisco'
);
-- Kennelly School of Irish Dance, San Francisco: 2700 45TH AVE, SAN FRANCISCO, CA, 94116 — IDTANA; United Irish Cultural Center; no ZIP published; old 1446 12th Ave studio closed, not used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kennelly School of Irish Dance', 'kennelly-school-of-irish-dance-burlingame', 'Burlingame', 'California', 'United States', 'https://www.kennellyirishdance.com',
  '850 Burlingame Ave', null, 37.581862, -122.342456, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kennelly School of Irish Dance' and city = 'Burlingame'
);
-- Kennelly School of Irish Dance, Burlingame: 850 BURLINGAME AVE, BURLINGAME, CA, 94010 — IDTANA; Burlingame Recreation Center; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kennelly School of Irish Dance', 'kennelly-school-of-irish-dance-roseville', 'Roseville', 'California', 'United States', 'https://www.kennellyirishdance.com',
  '1220 Melody Ln', null, 38.723396, -121.292815, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kennelly School of Irish Dance' and city = 'Roseville'
);
-- Kennelly School of Irish Dance, Roseville: 1220 MELODY LN, ROSEVILLE, CA, 95678 — IDTANA; Royal Stage Performing and Visual Arts; no ZIP published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kennelly School of Irish Dance', 'kennelly-school-of-irish-dance-sacramento', 'Sacramento', 'California', 'United States', 'https://www.kennellyirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kennelly School of Irish Dance' and city = 'Sacramento'
);
-- Kennelly School of Irish Dance, Sacramento: Sacramento, California (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Malone Academy of Irish Dance', 'malone-academy-of-irish-dance-san-diego', 'San Diego', 'California', 'United States', 'https://maloneacademy.net',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Malone Academy of Irish Dance' and city = 'San Diego'
);
-- Malone Academy of Irish Dance, San Diego: San Diego, California (city-only — no street address published) — IDTANA inquire for studio locations; own site live

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGrath Irish Dancers', 'mcgrath-irish-dancers-dublin', 'Dublin', 'California', 'United States', 'https://www.mcgrathirishdancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGrath Irish Dancers' and city = 'Dublin'
);
-- McGrath Irish Dancers, Dublin: Dublin, California (city-only — no street address published) — IDTANA; distinct from seeded McGrath Morgan (Morgan Hill); IDTANA street 7528 Corrinne St has no city/ZIP - not attached

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGrath Irish Dancers', 'mcgrath-irish-dancers-pleasanton', 'Pleasanton', 'California', 'United States', 'https://www.mcgrathirishdancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGrath Irish Dancers' and city = 'Pleasanton'
);
-- McGrath Irish Dancers, Pleasanton: Pleasanton, California (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGrath Irish Dancers', 'mcgrath-irish-dancers-castro-valley', 'Castro Valley', 'California', 'United States', 'https://www.mcgrathirishdancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGrath Irish Dancers' and city = 'Castro Valley'
);
-- McGrath Irish Dancers, Castro Valley: Castro Valley, California (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGrath Irish Dancers', 'mcgrath-irish-dancers-hayward', 'Hayward', 'California', 'United States', 'https://www.mcgrathirishdancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGrath Irish Dancers' and city = 'Hayward'
);
-- McGrath Irish Dancers, Hayward: Hayward, California (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGrath Irish Dancers', 'mcgrath-irish-dancers-fremont', 'Fremont', 'California', 'United States', 'https://www.mcgrathirishdancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGrath Irish Dancers' and city = 'Fremont'
);
-- McGrath Irish Dancers, Fremont: Fremont, California (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murphy Irish Dancers', 'murphy-irish-dancers-san-francisco', 'San Francisco', 'California', 'United States', 'https://murphyirishdancerssf.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murphy Irish Dancers' and city = 'San Francisco'
);
-- Murphy Irish Dancers, San Francisco: San Francisco, California (city-only — no street address published) — IDTANA inquire for address; own site live; founded 1963

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murphy Irish Dancers', 'murphy-irish-dancers-san-mateo', 'San Mateo', 'California', 'United States', 'https://murphyirishdancerssf.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murphy Irish Dancers' and city = 'San Mateo'
);
-- Murphy Irish Dancers, San Mateo: San Mateo, California (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murphy Irish Dancers', 'murphy-irish-dancers-san-carlos', 'San Carlos', 'California', 'United States', 'https://murphyirishdancerssf.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murphy Irish Dancers' and city = 'San Carlos'
);
-- Murphy Irish Dancers, San Carlos: San Carlos, California (city-only — no street address published) — IDTANA; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Connor Kennedy Academy', 'oconnor-kennedy-academy-encino', 'Encino', 'California', 'United States', 'https://www.oconnorkennedy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Connor Kennedy Academy' and city = 'Encino'
);
-- O'Connor Kennedy Academy, Encino: Encino, California (city-only — no street address published) — IDTANA inquire; counties only; own site live

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Connor Kennedy Academy', 'oconnor-kennedy-academy-laguna-hills', 'Laguna Hills', 'California', 'United States', 'https://www.oconnorkennedy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Connor Kennedy Academy' and city = 'Laguna Hills'
);
-- O'Connor Kennedy Academy, Laguna Hills: Laguna Hills, California (city-only — no street address published) — Own site location; no address (listing 23352 Peralta Dr not an allowed source)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Connor Kennedy Academy', 'oconnor-kennedy-academy-oceanside', 'Oceanside', 'California', 'United States', 'https://www.oconnorkennedy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Connor Kennedy Academy' and city = 'Oceanside'
);
-- O'Connor Kennedy Academy, Oceanside: Oceanside, California (city-only — no street address published) — Own site location; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Connor Kennedy Academy', 'oconnor-kennedy-academy-riverside', 'Riverside', 'California', 'United States', 'https://www.oconnorkennedy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Connor Kennedy Academy' and city = 'Riverside'
);
-- O'Connor Kennedy Academy, Riverside: Riverside, California (city-only — no street address published) — Own site location; no address (listing 2050 E Cadena Dr not an allowed source)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Connor Kennedy Academy', 'oconnor-kennedy-academy-san-francisco', 'San Francisco', 'California', 'United States', 'https://www.oconnorkennedy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Connor Kennedy Academy' and city = 'San Francisco'
);
-- O'Connor Kennedy Academy, San Francisco: San Francisco, California (city-only — no street address published) — Own site location; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Pride of Erin Ceili Dancers', 'pride-of-erin-ceili-dancers-san-diego', 'San Diego', 'California', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Pride of Erin Ceili Dancers' and city = 'San Diego'
);
-- Pride of Erin Ceili Dancers, San Diego: San Diego, California (city-only — no street address published) — FLAG: verified operating weekly ceil class (Comhaltas San Diego, Casa del Prado) but a social ceil group, not a CLRG step-dance school - parent decision whether to keep

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rose Academy of Irish Dance', 'rose-academy-of-irish-dance-san-diego', 'San Diego', 'California', 'United States', 'https://www.roseacademyofirishdance.com',
  '10125 Azuaga St', '92129', 32.959630, -117.107268, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rose Academy of Irish Dance' and city = 'San Diego'
);
-- Rose Academy of Irish Dance, San Diego: 10125 AZUAGA ST, SAN DIEGO, CA, 92129 — IDTANA; Rancho Penasquitos; not Rose Courtney (CO)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Daryl Rose', 'scoil-rince-daryl-rose-simi-valley', 'Simi Valley', 'California', 'United States', 'https://srdririshdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Daryl Rose' and city = 'Simi Valley'
);
-- Scoil Rince Daryl Rose, Simi Valley: Simi Valley, California (city-only — no street address published) — IDTANA inquire; Ventura County; own site live

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tamora School of Irish Dance', 'tamora-school-of-irish-dance-san-dimas', 'San Dimas', 'California', 'United States', 'https://www.tamoradance.com',
  '297 W Allen Ave', '91773', 34.117605, -117.809119, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Tamora School of Irish Dance' and city = 'San Dimas'
);
-- Tamora School of Irish Dance, San Dimas: 297 W ALLEN AVE, SAN DIMAS, CA, 91773 — IDTANA + own site

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Thistle Academy of Irish Dance', 'thistle-academy-of-irish-dance-orange', 'Orange', 'California', 'United States', 'https://thistleirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Thistle Academy of Irish Dance' and city = 'Orange'
);
-- Thistle Academy of Irish Dance, Orange: Orange, California (city-only — no street address published) — IDTANA inquire; own site live; Orange County

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Whelan Academy of Irish Dance', 'whelan-academy-of-irish-dance-san-francisco', 'San Francisco', 'California', 'United States', null,
  '1612 Noriega St', '94116', 37.754100, -122.480949, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Whelan Academy of Irish Dance' and city = 'San Francisco'
);
-- Whelan Academy of Irish Dance, San Francisco: 1612 NORIEGA ST, SAN FRANCISCO, CA, 94122 — IDTANA; Instagram only, no standalone website; est. 1995

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Claddagh Dance Company (Claddagh Western U.S.)', 'claddagh-dance-company-claddagh-western-u-s-manhattan-beach', 'Manhattan Beach', 'California', 'United States', 'https://www.claddaghdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Claddagh Dance Company (Claddagh Western U.S.)' and city = 'Manhattan Beach'
);
-- Claddagh Dance Company (Claddagh Western U.S.), Manhattan Beach: Manhattan Beach, California (city-only — no street address published) — IDTANA; additional location of seeded Claddagh (Ventura only); own site: many locations, South Bay + Ventura

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clan Rince School of Irish Dance', 'clan-rince-school-of-irish-dance-san-marcos', 'San Marcos', 'California', 'United States', 'https://www.clanrince.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clan Rince School of Irish Dance' and city = 'San Marcos'
);
-- Clan Rince School of Irish Dance, San Marcos: San Marcos, California (city-only — no street address published) — IDTANA + own site (two locations: Kensington/San Diego + San Marcos); no street addresses

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cleary Irish Dance', 'cleary-irish-dance-montrose', 'Montrose', 'California', 'United States', null,
  '3730 Park Place', '91020', 34.203551, -118.222992, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Cleary Irish Dance' and city = 'Montrose'
);
-- Cleary Irish Dance, Montrose: 3730 PARK PL, MONTROSE, CA, 91020 — IDTANA; http-only site; additional location of seeded Cleary (Burbank only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance, LA', 'mcnulty-school-of-irish-dance-la-rolling-hills-estates', 'Rolling Hills Estates', 'California', 'United States', 'https://www.mcnultyirishdancers.com',
  '550 Deep Valley Dr Unit 241', '90274', 33.772404, -118.374456, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance, LA' and city = 'Rolling Hills Estates'
);
-- McNulty School of Irish Dance, LA, Rolling Hills Estates: 550 DEEP VALLEY DR, ROLLING HILLS ESTATES, CA, 90274 — IDTANA; additional location of seeded McNulty LA

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance, LA', 'mcnulty-school-of-irish-dance-la-costa-mesa', 'Costa Mesa', 'California', 'United States', 'https://www.mcnultyirishdancers.com',
  '2221 Harbor Blvd', '92627', 33.654318, -117.919170, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance, LA' and city = 'Costa Mesa'
);
-- McNulty School of Irish Dance, LA, Costa Mesa: 2221 HARBOR BLVD, COSTA MESA, CA, 92627 — IDTANA; additional location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance, LA', 'mcnulty-school-of-irish-dance-la-lomita', 'Lomita', 'California', 'United States', 'https://www.mcnultyirishdancers.com',
  '24817 S Western Ave', '90717', 33.799287, -118.307832, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance, LA' and city = 'Lomita'
);
-- McNulty School of Irish Dance, LA, Lomita: 24817 S WESTERN AVE, LOMITA, CA, 90717 — IDTANA; additional location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Steps School of Irish Dance', 'celtic-steps-school-of-irish-dance-littleton', 'Littleton', 'Colorado', 'United States', 'https://www.celticsteps.com',
  '300 E Mineral Ave Suite 5', '80122', 39.573431, -104.986155, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Celtic Steps School of Irish Dance' and city = 'Littleton'
);
-- Celtic Steps School of Irish Dance, Littleton: 300 E MINERAL AVE, LITTLETON, CO, 80122 — Own site; the Denver location, classes at Center Stage Starz, Littleton

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Steps School of Irish Dance', 'celtic-steps-school-of-irish-dance-colorado-springs', 'Colorado Springs', 'Colorado', 'United States', 'https://www.celticsteps.com',
  '4701 Centennial Blvd', '80919', 38.900395, -104.852393, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Celtic Steps School of Irish Dance' and city = 'Colorado Springs'
);
-- Celtic Steps School of Irish Dance, Colorado Springs: 4701 CENTENNIAL BLVD, COLORADO SPRINGS, CO, 80919 — Own site; schedule says 4701, duplicated contact block says 4705 - 4701 used, verify number

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mountain Eire Irish Dance', 'mountain-eire-irish-dance-woodland-park', 'Woodland Park', 'Colorado', 'United States', 'https://mountaineire.org',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mountain Eire Irish Dance' and city = 'Woodland Park'
);
-- Mountain Eire Irish Dance, Woodland Park: Woodland Park, Colorado (city-only — no street address published) — IDTANA inquire; own site live and operating; FLAG: one directory listing marks it Permanently Closed - listing looks stale, live site + IDTANA win

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers (McTeggart, Western U.S. Region)', 'mcteggart-irish-dancers-mcteggart-western-u-s-region-englewood', 'Englewood', 'Colorado', 'United States', 'https://www.mcteggart.org',
  '3800 S Jason St', '80110', 39.647555, -104.999335, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers (McTeggart, Western U.S. Region)' and city = 'Englewood'
);
-- McTeggart Irish Dancers (McTeggart, Western U.S. Region), Englewood: 3800 S JASON ST, ENGLEWOOD, CO, 80110 — IDTANA; Omni Ballroom; additional location of seeded McTeggart CO

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers (McTeggart, Western U.S. Region)', 'mcteggart-irish-dancers-mcteggart-western-u-s-region-golden', 'Golden', 'Colorado', 'United States', 'https://www.mcteggart.org',
  '2001 Youngfield St Suite G', '80401', 39.747341, -105.142453, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers (McTeggart, Western U.S. Region)' and city = 'Golden'
);
-- McTeggart Irish Dancers (McTeggart, Western U.S. Region), Golden: 2001 YOUNGFIELD ST, GOLDEN, CO, 80401 — IDTANA; RISE Dance Co., Denver West; additional location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers (McTeggart, Western U.S. Region)', 'mcteggart-irish-dancers-mcteggart-western-u-s-region-loveland', 'Loveland', 'Colorado', 'United States', 'https://www.mcteggart.org',
  '440 N Lincoln Ave #5618', '80537', 40.395875, -105.073126, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers (McTeggart, Western U.S. Region)' and city = 'Loveland'
);
-- McTeggart Irish Dancers (McTeggart, Western U.S. Region), Loveland: 440 N LINCOLN AVE, LOVELAND, CO, 80537 — IDTANA; Loveland Dance Academy; additional location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers (McTeggart, Western U.S. Region)', 'mcteggart-irish-dancers-mcteggart-western-u-s-region-greeley', 'Greeley', 'Colorado', 'United States', 'https://www.mcteggart.org',
  '813 8th St', '80631', 40.424929, -104.691072, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers (McTeggart, Western U.S. Region)' and city = 'Greeley'
);
-- McTeggart Irish Dancers (McTeggart, Western U.S. Region), Greeley: 813 8TH ST, GREELEY, CO, 80631 — IDTANA; Conservatory Dance Studio; additional location

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kavanagh Porter Academy of Irish Dance', 'kavanagh-porter-academy-of-irish-dance-boise', 'Boise', 'Idaho', 'United States', 'https://kavanaghporteracademy.com/',
  '5579 W Overland Rd', '83705', 43.589821, -116.250909, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Kavanagh Porter Academy of Irish Dance' and city = 'Boise'
);
-- Kavanagh Porter Academy of Irish Dance, Boise: 5579 OVERLAND RD, BOISE, ID, 83705 — IDTANA; https verified 200 by Western US report

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Killarney Irish Dance Company', 'killarney-irish-dance-company-boise', 'Boise', 'Idaho', 'United States', 'https://www.killarneydance.com',
  '3355 N Five Mile Rd', null, 43.635226, -116.314410, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Killarney Irish Dance Company' and city = 'Boise'
);
-- Killarney Irish Dance Company, Boise: 3355 N FIVE MILE RD, BOISE, ID, 83713 — IDTANA; no ZIP published; not Irish Dance Idaho (independent, not IDTANA)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brimhall Academy of Irish Dance', 'brimhall-academy-of-irish-dance-tigard', 'Tigard', 'Oregon', 'United States', 'https://www.brimhallacademy.com',
  '13727 SW Pacific Hwy Suite 300', '97223', 45.420778, -122.785343, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Brimhall Academy of Irish Dance' and city = 'Tigard'
);
-- Brimhall Academy of Irish Dance, Tigard: 13727 SW PACIFIC HWY, TIGARD, OR, 97223 — IDTANA; main studio; mailing PO Box 2587 Oregon City not used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brimhall Academy of Irish Dance', 'brimhall-academy-of-irish-dance-albany', 'Albany', 'Oregon', 'United States', 'https://www.brimhallacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brimhall Academy of Irish Dance' and city = 'Albany'
);
-- Brimhall Academy of Irish Dance, Albany: Albany, Oregon (city-only — no street address published) — Own site lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brimhall Academy of Irish Dance', 'brimhall-academy-of-irish-dance-redmond', 'Redmond', 'Oregon', 'United States', 'https://www.brimhallacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brimhall Academy of Irish Dance' and city = 'Redmond'
);
-- Brimhall Academy of Irish Dance, Redmond: Redmond, Oregon (city-only — no street address published) — Own site lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kyne Irish Dance Company', 'kyne-irish-dance-company-portland', 'Portland', 'Oregon', 'United States', 'https://www.kyneirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kyne Irish Dance Company' and city = 'Portland'
);
-- Kyne Irish Dance Company, Portland: Portland, Oregon (city-only — no street address published) — IDTANA inquire; brand-new school est. 2026; classes Portland + Sherwood

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kyne Irish Dance Company', 'kyne-irish-dance-company-sherwood', 'Sherwood', 'Oregon', 'United States', 'https://www.kyneirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kyne Irish Dance Company' and city = 'Sherwood'
);
-- Kyne Irish Dance Company, Sherwood: Sherwood, Oregon (city-only — no street address published) — Own site lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Irish Dance Oregon', 'murray-irish-dance-oregon-beaverton', 'Beaverton', 'Oregon', 'United States', 'https://www.murrayirishdance.com',
  '9575 SW Beaverton Hillsdale Hwy Suite B10', '97005', 45.486564, -122.775497, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Murray Irish Dance Oregon' and city = 'Beaverton'
);
-- Murray Irish Dance Oregon, Beaverton: 9575 SW BEAVERTON-HILLSDALE HWY, BEAVERTON, OR, 97005 — IDTANA; listing shows different address 8785 - IDTANA 9575 used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Irish Dance Oregon', 'murray-irish-dance-oregon-portland', 'Portland', 'Oregon', 'United States', 'https://www.murrayirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murray Irish Dance Oregon' and city = 'Portland'
);
-- Murray Irish Dance Oregon, Portland: Portland, Oregon (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Irish Dance Oregon', 'murray-irish-dance-oregon-hillsboro', 'Hillsboro', 'Oregon', 'United States', 'https://www.murrayirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murray Irish Dance Oregon' and city = 'Hillsboro'
);
-- Murray Irish Dance Oregon, Hillsboro: Hillsboro, Oregon (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Irish Dance Oregon', 'murray-irish-dance-oregon-tigard', 'Tigard', 'Oregon', 'United States', 'https://www.murrayirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murray Irish Dance Oregon' and city = 'Tigard'
);
-- Murray Irish Dance Oregon, Tigard: Tigard, Oregon (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Irish Dance Oregon', 'murray-irish-dance-oregon-tualatin', 'Tualatin', 'Oregon', 'United States', 'https://www.murrayirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murray Irish Dance Oregon' and city = 'Tualatin'
);
-- Murray Irish Dance Oregon, Tualatin: Tualatin, Oregon (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Irish Dance Oregon', 'murray-irish-dance-oregon-lake-oswego', 'Lake Oswego', 'Oregon', 'United States', 'https://www.murrayirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murray Irish Dance Oregon' and city = 'Lake Oswego'
);
-- Murray Irish Dance Oregon, Lake Oswego: Lake Oswego, Oregon (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murray Irish Dance Oregon', 'murray-irish-dance-oregon-sherwood', 'Sherwood', 'Oregon', 'United States', 'https://www.murrayirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Murray Irish Dance Oregon' and city = 'Sherwood'
);
-- Murray Irish Dance Oregon, Sherwood: Sherwood, Oregon (city-only — no street address published) — IDTANA lists city only

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harp Irish Dance Company', 'harp-irish-dance-company-american-fork', 'American Fork', 'Utah', 'United States', 'https://www.harpirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Harp Irish Dance Company' and city = 'American Fork'
);
-- Harp Irish Dance Company, American Fork: American Fork, Utah (city-only — no street address published) — IDTANA inquire; own site live; locations American Fork, Saratoga Springs, Payson

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harp Irish Dance Company', 'harp-irish-dance-company-saratoga-springs', 'Saratoga Springs', 'Utah', 'United States', 'https://www.harpirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Harp Irish Dance Company' and city = 'Saratoga Springs'
);
-- Harp Irish Dance Company, Saratoga Springs: Saratoga Springs, Utah (city-only — no street address published) — Own site; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harp Irish Dance Company', 'harp-irish-dance-company-payson', 'Payson', 'Utah', 'United States', 'https://www.harpirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Harp Irish Dance Company' and city = 'Payson'
);
-- Harp Irish Dance Company, Payson: Payson, Utah (city-only — no street address published) — Own site; no address

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shelley School of Irish Dance', 'shelley-school-of-irish-dance-cedar-hills', 'Cedar Hills', 'Utah', 'United States', 'https://www.shelleyirishdance.com',
  '9804 N Canyon Rd', '84062', 40.408621, -111.750343, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Shelley School of Irish Dance' and city = 'Cedar Hills'
);
-- Shelley School of Irish Dance, Cedar Hills: 9804 N CANYON RD, CEDAR HILLS, UT, 84062 — IDTANA; listing places in Pleasant Grove (border) - IDTANA says Cedar Hills, used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shelley School of Irish Dance', 'shelley-school-of-irish-dance-orem', 'Orem', 'Utah', 'United States', 'https://www.shelleyirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Shelley School of Irish Dance' and city = 'Orem'
);
-- Shelley School of Irish Dance, Orem: Orem, Utah (city-only — no street address published) — IDTANA lists city only; own site also mentions Provo - IDTANA says Cedar Hills & Orem, used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Smith Irish Dance', 'smith-irish-dance-lehi', 'Lehi', 'Utah', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Smith Irish Dance' and city = 'Lehi'
);
-- Smith Irish Dance, Lehi: Lehi, Utah (city-only — no street address published) — FLAG - thinnest verification in list (a): IDTANA-listed + listings (Active, Lehi 84043, 2025 social post), site http-only and unreachable over https, no own-site content surfaced - hold-or-seed decision for parent

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley Prendergast School of Irish Dance', 'haley-prendergast-school-of-irish-dance-gig-harbor', 'Gig Harbor', 'Washington', 'United States', 'https://www.hpirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haley Prendergast School of Irish Dance' and city = 'Gig Harbor'
);
-- Haley Prendergast School of Irish Dance, Gig Harbor: Gig Harbor, Washington (city-only — no street address published) — IDTANA inquire; own site live; founded 1996 as Scoil Rince Slieveloughane, renamed 2019

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley Prendergast School of Irish Dance', 'haley-prendergast-school-of-irish-dance-olympia', 'Olympia', 'Washington', 'United States', 'https://www.hpirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haley Prendergast School of Irish Dance' and city = 'Olympia'
);
-- Haley Prendergast School of Irish Dance, Olympia: Olympia, Washington (city-only — no street address published) — IDTANA inquire; no address (listing 2626 12th Ct SW Ste 5 not an allowed source)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley Prendergast School of Irish Dance', 'haley-prendergast-school-of-irish-dance-kirkland', 'Kirkland', 'Washington', 'United States', 'https://www.hpirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haley Prendergast School of Irish Dance' and city = 'Kirkland'
);
-- Haley Prendergast School of Irish Dance, Kirkland: Kirkland, Washington (city-only — no street address published) — IDTANA inquire; no address (listing 835 7th Ave not an allowed source)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Watt School of Irish Dance', 'watt-school-of-irish-dance-fort-st-john', 'Fort St John', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Watt School of Irish Dance' and city = 'Fort St John'
);
-- Watt School of Irish Dance, Fort St John: Fort St John, British Columbia (city-only — no street address published) — IDTANA; website wattirishdance.com returns 404; verified operating via 2025 Oireachtas + 2026 Brady Spring Feis + 2024 NAIDC

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Watt School of Irish Dance', 'watt-school-of-irish-dance-vancouver', 'Vancouver', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Watt School of Irish Dance' and city = 'Vancouver'
);
-- Watt School of Irish Dance, Vancouver: Vancouver, British Columbia (city-only — no street address published) — IDTANA Fort St John & Vancouver; same dead site; former Vancouver studio 1360 E 3rd Ave Permanently Closed (aggregator, not used)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McCormack School of Irish Dance', 'mccormack-school-of-irish-dance-sherwood-park', 'Sherwood Park', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McCormack School of Irish Dance' and city = 'Sherwood Park'
);
-- McCormack School of Irish Dance, Sherwood Park: Sherwood Park, Alberta (city-only — no street address published) — WCIDTA Alberta (Edmonton & Area); http-only site; verified operating via 2026 Brady Spring Feis programme; city Sherwood Park per Strathcona County listing, pending confirmation

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Mahoney', 'scoil-rince-mahoney-st-albert', 'St. Albert', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Mahoney' and city = 'St. Albert'
);
-- Scoil Rince Mahoney, St. Albert: St. Albert, Alberta (city-only — no street address published) — WCIDTA Alberta (Edmonton & Area); no website found; verified via 2026 Canadian Nationals + Brady Spring Feis; city St. Albert from business listing, not confirmed by allowed source

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Castilla School of Irish Dance', 'castilla-school-of-irish-dance-penticton', 'Penticton', 'British Columbia', 'Canada', null,
  '227-1475 Fairview Rd', null, 49.482793, -119.594578, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'Castilla School of Irish Dance' and city = 'Penticton'
);
-- Castilla School of Irish Dance, Penticton: Cannery Trade Centre, 1475, Fairview Road, Penticton, Regional District of Okanagan-Similkameen, British Columbia, V2A 7W5, Canada — IDTANA + WCIDTA + own site; Cannery Trade Centre; mailing 181 Wade Ave W V2A 1T7 is not the studio, not used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Connor School of Irish Dance, BC', 'oconnor-school-of-irish-dance-bc-north-vancouver', 'North Vancouver', 'British Columbia', 'Canada', 'https://www.irishdancevancouver.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Connor School of Irish Dance, BC' and city = 'North Vancouver'
);
-- O'Connor School of Irish Dance, BC, North Vancouver: North Vancouver, British Columbia (city-only — no street address published) — IDTANA + WCIDTA; Upper Lonsdale Queensbury & Parkgate; no street published; additional location of seeded O'Connor (Vancouver/Kitsilano)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine)', 'sionnaine-irish-dance-academy-dance-vancouver-sionnaine-maple-ridge', 'Maple Ridge', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine)' and city = 'Maple Ridge'
);
-- Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine), Maple Ridge: Maple Ridge, British Columbia (city-only — no street address published) — WCIDTA + own site (Tuesdays Maple Ridge); http-only site; no street published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine)', 'sionnaine-irish-dance-academy-dance-vancouver-sionnaine-abbotsford', 'Abbotsford', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine)' and city = 'Abbotsford'
);
-- Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine), Abbotsford: Abbotsford, British Columbia (city-only — no street address published) — WCIDTA + own site (Thursdays Abbotsford); no street published; no separate Vancouver row - Wed Vancouver classes likely at seeded Burnaby studio

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brenyo Irish Dance', 'brenyo-irish-dance-thorold', 'Thorold', 'Ontario', 'Canada', null,
  '136 Confederation Ave', null, 43.111923, -79.221909, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'Brenyo Irish Dance' and city = 'Thorold'
);
-- Brenyo Irish Dance, Thorold: Niagara Heights Church, 136, Confederation Avenue, Thorold, Niagara Region, Ontario, L2V 5A6, Canada — IDTANA inquire; Facebook place listing gives street, no postal; verified via NAIDC 2025 splits; Facebook only, no website

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Donnell School of Irish Dance', 'odonnell-school-of-irish-dance-whitby', 'Whitby', 'Ontario', 'Canada', 'https://www.odonnellirishdance.org/',
  '309 Beech St W', null, 43.886906, -78.948999, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'O''Donnell School of Irish Dance' and city = 'Whitby'
);
-- O'Donnell School of Irish Dance, Whitby: 309, Beech Street West, Whitby, Durham Region, Ontario, L1N 4J5, Canada [postal L1N 3B3 — not stored in postal_code column] — IDTANA + Ana-Maria's Dance Academy Whitby own site; serving Durham Region 47+ years

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'MacVoy School of Irish Dance', 'macvoy-school-of-irish-dance-mississauga', 'Mississauga', 'Ontario', 'Canada', 'https://macvoyirishdance.com/',
  '4120 Ridgeway Drive', null, 43.529854, -79.717577, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'MacVoy School of Irish Dance' and city = 'Mississauga'
);
-- MacVoy School of Irish Dance, Mississauga: 4120, Ridgeway Drive, Erin Mills, Mississauga, Peel Region, Ontario, L5L 5Y5, Canada — Own site; Irish Club of Mississauga; postal L5L 5S9 from third-party filing only - not used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'MacVoy School of Irish Dance', 'macvoy-school-of-irish-dance-pickering', 'Pickering', 'Ontario', 'Canada', 'https://macvoyirishdance.com/',
  '1895 Clements Road', null, 43.826960, -79.054423, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'MacVoy School of Irish Dance' and city = 'Pickering'
);
-- MacVoy School of Irish Dance, Pickering: 1895, Clements Road, Pickering, Durham Region, Ontario, L1W 3S3, Canada — Own site; no postal published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Graham School of Irish Dance', 'graham-school-of-irish-dance-mississauga', 'Mississauga', 'Ontario', 'Canada', 'https://grahamirishdancers.com/',
  '2-2570 Haines Rd', null, 43.599021, -79.598375, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'Graham School of Irish Dance' and city = 'Mississauga'
);
-- Graham School of Irish Dance, Mississauga: Haines Road, Applewood, Mississauga, Peel Region, Ontario, L4Y 4B2, Canada — Own site schedule; TDS Dance Space; no postal published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Graham School of Irish Dance', 'graham-school-of-irish-dance-milton', 'Milton', 'Ontario', 'Canada', 'https://grahamirishdancers.com/',
  '820 Nipissing Rd', null, 43.522057, -79.864165, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'Graham School of Irish Dance' and city = 'Milton'
);
-- Graham School of Irish Dance, Milton: 820, Nipissing Road, Milton, Halton Region, Ontario, L9T 4Z9, Canada — Own site schedule; Dance Elite Studios; no postal published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Graham School of Irish Dance', 'graham-school-of-irish-dance-hamilton', 'Hamilton', 'Ontario', 'Canada', 'https://grahamirishdancers.com/',
  '30 Anchor Rd, Unit #6', null, 43.192884, -79.823597, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'Graham School of Irish Dance' and city = 'Hamilton'
);
-- Graham School of Irish Dance, Hamilton: Anchor Road, North Hannon, Hamilton, Ontario, L8W 3R2, Canada — Own site schedule; Dreamlight Studio 2; no postal published

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Miller School of Irish Dance', 'miller-school-of-irish-dance-barrie', 'Barrie', 'Ontario', 'Canada', 'https://www.milleririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Miller School of Irish Dance' and city = 'Barrie'
);
-- Miller School of Irish Dance, Barrie: Barrie, Ontario (city-only — no street address published) — Own site cities Barrie/Markdale/Orangeville; IDTANA address 268 Edenbrook Hill Dr is a Brampton street and looks stale - NOT used

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Miller School of Irish Dance', 'miller-school-of-irish-dance-markdale', 'Markdale', 'Ontario', 'Canada', 'https://www.milleririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Miller School of Irish Dance' and city = 'Markdale'
);
-- Miller School of Irish Dance, Markdale: Markdale, Ontario (city-only — no street address published) — Own site; no street found for current locations

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Miller School of Irish Dance', 'miller-school-of-irish-dance-orangeville', 'Orangeville', 'Ontario', 'Canada', 'https://www.milleririshdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Miller School of Irish Dance' and city = 'Orangeville'
);
-- Miller School of Irish Dance, Orangeville: Orangeville, Ontario (city-only — no street address published) — Own site; no street found for current locations

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Fainne Chladach', 'scoil-rince-fainne-chladach-toronto', 'Toronto', 'Ontario', 'Canada', 'https://srfcirishdance.com/',
  '310 Danforth Avenue', null, 43.677394, -79.353475, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Fainne Chladach' and city = 'Toronto'
);
-- Scoil Rince Fainne Chladach, Toronto: 310, Danforth Avenue, North Riverdale, Toronto—Danforth, Toronto, Ontario, M4K 1N7, Canada [postal M4K 1N6 — not stored in postal_code column] — Own site; NAIDC 2026 as SRFC; NOT the same as seeded Claddagh Toronto (probable split/rebrand dispute - flag for coordinator)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Moran Academy of Irish Dancing', 'moran-academy-of-irish-dancing-deux-montagnes', 'Deux-Montagnes', 'Quebec', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Moran Academy of Irish Dancing' and city = 'Deux-Montagnes'
);
-- Moran Academy of Irish Dancing, Deux-Montagnes: Deux-Montagnes, Quebec (city-only — no street address published) — IDTANA inquire; Facebook only; city corroborated by Feisworx + 2011 community newsletter + 2016 Rose of Tralee profile; NAIDC 2025 splits

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Young Academy of Irish Dance', 'young-academy-of-irish-dance-montreal', 'Montreal', 'Quebec', 'Canada', 'https://youngacademyirishdance.square.site/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Young Academy of Irish Dance' and city = 'Montreal'
);
-- Young Academy of Irish Dance, Montreal: Montreal, Quebec (city-only — no street address published) — FLAG - city unresolved: IDTANA tags Quebec, Montreal-area evidence (founded 2009, four Montreal locations, NDG parish profile Sep 2025) conflicts with business listing pinning it to Carleton North NB - seeded as Montreal per IDTANA, confirm before relying on city

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tir na nOg Dance Studio', 'tir-na-nog-dance-studio-kentville', 'Kentville', 'Nova Scotia', 'Canada', 'https://valleyirish.com/',
  '326 Main St', null, 45.076481, -64.494106, 'street', 'nominatim'
where not exists (
  select 1 from public.schools
  where name = 'Tir na nOg Dance Studio' and city = 'Kentville'
);
-- Tir na nOg Dance Studio, Kentville: ENVE Hair, 326, Main Street, Kentville, Town of Kentville, Kings County, Nova Scotia, B4N 4H7, Canada — IDTANA; no postal published; live registration Sep 2026-Jun 2027
