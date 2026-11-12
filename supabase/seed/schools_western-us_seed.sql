-- School directory seed — Western US (CA, OR, WA, NV, AZ, UT, ID, MT, CO, NM, AK, HI): 75 locations
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Every row below was verified 2026-11-12 from IDTANA Find a School / state
-- pages, the Western US Region site structure, the FeisWorx school list
-- (name universe + some website domains), and each school's own website. No
-- address was invented. Street address + ZIP are shown ONLY where the school
-- itself (its own site, or its own form/Google Site) publishes them;
-- otherwise the row is city-only. See
-- research_notes/irish-dance-schools-all-us/western-us.md for sources and
-- the full "Unverified / partial" list — nothing from that section is seeded
-- here. Wyoming has no verified dedicated Irish dance school (0 rows).
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
--
-- Counts: CA 12, OR 10, WA 11, NV 3, AZ 8, UT 6, ID 3, MT 7, CO 8, NM 3,
-- AK 3, HI 1 (75 total). Street precision 13, city precision 62.
--
-- Completeness (from the research file): CA partial and the weakest state
-- (12) — several CA schools could not be placed (Boyle, Doherty Petri San
-- Diego, Kelly, McGrath, Murphy, Sutherland); Claddagh lists further SoCal
-- locations that were not verified. OR partial (10). WA partial (11). NV
-- partial (3) — no verified school in Reno / northern Nevada. AZ partial
-- (8). UT partial (6) — Acadamh Rince Murray is kept city-only with a
-- closure report flagged (one directory listing says "Permanently Closed",
-- closure NOT confirmed). ID partial (3). MT partial (7). CO partial (8) —
-- Heritage Irish Stepdancers is NOT seeded (closed Dec 2025, merged into
-- Caitríona and Rose Courtney). NM partial (3). AK partial but likely
-- near-complete (3, all Anchorage). HI partial (1, O'ahu only).
--
-- website_url is NULL for 20 rows: 13 because the schools' sites are
-- http-only as published (Cleary Irish Dance, Clan Rince School, McKeever
-- School, Maldon Meehan, Oregon Irish Dance Academy, Scoil Rince Ni Riada,
-- Bracken School, Michael Patrick Gallagher School, Acadamh Rince, Missoula
-- Irish Dancers, Northern Lights Celtic Dancers), 4 because
-- tonycomerford.com shows as an expired domain (NameBright) and was
-- unreachable on live checks on 2026-11-12 (Comerford School: Seattle,
-- Olympia, Vancouver WA, Anchorage AK), and 3 because their sites were
-- unresolvable from this environment on 2026-11-12 (Phoenix Irish Dance
-- Academy; Tiernan Irish Dancers Boise ID and Helena MT — not proven dead,
-- re-check before linking). Scheme caveat carried from the research
-- file: 20+ websites were listed by FeisWorx as a domain only, with the
-- https scheme unverified; each such URL kept here was checked live over
-- https on 2026-11-12 (HTTP 200) except the ones nulled above. (Tiernan
-- Butte MT, tiernanbutte.com, did return HTTP 200 and is kept.)
--
-- Coordinates: US Census Geocoder (Public_AR_Current benchmark) for street
-- addresses. City-only rows have NO coordinates unless a verified ZIP was
-- available: the Census Geocoder cannot resolve a bare "City, ST" (tested —
-- it returns No_Match), and no Western city-only row carries a verified ZIP,
-- so there was no Zippopotam.us fallback to use. Those rows keep
-- latitude/longitude/geo_precision/geo_source NULL rather than invented
-- coordinates; the schools remain listed and searchable by city.
-- Street addresses that failed to geocode: McTeggart School of Irish Dance
-- in New Mexico, Rio Rancho (4311 Sara Rd SE, 87124), did not match Census;
-- it carries the 87124 ZIP centroid from Zippopotam.us (geo_precision
-- 'city', geo_source 'zippopotam'). An Daire Academy of Irish Dance /
-- Irish Dance O'ahu, Kailua HI (203 Kapa'a Quarry Pl, Unit 3307, 96734),
-- also did not match Census (with or without the unit number); it carries
-- the 96734 ZIP centroid from Zippopotam.us. Both rows keep their published
-- street address. Dara Irish Dance Academy, Lehi UT, is seeded at 288 E Main
-- St (84043); the school's site also lists a second Lehi address — one row
-- per name+city, so only the first is seeded.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists, so the file is safe to re-run. Status is 'unclaimed'
-- (default) — these listings have not been claimed by the schools.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Claddagh Dance Company (Claddagh Western U.S.)', 'claddagh-dance-company-claddagh-western-u-s-ventura', 'Ventura', 'California', 'United States', 'https://www.claddaghdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Claddagh Dance Company (Claddagh Western U.S.)' and city = 'Ventura'
);
-- Claddagh Dance Company (Claddagh Western U.S.), Ventura: Ventura, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cleary Irish Dance', 'cleary-irish-dance-burbank', 'Burbank', 'California', 'United States', null,
  '173 W Magnolia Blvd', '91502', 34.178142, -118.316996, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Cleary Irish Dance' and city = 'Burbank'
);
-- Cleary Irish Dance, Burbank: 173 W MAGNOLIA BLVD, BURBANK, CA, 91502

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Clan Rince School of Irish Dance', 'clan-rince-school-of-irish-dance-san-diego', 'San Diego', 'California', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Clan Rince School of Irish Dance' and city = 'San Diego'
);
-- Clan Rince School of Irish Dance, San Diego: San Diego, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Greenway Academy of Irish Dance', 'greenway-academy-of-irish-dance-camarillo', 'Camarillo', 'California', 'United States', 'https://www.greenwayacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Greenway Academy of Irish Dance' and city = 'Camarillo'
);
-- Greenway Academy of Irish Dance, Camarillo: Camarillo, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Healy School of Irish Dance', 'healy-school-of-irish-dance-larkspur', 'Larkspur', 'California', 'United States', 'https://www.healyirishdancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Healy School of Irish Dance' and city = 'Larkspur'
);
-- Healy School of Irish Dance, Larkspur: Larkspur, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Jackie Flynn Irish Dance Academy', 'jackie-flynn-irish-dance-academy-san-francisco', 'San Francisco', 'California', 'United States', 'https://jflynnirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Jackie Flynn Irish Dance Academy' and city = 'San Francisco'
);
-- Jackie Flynn Irish Dance Academy, San Francisco: San Francisco, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Keenan School of Irish Dance', 'keenan-school-of-irish-dance-petaluma', 'Petaluma', 'California', 'United States', 'https://keenanirishdanceschool.com',
  '211 Liberty St', '94952', 38.235045, -122.644074, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Keenan School of Irish Dance' and city = 'Petaluma'
);
-- Keenan School of Irish Dance, Petaluma: 211 LIBERTY ST, PETALUMA, CA, 94952

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGrath Morgan Academy (McGrath Morgan School of Irish Dance)', 'mcgrath-morgan-academy-mcgrath-morgan-school-of-irish-dance-morgan-hill', 'Morgan Hill', 'California', 'United States', 'https://www.mcgrathirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGrath Morgan Academy (McGrath Morgan School of Irish Dance)' and city = 'Morgan Hill'
);
-- McGrath Morgan Academy (McGrath Morgan School of Irish Dance), Morgan Hill: Morgan Hill, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McKeever School of Irish Dance', 'mckeever-school-of-irish-dance-sacramento', 'Sacramento', 'California', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McKeever School of Irish Dance' and city = 'Sacramento'
);
-- McKeever School of Irish Dance, Sacramento: Sacramento, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McNulty School of Irish Dance, LA', 'mcnulty-school-of-irish-dance-la-los-angeles', 'Los Angeles', 'California', 'United States', 'https://www.mcnultyirishdancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McNulty School of Irish Dance, LA' and city = 'Los Angeles'
);
-- McNulty School of Irish Dance, LA, Los Angeles: Los Angeles, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The West Coast Academy of Irish Dance (Jackie Flynn and the West Coast Academy)', 'the-west-coast-academy-of-irish-dance-jackie-flynn-and-the-west-coast-academy-agoura-hills', 'Agoura Hills', 'California', 'United States', 'https://www.westcoastirishdance.com',
  '30686 E Thousand Oaks Blvd', '91301', 34.154627, -118.789025, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The West Coast Academy of Irish Dance (Jackie Flynn and the West Coast Academy)' and city = 'Agoura Hills'
);
-- The West Coast Academy of Irish Dance (Jackie Flynn and the West Coast Academy), Agoura Hills: 30686 THOUSAND OAKS BLVD, AGOURA HILLS, CA, 91301

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The West Coast Academy of Irish Dance', 'the-west-coast-academy-of-irish-dance-simi-valley', 'Simi Valley', 'California', 'United States', 'https://www.westcoastirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'The West Coast Academy of Irish Dance' and city = 'Simi Valley'
);
-- The West Coast Academy of Irish Dance, Simi Valley: Simi Valley, CA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance', 'an-daire-academy-of-irish-dance-portland', 'Portland', 'Oregon', 'United States', 'https://www.andaireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance' and city = 'Portland'
);
-- An Daire Academy of Irish Dance, Portland: Portland, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance', 'an-daire-academy-of-irish-dance-oregon-city', 'Oregon City', 'Oregon', 'United States', 'https://www.andaireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance' and city = 'Oregon City'
);
-- An Daire Academy of Irish Dance, Oregon City: Oregon City, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance', 'an-daire-academy-of-irish-dance-hillsboro', 'Hillsboro', 'Oregon', 'United States', 'https://www.andaireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance' and city = 'Hillsboro'
);
-- An Daire Academy of Irish Dance, Hillsboro: Hillsboro, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blackthorn Academy of Irish Dance', 'blackthorn-academy-of-irish-dance-eugene', 'Eugene', 'Oregon', 'United States', 'https://www.andaireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Blackthorn Academy of Irish Dance' and city = 'Eugene'
);
-- Blackthorn Academy of Irish Dance, Eugene: Eugene, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maldon Meehan Irish Dance (sean-nós / set dance)', 'maldon-meehan-irish-dance-sean-nos-set-dance-portland', 'Portland', 'Oregon', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maldon Meehan Irish Dance (sean-nós / set dance)' and city = 'Portland'
);
-- Maldon Meehan Irish Dance (sean-nós / set dance), Portland: Portland, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Oregon Irish Dance Academy', 'oregon-irish-dance-academy-portland', 'Portland', 'Oregon', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Oregon Irish Dance Academy' and city = 'Portland'
);
-- Oregon Irish Dance Academy, Portland: Portland, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Yeates Academy of Irish Dance', 'yeates-academy-of-irish-dance-portland', 'Portland', 'Oregon', 'United States', 'https://www.yeatesacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Yeates Academy of Irish Dance' and city = 'Portland'
);
-- Yeates Academy of Irish Dance, Portland: Portland, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Yeates Academy of Irish Dance', 'yeates-academy-of-irish-dance-lake-oswego', 'Lake Oswego', 'Oregon', 'United States', 'https://www.yeatesacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Yeates Academy of Irish Dance' and city = 'Lake Oswego'
);
-- Yeates Academy of Irish Dance, Lake Oswego: Lake Oswego, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Yeates Academy of Irish Dance', 'yeates-academy-of-irish-dance-salem', 'Salem', 'Oregon', 'United States', 'https://www.yeatesacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Yeates Academy of Irish Dance' and city = 'Salem'
);
-- Yeates Academy of Irish Dance, Salem: Salem, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Yeates Academy of Irish Dance', 'yeates-academy-of-irish-dance-redmond', 'Redmond', 'Oregon', 'United States', 'https://www.yeatesacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Yeates Academy of Irish Dance' and city = 'Redmond'
);
-- Yeates Academy of Irish Dance, Redmond: Redmond, OR (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance', 'an-daire-academy-of-irish-dance-wenatchee', 'Wenatchee', 'Washington', 'United States', 'https://www.andaireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance' and city = 'Wenatchee'
);
-- An Daire Academy of Irish Dance, Wenatchee: Wenatchee, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carroll-Henderson School of Irish Dancing', 'carroll-henderson-school-of-irish-dancing-edmonds', 'Edmonds', 'Washington', 'United States', 'https://www.chirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carroll-Henderson School of Irish Dancing' and city = 'Edmonds'
);
-- Carroll-Henderson School of Irish Dancing, Edmonds: Edmonds, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Comerford School (Comerford Washington)', 'comerford-school-comerford-washington-seattle', 'Seattle', 'Washington', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Comerford School (Comerford Washington)' and city = 'Seattle'
);
-- Comerford School (Comerford Washington), Seattle: Seattle, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Comerford School (Comerford Olympia)', 'comerford-school-comerford-olympia', 'Olympia', 'Washington', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Comerford School (Comerford Olympia)' and city = 'Olympia'
);
-- Comerford School (Comerford Olympia), Olympia: Olympia, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Comerford School (Comerford Vancouver)', 'comerford-school-comerford-vancouver', 'Vancouver', 'Washington', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Comerford School (Comerford Vancouver)' and city = 'Vancouver'
);
-- Comerford School (Comerford Vancouver), Vancouver: Vancouver, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haran School of Irish Dance', 'haran-school-of-irish-dance-spokane', 'Spokane', 'Washington', 'United States', 'https://www.harandancers.com',
  '1006 S Perry St', '99212', 47.646235, -117.390003, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Haran School of Irish Dance' and city = 'Spokane'
);
-- Haran School of Irish Dance, Spokane: 1006 S PERRY ST, SPOKANE, WA, 99202

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haran School of Irish Dance', 'haran-school-of-irish-dance-kettle-falls', 'Kettle Falls', 'Washington', 'United States', 'https://www.harandancers.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Haran School of Irish Dance' and city = 'Kettle Falls'
);
-- Haran School of Irish Dance, Kettle Falls: Kettle Falls, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'MSD Irish Dance Academy (an misneach sionnach damhsa)', 'msd-irish-dance-academy-an-misneach-sionnach-damhsa-spokane-valley', 'Spokane Valley', 'Washington', 'United States', 'https://www.msdirishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'MSD Irish Dance Academy (an misneach sionnach damhsa)' and city = 'Spokane Valley'
);
-- MSD Irish Dance Academy (an misneach sionnach damhsa), Spokane Valley: Spokane Valley, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Penk-O''Donnell (Penk O''Donnell School)', 'penk-odonnell-penk-odonnell-school-bellingham', 'Bellingham', 'Washington', 'United States', 'https://www.penkodonnell.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Penk-O''Donnell (Penk O''Donnell School)' and city = 'Bellingham'
);
-- Penk-O'Donnell (Penk O'Donnell School), Bellingham: Bellingham, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tara Academy of Irish Dance', 'tara-academy-of-irish-dance-seattle', 'Seattle', 'Washington', 'United States', 'https://www.taraacademy.com/',
  '14032 Aurora Ave N, Suite B', '98133', 47.731095, -122.344979, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Tara Academy of Irish Dance' and city = 'Seattle'
);
-- Tara Academy of Irish Dance, Seattle: 14032 AURORA AVE N, SEATTLE, WA, 98133

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Yeates Academy of Irish Dance', 'yeates-academy-of-irish-dance-vancouver', 'Vancouver', 'Washington', 'United States', 'https://www.yeatesacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Yeates Academy of Irish Dance' and city = 'Vancouver'
);
-- Yeates Academy of Irish Dance, Vancouver: Vancouver, WA (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Ni Riada Irish Dance', 'scoil-rince-ni-riada-irish-dance-las-vegas', 'Las Vegas', 'Nevada', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Ni Riada Irish Dance' and city = 'Las Vegas'
);
-- Scoil Rince Ni Riada Irish Dance, Las Vegas: Las Vegas, NV (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince Ni Riada Irish Dance', 'scoil-rince-ni-riada-irish-dance-henderson', 'Henderson', 'Nevada', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince Ni Riada Irish Dance' and city = 'Henderson'
);
-- Scoil Rince Ni Riada Irish Dance, Henderson: Henderson, NV (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-las-vegas', 'Las Vegas', 'Nevada', 'United States', 'https://www.scariffschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'Las Vegas'
);
-- Scariff Locklier Leonelli School of Irish Dance, Las Vegas: Las Vegas, NV (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bracken School of Irish Dance', 'bracken-school-of-irish-dance-mesa', 'Mesa', 'Arizona', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bracken School of Irish Dance' and city = 'Mesa'
);
-- Bracken School of Irish Dance, Mesa: Mesa, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bracken School of Irish Dance', 'bracken-school-of-irish-dance-tucson', 'Tucson', 'Arizona', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bracken School of Irish Dance' and city = 'Tucson'
);
-- Bracken School of Irish Dance, Tucson: Tucson, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Steps Arizona (Celtic Steps School of Irish Dance)', 'celtic-steps-arizona-celtic-steps-school-of-irish-dance-phoenix', 'Phoenix', 'Arizona', 'United States', 'https://www.arizonairishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Celtic Steps Arizona (Celtic Steps School of Irish Dance)' and city = 'Phoenix'
);
-- Celtic Steps Arizona (Celtic Steps School of Irish Dance), Phoenix: Phoenix, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Steps Arizona', 'celtic-steps-arizona-tucson', 'Tucson', 'Arizona', 'United States', 'https://www.arizonairishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Celtic Steps Arizona' and city = 'Tucson'
);
-- Celtic Steps Arizona, Tucson: Tucson, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maguire Academy of Irish Dance', 'maguire-academy-of-irish-dance-tucson', 'Tucson', 'Arizona', 'United States', 'https://www.maguireacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maguire Academy of Irish Dance' and city = 'Tucson'
);
-- Maguire Academy of Irish Dance, Tucson: Tucson, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Maguire Academy of Irish Dance', 'maguire-academy-of-irish-dance-phoenix', 'Phoenix', 'Arizona', 'United States', 'https://www.maguireacademy.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Maguire Academy of Irish Dance' and city = 'Phoenix'
);
-- Maguire Academy of Irish Dance, Phoenix: Phoenix, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Michael Patrick Gallagher School of Irish Dance (MPG Irish Dance)', 'michael-patrick-gallagher-school-of-irish-dance-mpg-irish-dance-phoenix', 'Phoenix', 'Arizona', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Michael Patrick Gallagher School of Irish Dance (MPG Irish Dance)' and city = 'Phoenix'
);
-- Michael Patrick Gallagher School of Irish Dance (MPG Irish Dance), Phoenix: Phoenix, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Phoenix Irish Dance Academy', 'phoenix-irish-dance-academy-phoenix', 'Phoenix', 'Arizona', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Phoenix Irish Dance Academy' and city = 'Phoenix'
);
-- Phoenix Irish Dance Academy, Phoenix: Phoenix, AZ (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Acadamh Rince (formerly Webber Academy)', 'acadamh-rince-formerly-webber-academy-murray', 'Murray', 'Utah', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Acadamh Rince (formerly Webber Academy)' and city = 'Murray'
);
-- Acadamh Rince (formerly Webber Academy), Murray: Murray, UT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dara Irish Dance Academy', 'dara-irish-dance-academy-lehi', 'Lehi', 'Utah', 'United States', 'https://www.darairishdance.com',
  '288 E Main St', '84043', 40.387961, -111.844538, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Dara Irish Dance Academy' and city = 'Lehi'
);
-- Dara Irish Dance Academy, Lehi: 288 E MAIN ST, LEHI, UT, 84043

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rise Academy of Dance', 'rise-academy-of-dance-layton', 'Layton', 'Utah', 'United States', 'https://riseacademydance.com/',
  '739 N 2475 W', '84041', 41.070906, -112.012110, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rise Academy of Dance' and city = 'Layton'
);
-- Rise Academy of Dance, Layton: 739 N 2475 W, LAYTON, UT, 84041

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-sandy', 'Sandy', 'Utah', 'United States', 'https://www.scariffschool.com',
  '9854 S 700 E', '84070', 40.571825, -111.872241, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'Sandy'
);
-- Scariff Locklier Leonelli School of Irish Dance, Sandy: 9854 S 700 E, SANDY, UT, 84070

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-north-salt-lake', 'North Salt Lake', 'Utah', 'United States', 'https://www.scariffschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'North Salt Lake'
);
-- Scariff Locklier Leonelli School of Irish Dance, North Salt Lake: North Salt Lake, UT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-logan', 'Logan', 'Utah', 'United States', 'https://www.scariffschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'Logan'
);
-- Scariff Locklier Leonelli School of Irish Dance, Logan: Logan, UT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance, Idaho', 'an-daire-academy-of-irish-dance-idaho-moscow', 'Moscow', 'Idaho', 'United States', 'https://www.andaire.org',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance, Idaho' and city = 'Moscow'
);
-- An Daire Academy of Irish Dance, Idaho, Moscow: Moscow, ID (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince na Gra School of Irish Dance', 'rince-na-gra-school-of-irish-dance-moscow', 'Moscow', 'Idaho', 'United States', 'https://www.rincenagra.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rince na Gra School of Irish Dance' and city = 'Moscow'
);
-- Rince na Gra School of Irish Dance, Moscow: Moscow, ID (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tiernan Irish Dancers', 'tiernan-irish-dancers-boise', 'Boise', 'Idaho', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Tiernan Irish Dancers' and city = 'Boise'
);
-- Tiernan Irish Dancers, Boise: Boise, ID (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance (Flathead Valley Irish Dance)', 'an-daire-academy-of-irish-dance-flathead-valley-irish-dance-kalispell', 'Kalispell', 'Montana', 'United States', 'https://www.andaireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance (Flathead Valley Irish Dance)' and city = 'Kalispell'
);
-- An Daire Academy of Irish Dance (Flathead Valley Irish Dance), Kalispell: Kalispell, MT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance (Flathead Valley Irish Dance)', 'an-daire-academy-of-irish-dance-flathead-valley-irish-dance-whitefish', 'Whitefish', 'Montana', 'United States', 'https://www.andaireacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance (Flathead Valley Irish Dance)' and city = 'Whitefish'
);
-- An Daire Academy of Irish Dance (Flathead Valley Irish Dance), Whitefish: Whitefish, MT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Carroll-Henderson School of Irish Dancing', 'carroll-henderson-school-of-irish-dancing-missoula', 'Missoula', 'Montana', 'United States', 'https://www.chirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Carroll-Henderson School of Irish Dancing' and city = 'Missoula'
);
-- Carroll-Henderson School of Irish Dancing, Missoula: Missoula, MT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Missoula Irish Dancers', 'missoula-irish-dancers-missoula', 'Missoula', 'Montana', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Missoula Irish Dancers' and city = 'Missoula'
);
-- Missoula Irish Dancers, Missoula: Missoula, MT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scariff Locklier Leonelli School of Irish Dance', 'scariff-locklier-leonelli-school-of-irish-dance-helena', 'Helena', 'Montana', 'United States', 'https://www.scariffschool.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scariff Locklier Leonelli School of Irish Dance' and city = 'Helena'
);
-- Scariff Locklier Leonelli School of Irish Dance, Helena: Helena, MT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tiernan Irish Dancers', 'tiernan-irish-dancers-butte', 'Butte', 'Montana', 'United States', 'https://www.tiernanbutte.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Tiernan Irish Dancers' and city = 'Butte'
);
-- Tiernan Irish Dancers, Butte: Butte, MT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Tiernan Irish Dancers', 'tiernan-irish-dancers-helena', 'Helena', 'Montana', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Tiernan Irish Dancers' and city = 'Helena'
);
-- Tiernan Irish Dancers, Helena: Helena, MT (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Avoca Connolly Irish Dance (Avoca + Connolly, merged summer 2026)', 'avoca-connolly-irish-dance-avoca-connolly-merged-summer-2026-lakewood', 'Lakewood', 'Colorado', 'United States', 'https://www.avocaconnollyirishdance.com',
  '7625 W Hampden Ave', '80227', 39.653270, -105.082456, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Avoca Connolly Irish Dance (Avoca + Connolly, merged summer 2026)' and city = 'Lakewood'
);
-- Avoca Connolly Irish Dance (Avoca + Connolly, merged summer 2026), Lakewood: 7625 W HAMPDEN AVE, LAKEWOOD, CO, 80227

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Avoca Connolly Irish Dance', 'avoca-connolly-irish-dance-longmont', 'Longmont', 'Colorado', 'United States', 'https://www.avocaconnollyirishdance.com',
  '1515 Main St', '80501', 40.185197, -105.102406, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Avoca Connolly Irish Dance' and city = 'Longmont'
);
-- Avoca Connolly Irish Dance, Longmont: 1515 MAIN ST, LONGMONT, CO, 80501

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Caitríona Irish Dance', 'caitriona-irish-dance-denver', 'Denver', 'Colorado', 'United States', 'https://www.caitrionairishdance.com',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Caitríona Irish Dance' and city = 'Denver'
);
-- Caitríona Irish Dance, Denver: Denver, CO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers (McTeggart, Western U.S. Region)', 'mcteggart-irish-dancers-mcteggart-western-u-s-region-boulder', 'Boulder', 'Colorado', 'United States', 'https://www.mcteggart.org',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers (McTeggart, Western U.S. Region)' and city = 'Boulder'
);
-- McTeggart Irish Dancers (McTeggart, Western U.S. Region), Boulder: Boulder, CO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers', 'mcteggart-irish-dancers-denver', 'Denver', 'Colorado', 'United States', 'https://www.mcteggart.org',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers' and city = 'Denver'
);
-- McTeggart Irish Dancers, Denver: Denver, CO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart Irish Dancers', 'mcteggart-irish-dancers-fort-collins', 'Fort Collins', 'Colorado', 'United States', 'https://www.mcteggart.org',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McTeggart Irish Dancers' and city = 'Fort Collins'
);
-- McTeggart Irish Dancers, Fort Collins: Fort Collins, CO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rose Courtney Academy of Irish Dance', 'rose-courtney-academy-of-irish-dance-monument', 'Monument', 'Colorado', 'United States', 'https://rosecourtneyirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rose Courtney Academy of Irish Dance' and city = 'Monument'
);
-- Rose Courtney Academy of Irish Dance, Monument: Monument, CO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rose Courtney Academy of Irish Dance', 'rose-courtney-academy-of-irish-dance-colorado-springs', 'Colorado Springs', 'Colorado', 'United States', 'https://rosecourtneyirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rose Courtney Academy of Irish Dance' and city = 'Colorado Springs'
);
-- Rose Courtney Academy of Irish Dance, Colorado Springs: Colorado Springs, CO (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brightburn Academy of Irish Dance', 'brightburn-academy-of-irish-dance-rio-rancho', 'Rio Rancho', 'New Mexico', 'United States', 'https://www.brightburnacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brightburn Academy of Irish Dance' and city = 'Rio Rancho'
);
-- Brightburn Academy of Irish Dance, Rio Rancho: Rio Rancho, NM (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart School of Irish Dance in New Mexico', 'mcteggart-school-of-irish-dance-in-new-mexico-albuquerque', 'Albuquerque', 'New Mexico', 'United States', 'https://irishdancenewmexico.com',
  '10410 Comanche Rd', '87111', 35.123427, -106.524285, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McTeggart School of Irish Dance in New Mexico' and city = 'Albuquerque'
);
-- McTeggart School of Irish Dance in New Mexico, Albuquerque: 10410 COMANCHE RD NE, ALBUQUERQUE, NM, 87111

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McTeggart School of Irish Dance in New Mexico', 'mcteggart-school-of-irish-dance-in-new-mexico-rio-rancho', 'Rio Rancho', 'New Mexico', 'United States', 'https://irishdancenewmexico.com',
  '4311 Sara Rd SE', '87124', 35.249300, -106.681800, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'McTeggart School of Irish Dance in New Mexico' and city = 'Rio Rancho'
);
-- McTeggart School of Irish Dance in New Mexico, Rio Rancho: 4311 Sara Rd SE, Rio Rancho, NM 87124 (street address did not match Census (No_Match); ZIP centroid via Zippopotam.us 87124)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Comerford School (Comerford Alaska)', 'comerford-school-comerford-alaska-anchorage', 'Anchorage', 'Alaska', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Comerford School (Comerford Alaska)' and city = 'Anchorage'
);
-- Comerford School (Comerford Alaska), Anchorage: Anchorage, AK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Irish Dance Academy of Alaska', 'irish-dance-academy-of-alaska-anchorage', 'Anchorage', 'Alaska', 'United States', 'https://irishdanceak.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Irish Dance Academy of Alaska' and city = 'Anchorage'
);
-- Irish Dance Academy of Alaska, Anchorage: Anchorage, AK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Northern Lights Celtic Dancers', 'northern-lights-celtic-dancers-anchorage', 'Anchorage', 'Alaska', 'United States', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Northern Lights Celtic Dancers' and city = 'Anchorage'
);
-- Northern Lights Celtic Dancers, Anchorage: Anchorage, AK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'An Daire Academy of Irish Dance / Irish Dance O''ahu', 'an-daire-academy-of-irish-dance-irish-dance-oahu-kailua', 'Kailua', 'Hawaii', 'United States', 'https://sites.google.com/pacificcelticfoundation.org/irishdanceoahu/home',
  '203 Kapa''a Quarry Pl, Unit 3307', '96734', 21.406300, -157.744800, 'city', 'zippopotam'
where not exists (
  select 1 from public.schools
  where name = 'An Daire Academy of Irish Dance / Irish Dance O''ahu' and city = 'Kailua'
);
-- An Daire Academy of Irish Dance / Irish Dance O'ahu, Kailua: 203 Kapa'a Quarry Pl, Unit 3307, Kailua, HI 96734 (street address did not match Census (No_Match); ZIP centroid via Zippopotam.us 96734)
