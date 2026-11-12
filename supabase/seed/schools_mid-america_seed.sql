-- School directory seed — Mid-America Region (IL, IN, MI, WI, MN, IA, MO, KS, NE, KY): 96 locations
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Every row below was verified 2026-11-12 from IDTANA Find a School / state
-- pages, Planxti school pages, the FeisWorx school list (name universe), and
-- each school's own website / handbook / brochure. No address was invented.
-- Street address + ZIP are shown ONLY where the school itself published them
-- (own website, handbook/brochure PDF, or class-locations page); addresses
-- seen only in third-party directory/place listings were NOT used as street
-- addresses — those rows are city-only. See
-- research_notes/irish-dance-schools-all-us/mid-america.md for sources and
-- the full "Unverified / partial" list — nothing from that section is seeded
-- here. Ohio is excluded (Ohio seed). North Dakota and South Dakota have no
-- verified school (0 rows each).
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
--
-- Counts: IL 39, IN 3, MI 14, WI 11, MN 11, IA 3, MO 6, KS 4, NE 1, KY 4
-- (96 total; the research file lists 97 verified — 1 row was dropped as a
-- duplicate of the Ohio seed, see below). Street precision 20, city
-- precision 76.
--
-- Completeness (from the research file): IL partial (39) — the biggest gaps
-- are McNulty (14–16 locations, all city-only; the true current count is
-- unresolved) and several Chicago schools. IN likely incomplete (3) — no
-- school verified in South Bend / Mishawaka, Bloomington, or Evansville. MI
-- partial (14) — nothing verified in the Upper Peninsula or Traverse City /
-- northern Michigan beyond Cadillac. WI partial (11) — nothing verified in
-- Green Bay, Appleton, La Crosse, or Eau Claire. MN partial (11). IA partial
-- (3) — nothing verified in Des Moines, Cedar Rapids, Davenport, or Ames. MO
-- partial (6) — nothing verified in Springfield. KS partial (4) — beyond the
-- Kansas City metro likely under-covered. NE partial (1) — needs a dedicated
-- check. KY appears near-complete for the competitive schools (4).
-- CRN / non-CLRG schools are not systematically covered by the IDTANA /
-- IDTAMA sources, so a CRN school in any of these states could be missing
-- (see canada-open-platform.md for the CRN schools that were found).
--
-- website_url is NULL for 54 rows: 39 because the schools' sites are
-- http-only as published (McNulty School, Harling School, Dennehy School,
-- Mullane Godley Academy, O'Hare School IL, Champagne Academy, Clarkson
-- School, Dowds Irish Dance Academy, O'Riada Manning Academy, Bluegrass
-- Ceili Academy, McClanahan School, Beglan Academy, Cashel Dennehy School,
-- O'Shea Irish Dance, Mactír Academy, Chicago Irish Dance Studio, Saol
-- Academy, and others) and 15 because no website was found (Shamrock
-- Academy Champaign, Moran School, McCartney Irish Dance, O'Kennedy Holland
-- Ann Arbor, Milwaukee Irish Dance Academy, McNamara McCarthy School, Hudson
-- Irish Dance Academy, Eilís Academy, Rince na Chroi, Rince na Gréine,
-- Green Fire Irish Dancers, North Star Irish Dance, The Clark Academy,
-- Meghan Torno School). Bailey-Murray Academy's site returned HTTP 403 to
-- automated checks but loaded live in the browser fetch on 2026-11-12, so
-- its https URL is kept. Every other https URL kept here was checked live on
-- 2026-11-12 (HTTP 200).
--
-- Coordinates: US Census Geocoder (Public_AR_Current benchmark) for street
-- addresses. City-only rows have NO coordinates, with one exception group:
-- the 9 Trinity Academy rows have a school-published venue ZIP but no
-- numbered street address, so they use the ZIP centroid from Zippopotam.us
-- (geo_precision 'city', geo_source 'zippopotam'). Every other city-only row
-- has no verified ZIP, and the Census Geocoder cannot resolve a bare
-- "City, ST" (tested — it returns No_Match), so those rows keep
-- latitude/longitude/geo_precision/geo_source NULL rather than invented
-- coordinates; the schools remain listed and searchable by city.
-- Street addresses that failed to geocode: Glencastle Irish Dancers, New
-- Berlin WI, first returned a Census "Tie" and then matched at street
-- precision once the suite number was dropped (5000 Towne Dr, New Berlin WI
-- 53151 — the matched address is in the row comment). Bluegrass Ceili
-- Academy, Lexington KY (522 Patterson St), did not match Census and has no
-- verified ZIP, so it is kept as published with no coordinates. Sheila Healy
-- Academy, Glenview IL, is seeded at the studio address its site gives
-- (1719 Chestnut Ave, 60025); the site footer also shows 1886 Johns Dr,
-- Glenview — one of the two may be a former address, not resolved.
--
-- Dropped as a duplicate of the Ohio seed (schools_ohio_seed.sql):
-- Blackbird Academy of Irish Dance, Tinley Park IL (Ohio seed has Blackbird
-- Academy, Tinley Park). Nothing else in this file duplicates the Ohio seed.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists, so the file is safe to re-run. Status is 'unclaimed'
-- (default) — these listings have not been claimed by the schools.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Chicago–Lakeview', 'trinity-academy-of-irish-dance-chicago-lakeview', 'Chicago', 'Illinois', 'United States', 'https://www.trinityirishdance.com/',
  null, '60657', 41.939900, -87.652800, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Chicago–Lakeview' and city = 'Chicago'
);
-- Trinity Academy of Irish Dance — Chicago–Lakeview, Chicago: Chicago, IL 60657 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 60657 (Chicago, IL))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Chicago–Lincoln Park', 'trinity-academy-of-irish-dance-chicago-lincoln-park', 'Chicago', 'Illinois', 'United States', 'https://www.trinityirishdance.com/',
  null, '60642', 41.900800, -87.652800, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Chicago–Lincoln Park' and city = 'Chicago'
);
-- Trinity Academy of Irish Dance — Chicago–Lincoln Park, Chicago: Chicago, IL 60642 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 60642 (Chicago, IL))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Chicago–Northwest Side', 'trinity-academy-of-irish-dance-chicago-northwest-side', 'Chicago', 'Illinois', 'United States', 'https://www.trinityirishdance.com/',
  null, '60630', 41.969900, -87.760300, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Chicago–Northwest Side' and city = 'Chicago'
);
-- Trinity Academy of Irish Dance — Chicago–Northwest Side, Chicago: Chicago, IL 60630 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 60630 (Chicago, IL))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Elmhurst', 'trinity-academy-of-irish-dance-elmhurst', 'Elmhurst', 'Illinois', 'United States', 'https://www.trinityirishdance.com/',
  null, '60126', 41.892700, -87.941000, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Elmhurst' and city = 'Elmhurst'
);
-- Trinity Academy of Irish Dance — Elmhurst, Elmhurst: Elmhurst, IL 60126 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 60126 (Elmhurst, IL))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Palatine', 'trinity-academy-of-irish-dance-palatine', 'Palatine', 'Illinois', 'United States', 'https://www.trinityirishdance.com/',
  null, '60074', 42.145800, -88.023000, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Palatine' and city = 'Palatine'
);
-- Trinity Academy of Irish Dance — Palatine, Palatine: Palatine, IL 60074 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 60074 (Palatine, IL))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Western Springs', 'trinity-academy-of-irish-dance-western-springs', 'Western Springs', 'Illinois', 'United States', 'https://www.trinityirishdance.com/',
  null, '60558', 41.804900, -87.899500, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Western Springs' and city = 'Western Springs'
);
-- Trinity Academy of Irish Dance — Western Springs, Western Springs: Western Springs, IL 60558 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 60558 (Western Springs, IL))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-arlington-heights', 'Arlington Heights', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Arlington Heights'
);
-- McNulty School of Irish Dance, Arlington Heights: Arlington Heights, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-aurora', 'Aurora', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Aurora'
);
-- McNulty School of Irish Dance, Aurora: Aurora, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-bloomington', 'Bloomington', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Bloomington'
);
-- McNulty School of Irish Dance, Bloomington: Bloomington, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-chicago', 'Chicago', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Chicago'
);
-- McNulty School of Irish Dance, Chicago: Chicago, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-crystal-lake', 'Crystal Lake', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Crystal Lake'
);
-- McNulty School of Irish Dance, Crystal Lake: Crystal Lake, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-downers-grove', 'Downers Grove', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Downers Grove'
);
-- McNulty School of Irish Dance, Downers Grove: Downers Grove, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-glen-ellyn', 'Glen Ellyn', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Glen Ellyn'
);
-- McNulty School of Irish Dance, Glen Ellyn: Glen Ellyn, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-libertyville', 'Libertyville', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Libertyville'
);
-- McNulty School of Irish Dance, Libertyville: Libertyville, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-naperville', 'Naperville', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Naperville'
);
-- McNulty School of Irish Dance, Naperville: Naperville, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-niles', 'Niles', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Niles'
);
-- McNulty School of Irish Dance, Niles: Niles, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-palatine', 'Palatine', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Palatine'
);
-- McNulty School of Irish Dance, Palatine: Palatine, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-rockford', 'Rockford', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Rockford'
);
-- McNulty School of Irish Dance, Rockford: Rockford, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-villa-park', 'Villa Park', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Villa Park'
);
-- McNulty School of Irish Dance, Villa Park: Villa Park, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-westchester', 'Westchester', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Westchester'
);
-- McNulty School of Irish Dance, Westchester: Westchester, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harling School of Irish Dance', 'harling-school-of-irish-dance-countryside', 'Countryside', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Harling School of Irish Dance' and city = 'Countryside'
);
-- Harling School of Irish Dance, Countryside: Countryside, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sheila Healy Academy of Irish Dance', 'sheila-healy-academy-of-irish-dance-glenview', 'Glenview', 'Illinois', 'United States', 'https://www.sheilahealyirishdance.com/',
  '1719 Chestnut Ave', '60025', 42.087220, -87.799552, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Sheila Healy Academy of Irish Dance' and city = 'Glenview'
);
-- Sheila Healy Academy of Irish Dance, Glenview: 1719 CHESTNUT AVE, GLENVIEW, IL, 60025

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dennehy School of Irish Dance', 'dennehy-school-of-irish-dance-chicago', 'Chicago', 'Illinois', 'United States', null,
  '2555 W 111th St', '60655', 41.691690, -87.685565, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Dennehy School of Irish Dance' and city = 'Chicago'
);
-- Dennehy School of Irish Dance, Chicago: 2555 W 111TH ST, CHICAGO, IL, 60655

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Chicago Irish Dance Studio', 'chicago-irish-dance-studio-chicago', 'Chicago', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Chicago Irish Dance Studio' and city = 'Chicago'
);
-- Chicago Irish Dance Studio, Chicago: Chicago, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Fitzpatrick School of Irish Dance', 'fitzpatrick-school-of-irish-dance-lake-forest', 'Lake Forest', 'Illinois', 'United States', 'https://www.fitzpatrickschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Fitzpatrick School of Irish Dance' and city = 'Lake Forest'
);
-- Fitzpatrick School of Irish Dance, Lake Forest: Lake Forest, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Lavin-Cassidy School of Irish Dance', 'lavin-cassidy-school-of-irish-dance-worth', 'Worth', 'Illinois', 'United States', 'https://www.lavincassidy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Lavin-Cassidy School of Irish Dance' and city = 'Worth'
);
-- Lavin-Cassidy School of Irish Dance, Worth: Worth, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mullane Godley Academy', 'mullane-godley-academy-niles', 'Niles', 'Illinois', 'United States', null,
  '7021 N Milwaukee Ave', '60714', 42.009050, -87.798506, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Mullane Godley Academy' and city = 'Niles'
);
-- Mullane Godley Academy, Niles: 7021 N MILWAUKEE AVE, NILES, IL, 60714

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mullane Godley Academy — Lincoln Park', 'mullane-godley-academy-lincoln-park-chicago', 'Chicago', 'Illinois', 'United States', null,
  '1535 N Dayton St', '60642', 41.909574, -87.649386, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Mullane Godley Academy — Lincoln Park' and city = 'Chicago'
);
-- Mullane Godley Academy — Lincoln Park, Chicago: 1535 N DAYTON ST, CHICAGO, IL, 60642

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blackbird Academy of Irish Dance', 'blackbird-academy-of-irish-dance-evergreen-park', 'Evergreen Park', 'Illinois', 'United States', 'https://blackbirdacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Blackbird Academy of Irish Dance' and city = 'Evergreen Park'
);
-- Blackbird Academy of Irish Dance, Evergreen Park: Evergreen Park, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bentley Academy of Irish Dance', 'bentley-academy-of-irish-dance-forest-park', 'Forest Park', 'Illinois', 'United States', 'https://bentleyacademydance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bentley Academy of Irish Dance' and city = 'Forest Park'
);
-- Bentley Academy of Irish Dance, Forest Park: Forest Park, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bentley Academy of Irish Dance', 'bentley-academy-of-irish-dance-downers-grove', 'Downers Grove', 'Illinois', 'United States', 'https://bentleyacademydance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bentley Academy of Irish Dance' and city = 'Downers Grove'
);
-- Bentley Academy of Irish Dance, Downers Grove: Downers Grove, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bailey-Murray Academy', 'bailey-murray-academy-lemont', 'Lemont', 'Illinois', 'United States', 'https://baileymurrayacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bailey-Murray Academy' and city = 'Lemont'
);
-- Bailey-Murray Academy, Lemont: Lemont, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bailey-Murray Academy', 'bailey-murray-academy-geneva', 'Geneva', 'Illinois', 'United States', 'https://baileymurrayacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bailey-Murray Academy' and city = 'Geneva'
);
-- Bailey-Murray Academy, Geneva: Geneva, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bailey-Murray Academy', 'bailey-murray-academy-westmont', 'Westmont', 'Illinois', 'United States', 'https://baileymurrayacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bailey-Murray Academy' and city = 'Westmont'
);
-- Bailey-Murray Academy, Westmont: Westmont, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Saol Academy of Irish Dance', 'saol-academy-of-irish-dance-chicago', 'Chicago', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Saol Academy of Irish Dance' and city = 'Chicago'
);
-- Saol Academy of Irish Dance, Chicago: Chicago, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Hare School of Irish Dance', 'ohare-school-of-irish-dance-lake-bluff', 'Lake Bluff', 'Illinois', 'United States', null,
  '28835 N Herky Dr', '60044', 42.280436, -87.904048, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'O''Hare School of Irish Dance' and city = 'Lake Bluff'
);
-- O'Hare School of Irish Dance, Lake Bluff: 28835 N HERKY DR, LAKE BLUFF, IL, 60044

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shamrock Academy of Irish Dance', 'shamrock-academy-of-irish-dance-champaign', 'Champaign', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Shamrock Academy of Irish Dance' and city = 'Champaign'
);
-- Shamrock Academy of Irish Dance, Champaign: Champaign, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Neill Blake School of Dance', 'oneill-blake-school-of-dance-schaumburg', 'Schaumburg', 'Illinois', 'United States', 'https://www.facebook.com/100306225144220/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Neill Blake School of Dance' and city = 'Schaumburg'
);
-- O'Neill Blake School of Dance, Schaumburg: Schaumburg, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Champagne Academy of Irish Dance', 'champagne-academy-of-irish-dance-bishop-hill', 'Bishop Hill', 'Illinois', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Champagne Academy of Irish Dance' and city = 'Bishop Hill'
);
-- Champagne Academy of Irish Dance, Bishop Hill: Bishop Hill, IL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGovern Irish Dance', 'mcgovern-irish-dance-lafayette', 'Lafayette', 'Indiana', 'United States', 'https://www.mcgoverndance.org/',
  '638 North St', '47901', 40.421020, -86.890183, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGovern Irish Dance' and city = 'Lafayette'
);
-- McGovern Irish Dance, Lafayette: 638 NORTH ST, LAFAYETTE, IN, 47901

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGovern Irish Dance', 'mcgovern-irish-dance-fort-wayne', 'Fort Wayne', 'Indiana', 'United States', 'https://www.mcgoverndance.org/',
  '3320 N Clinton St', '46805', 41.106665, -85.138119, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGovern Irish Dance' and city = 'Fort Wayne'
);
-- McGovern Irish Dance, Fort Wayne: 3320 N CLINTON ST, FORT WAYNE, IN, 46805

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Richens/Timm Academy of Irish Dance', 'richens-timm-academy-of-irish-dance-indianapolis', 'Indianapolis', 'Indiana', 'United States', 'https://www.richenstimm.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Richens/Timm Academy of Irish Dance' and city = 'Indianapolis'
);
-- Richens/Timm Academy of Irish Dance, Indianapolis: Indianapolis, IN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardán Academy of Irish Dance', 'ardan-academy-of-irish-dance-livonia', 'Livonia', 'Michigan', 'United States', 'https://www.ardanacademy.com/',
  '9015 Iowa St', '48150', 42.357188, -83.355617, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ardán Academy of Irish Dance' and city = 'Livonia'
);
-- Ardán Academy of Irish Dance, Livonia: 9015 IOWA ST, LIVONIA, MI, 48150

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardán Academy of Irish Dance', 'ardan-academy-of-irish-dance-grand-rapids', 'Grand Rapids', 'Michigan', 'United States', 'https://www.ardanacademy.com/',
  '435 Diamond Ave NE', '49503', 42.971293, -85.644758, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ardán Academy of Irish Dance' and city = 'Grand Rapids'
);
-- Ardán Academy of Irish Dance, Grand Rapids: 435 DIAMOND AVE NE, GRAND RAPIDS, MI, 49503

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardán Academy of Irish Dance', 'ardan-academy-of-irish-dance-detroit', 'Detroit', 'Michigan', 'United States', 'https://www.ardanacademy.com/',
  '2068 Michigan Ave', '48216', 42.331434, -83.074509, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ardán Academy of Irish Dance' and city = 'Detroit'
);
-- Ardán Academy of Irish Dance, Detroit: 2068 MICHIGAN AVE, DETROIT, MI, 48216

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardán Academy of Irish Dance', 'ardan-academy-of-irish-dance-muskegon', 'Muskegon', 'Michigan', 'United States', 'https://www.ardanacademy.com/',
  '2330 Barclay St', '49441', 43.211097, -86.270532, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ardán Academy of Irish Dance' and city = 'Muskegon'
);
-- Ardán Academy of Irish Dance, Muskegon: 2330 BARCLAY ST, MUSKEGON, MI, 49441

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardán Academy of Irish Dance', 'ardan-academy-of-irish-dance-taylor', 'Taylor', 'Michigan', 'United States', 'https://www.ardanacademy.com/',
  '23857 Van Born Rd', '48180', 42.269103, -83.268518, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ardán Academy of Irish Dance' and city = 'Taylor'
);
-- Ardán Academy of Irish Dance, Taylor: 23857 VAN BORN RD, TAYLOR, MI, 48180

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardán Academy of Irish Dance', 'ardan-academy-of-irish-dance-redford', 'Redford', 'Michigan', 'United States', 'https://www.ardanacademy.com/',
  '25300 5 Mile Rd', '48219', 42.399778, -83.289904, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ardán Academy of Irish Dance' and city = 'Redford'
);
-- Ardán Academy of Irish Dance, Redford: 25300 5 MILE RD, REDFORD, MI, 48239

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Hare School of Irish Dance', 'ohare-school-of-irish-dance-livonia', 'Livonia', 'Michigan', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Hare School of Irish Dance' and city = 'Livonia'
);
-- O'Hare School of Irish Dance, Livonia: Livonia, MI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Moran School of Irish Dance', 'moran-school-of-irish-dance-oakland-county', 'Oakland County', 'Michigan', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Moran School of Irish Dance' and city = 'Oakland County'
);
-- Moran School of Irish Dance, Oakland County: Oakland County, MI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McCartney Irish Dance', 'mccartney-irish-dance-east-lansing', 'East Lansing', 'Michigan', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McCartney Irish Dance' and city = 'East Lansing'
);
-- McCartney Irish Dance, East Lansing: East Lansing, MI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Ní Bhraonain', 'scoil-rince-ni-bhraonain-grand-rapids', 'Grand Rapids', 'Michigan', 'United States', 'https://www.bhraonainirishdance.com/',
  '2661 29th St SE, Suite I', '49512', 42.910317, -85.601074, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Ní Bhraonain' and city = 'Grand Rapids'
);
-- Scoil Rince Ní Bhraonain, Grand Rapids: 2661 29TH ST SE, GRAND RAPIDS, MI, 49512

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Ní Bhraonain', 'scoil-rince-ni-bhraonain-east-grand-rapids', 'East Grand Rapids', 'Michigan', 'United States', 'https://www.bhraonainirishdance.com/',
  '750 Lakeside Dr', '49546', 42.947371, -85.610298, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Ní Bhraonain' and city = 'East Grand Rapids'
);
-- Scoil Rince Ní Bhraonain, East Grand Rapids: 750 LAKESIDE DR NE, GRAND RAPIDS, MI, 49506

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Motor City Irish Dance Academy', 'motor-city-irish-dance-academy-wyandotte', 'Wyandotte', 'Michigan', 'United States', 'https://www.motorcityirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Motor City Irish Dance Academy' and city = 'Wyandotte'
);
-- Motor City Irish Dance Academy, Wyandotte: Wyandotte, MI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Northern Lights Irish Dance and Ballet Academy', 'northern-lights-irish-dance-and-ballet-academy-cadillac', 'Cadillac', 'Michigan', 'United States', 'https://dancenlda.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Northern Lights Irish Dance and Ballet Academy' and city = 'Cadillac'
);
-- Northern Lights Irish Dance and Ballet Academy, Cadillac: Cadillac, MI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Kennedy Holland Irish Dance Academy', 'okennedy-holland-irish-dance-academy-ann-arbor', 'Ann Arbor', 'Michigan', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Kennedy Holland Irish Dance Academy' and city = 'Ann Arbor'
);
-- O'Kennedy Holland Irish Dance Academy, Ann Arbor: Ann Arbor, MI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Madison–Downtown', 'trinity-academy-of-irish-dance-madison-downtown', 'Madison', 'Wisconsin', 'United States', 'https://www.trinityirishdance.com/',
  null, '53703', 43.077500, -89.383100, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Madison–Downtown' and city = 'Madison'
);
-- Trinity Academy of Irish Dance — Madison–Downtown, Madison: Madison, WI 53703 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 53703 (Madison, WI))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Madison–Waunakee', 'trinity-academy-of-irish-dance-madison-waunakee', 'Waunakee', 'Wisconsin', 'United States', 'https://www.trinityirishdance.com/',
  null, '53597', 43.181800, -89.453200, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Madison–Waunakee' and city = 'Waunakee'
);
-- Trinity Academy of Irish Dance — Madison–Waunakee, Waunakee: Waunakee, WI 53597 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 53597 (Waunakee, WI))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Trinity Academy of Irish Dance — Milwaukee–Elm Grove', 'trinity-academy-of-irish-dance-milwaukee-elm-grove', 'Elm Grove', 'Wisconsin', 'United States', 'https://www.trinityirishdance.com/',
  null, '53122', 43.047900, -88.085400, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'Trinity Academy of Irish Dance — Milwaukee–Elm Grove' and city = 'Elm Grove'
);
-- Trinity Academy of Irish Dance — Milwaukee–Elm Grove, Elm Grove: Elm Grove, WI 53122 (city-only (no numbered street published); ZIP centroid via Zippopotam.us 53122 (Elm Grove, WI))

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Glencastle Irish Dancers, Inc.', 'glencastle-irish-dancers-inc-new-berlin', 'New Berlin', 'Wisconsin', 'United States', 'https://www.glencastleirishdancers.com/',
  '5000 S Towne Dr, Suite 130', '53151', 42.954686, -88.114132, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Glencastle Irish Dancers, Inc.' and city = 'New Berlin'
);
-- Glencastle Irish Dancers, Inc., New Berlin: 5000 TOWNE DR, NEW BERLIN, WI, 53151

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Beglan Academy of Irish Dance', 'beglan-academy-of-irish-dance-mequon', 'Mequon', 'Wisconsin', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Beglan Academy of Irish Dance' and city = 'Mequon'
);
-- Beglan Academy of Irish Dance, Mequon: Mequon, WI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cashel Dennehy School of Irish Dance', 'cashel-dennehy-school-of-irish-dance-wauwatosa', 'Wauwatosa', 'Wisconsin', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cashel Dennehy School of Irish Dance' and city = 'Wauwatosa'
);
-- Cashel Dennehy School of Irish Dance, Wauwatosa: Wauwatosa, WI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Milwaukee Irish Dance Academy', 'milwaukee-irish-dance-academy-milwaukee', 'Milwaukee', 'Wisconsin', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Milwaukee Irish Dance Academy' and city = 'Milwaukee'
);
-- Milwaukee Irish Dance Academy, Milwaukee: Milwaukee, WI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bellator Academy of Irish Dance', 'bellator-academy-of-irish-dance-milwaukee', 'Milwaukee', 'Wisconsin', 'United States', 'https://bellatoracademyofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bellator Academy of Irish Dance' and city = 'Milwaukee'
);
-- Bellator Academy of Irish Dance, Milwaukee: Milwaukee, WI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNamara McCarthy School of Irish Dance', 'mcnamara-mccarthy-school-of-irish-dance-wauwatosa', 'Wauwatosa', 'Wisconsin', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNamara McCarthy School of Irish Dance' and city = 'Wauwatosa'
);
-- McNamara McCarthy School of Irish Dance, Wauwatosa: Wauwatosa, WI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hudson Irish Dance Academy', 'hudson-irish-dance-academy-hudson', 'Hudson', 'Wisconsin', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Hudson Irish Dance Academy' and city = 'Hudson'
);
-- Hudson Irish Dance Academy, Hudson: Hudson, WI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-twin-lakes', 'Twin Lakes', 'Wisconsin', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Twin Lakes'
);
-- McNulty School of Irish Dance, Twin Lakes: Twin Lakes, WI (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Shea Irish Dance', 'oshea-irish-dance-st-paul', 'St. Paul', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Shea Irish Dance' and city = 'St. Paul'
);
-- O'Shea Irish Dance, St. Paul: St. Paul, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mactír Academy of Irish Dance', 'mactir-academy-of-irish-dance-minneapolis', 'Minneapolis', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mactír Academy of Irish Dance' and city = 'Minneapolis'
);
-- Mactír Academy of Irish Dance, Minneapolis: Minneapolis, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardaigh Suas Academy of Irish Dance', 'ardaigh-suas-academy-of-irish-dance-albertville', 'Albertville', 'Minnesota', 'United States', 'https://www.asairishdance.com/',
  '5633 La Centre Ave, Suite 400', '55301', 45.233143, -93.663239, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Ardaigh Suas Academy of Irish Dance' and city = 'Albertville'
);
-- Ardaigh Suas Academy of Irish Dance, Albertville: 5633 LACENTRE AVE, ALBERTVILLE, MN, 55301

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Eilís Academy of Irish Dance', 'eilis-academy-of-irish-dance-twin-cities', 'Twin Cities', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Eilís Academy of Irish Dance' and city = 'Twin Cities'
);
-- Eilís Academy of Irish Dance, Twin Cities: Twin Cities, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Onórach Mulhern Geraghty School of Irish Dance (OMG)', 'onorach-mulhern-geraghty-school-of-irish-dance-omg-chanhassen', 'Chanhassen', 'Minnesota', 'United States', 'https://www.omgirishdance.com/',
  '18946 Lake Dr E', '55317', 44.861014, -93.519354, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Onórach Mulhern Geraghty School of Irish Dance (OMG)' and city = 'Chanhassen'
);
-- Onórach Mulhern Geraghty School of Irish Dance (OMG), Chanhassen: 18946 LAKE DR, CHANHASSEN, MN, 55317

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Onórach Mulhern Geraghty School of Irish Dance (OMG)', 'onorach-mulhern-geraghty-school-of-irish-dance-omg-eden-prairie', 'Eden Prairie', 'Minnesota', 'United States', 'https://www.omgirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Onórach Mulhern Geraghty School of Irish Dance (OMG)' and city = 'Eden Prairie'
);
-- Onórach Mulhern Geraghty School of Irish Dance (OMG), Eden Prairie: Eden Prairie, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince na Chroi', 'rince-na-chroi-st-paul', 'St. Paul', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince na Chroi' and city = 'St. Paul'
);
-- Rince na Chroi, St. Paul: St. Paul, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince na Gréine', 'rince-na-greine-hopkins', 'Hopkins', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince na Gréine' and city = 'Hopkins'
);
-- Rince na Gréine, Hopkins: Hopkins, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Green Fire Irish Dancers', 'green-fire-irish-dancers-woodbury', 'Woodbury', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Green Fire Irish Dancers' and city = 'Woodbury'
);
-- Green Fire Irish Dancers, Woodbury: Woodbury, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'North Star Irish Dance', 'north-star-irish-dance-eden-prairie', 'Eden Prairie', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'North Star Irish Dance' and city = 'Eden Prairie'
);
-- North Star Irish Dance, Eden Prairie: Eden Prairie, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'North Star Irish Dance', 'north-star-irish-dance-northfield', 'Northfield', 'Minnesota', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'North Star Irish Dance' and city = 'Northfield'
);
-- North Star Irish Dance, Northfield: Northfield, MN (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Champagne Academy of Irish Dance', 'champagne-academy-of-irish-dance-north-liberty', 'North Liberty', 'Iowa', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Champagne Academy of Irish Dance' and city = 'North Liberty'
);
-- Champagne Academy of Irish Dance, North Liberty: North Liberty, IA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance', 'mcnulty-school-of-irish-dance-dubuque', 'Dubuque', 'Iowa', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance' and city = 'Dubuque'
);
-- McNulty School of Irish Dance, Dubuque: Dubuque, IA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dowds Irish Dance Academy', 'dowds-irish-dance-academy-council-bluffs', 'Council Bluffs', 'Iowa', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dowds Irish Dance Academy' and city = 'Council Bluffs'
);
-- Dowds Irish Dance Academy, Council Bluffs: Council Bluffs, IA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clarkson School of Irish Dance', 'clarkson-school-of-irish-dance-manchester', 'Manchester', 'Missouri', 'United States', null,
  '14353 Manchester Rd', '63011', 38.593040, -90.514161, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Clarkson School of Irish Dance' and city = 'Manchester'
);
-- Clarkson School of Irish Dance, Manchester: 14353 MANCHESTER RD, MANCHESTER, MO, 63011

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clarkson School of Irish Dance', 'clarkson-school-of-irish-dance-st-charles', 'St. Charles', 'Missouri', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clarkson School of Irish Dance' and city = 'St. Charles'
);
-- Clarkson School of Irish Dance, St. Charles: St. Charles, MO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Clark Academy of Irish Dance', 'the-clark-academy-of-irish-dance-st-louis', 'St. Louis', 'Missouri', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'The Clark Academy of Irish Dance' and city = 'St. Louis'
);
-- The Clark Academy of Irish Dance, St. Louis: St. Louis, MO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Meghan Torno School of Irish Dance', 'meghan-torno-school-of-irish-dance-st-louis', 'St. Louis', 'Missouri', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Meghan Torno School of Irish Dance' and city = 'St. Louis'
);
-- Meghan Torno School of Irish Dance, St. Louis: St. Louis, MO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bratten School of Irish Dance', 'bratten-school-of-irish-dance-columbia', 'Columbia', 'Missouri', 'United States', 'https://www.brattenirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bratten School of Irish Dance' and city = 'Columbia'
);
-- Bratten School of Irish Dance, Columbia: Columbia, MO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dowds Irish Dance Academy', 'dowds-irish-dance-academy-kansas-city', 'Kansas City', 'Missouri', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dowds Irish Dance Academy' and city = 'Kansas City'
);
-- Dowds Irish Dance Academy, Kansas City: Kansas City, MO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dowds Irish Dance Academy', 'dowds-irish-dance-academy-mission', 'Mission', 'Kansas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dowds Irish Dance Academy' and city = 'Mission'
);
-- Dowds Irish Dance Academy, Mission: Mission, KS (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Riada Manning Academy of Irish Dance', 'oriada-manning-academy-of-irish-dance-mission', 'Mission', 'Kansas', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Riada Manning Academy of Irish Dance' and city = 'Mission'
);
-- O'Riada Manning Academy of Irish Dance, Mission: Mission, KS (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Driscoll School of Irish Dance', 'the-driscoll-school-of-irish-dance-shawnee', 'Shawnee', 'Kansas', 'United States', 'https://www.driscolldancers.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'The Driscoll School of Irish Dance' and city = 'Shawnee'
);
-- The Driscoll School of Irish Dance, Shawnee: Shawnee, KS (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Driscoll School of Irish Dance — Lawrence classes', 'the-driscoll-school-of-irish-dance-lawrence-classes', 'Lawrence', 'Kansas', 'United States', 'https://www.driscolldancers.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'The Driscoll School of Irish Dance — Lawrence classes' and city = 'Lawrence'
);
-- The Driscoll School of Irish Dance — Lawrence classes, Lawrence: Lawrence, KS (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dowds Irish Dance Academy', 'dowds-irish-dance-academy-omaha', 'Omaha', 'Nebraska', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Dowds Irish Dance Academy' and city = 'Omaha'
);
-- Dowds Irish Dance Academy, Omaha: Omaha, NE (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers — Kentucky', 'mcteggart-irish-dancers-kentucky-lexington', 'Lexington', 'Kentucky', 'United States', 'https://www.kyirishdancers.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers — Kentucky' and city = 'Lexington'
);
-- McTeggart Irish Dancers — Kentucky, Lexington: Lexington, KY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers — Kentucky', 'mcteggart-irish-dancers-kentucky-berea', 'Berea', 'Kentucky', 'United States', 'https://www.kyirishdancers.org/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers — Kentucky' and city = 'Berea'
);
-- McTeggart Irish Dancers — Kentucky, Berea: Berea, KY (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bluegrass Ceili Academy', 'bluegrass-ceili-academy-lexington', 'Lexington', 'Kentucky', 'United States', null,
  '522 Patterson St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bluegrass Ceili Academy' and city = 'Lexington'
);
-- Bluegrass Ceili Academy, Lexington: 522 Patterson St, Lexington, KY (street address did not match Census (batch + single-lookup variants); no verified ZIP, so no coordinates — kept as published)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McClanahan School of Irish Dance', 'mcclanahan-school-of-irish-dance-louisville', 'Louisville', 'Kentucky', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McClanahan School of Irish Dance' and city = 'Louisville'
);
-- McClanahan School of Irish Dance, Louisville: Louisville, KY (city-only)
