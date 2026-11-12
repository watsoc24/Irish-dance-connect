-- School directory seed — Ohio (34 locations, 20 schools) + 6 verified out-of-state schools
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Every address below was verified 2026-11-11/12 from the IDTANA Ohio pages,
-- FeisWorx, Planxti, and each school's own website / social pages — see
-- the verified list the curator worked from. No address was invented.
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
--
-- postal_code is NULL where no ZIP was verified for the address (Richens/Timm
-- Dublin + Columbus, MacConmara Akron, Dwyer Columbus, Leneghan Middleburg
-- Heights, Blackbird Tinley Park) — the Census Geocoder did return a ZIP for
-- those street addresses, but the addresses were recorded as ZIP-unverified
-- in the source list, so the ZIP stays blank rather than guessed.
--
-- website_url is NULL for three rows because the schema requires https:// and
-- those schools' sites are HTTP-only (Rankin O'Kennedy Holland: Medina +
-- Hilliard) or were unreachable on both schemes when checked 2026-11-12
-- (Nugent). Every other website URL was checked live over https on
-- 2026-11-12 and returned HTTP 200.
--
-- Coordinates: US Census Geocoder (Public_AR_Current benchmark), except
-- The Academy Strongsville, which is city-only (no street address published)
-- and uses the Strongsville city centroid from Zippopotam.us.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists, so the file is safe to re-run. Status is 'unclaimed'
-- (default) — these listings have not been claimed by the schools.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Richens/Timm Academy', 'richens-timm-academy-dublin', 'Dublin', 'Ohio', 'United States', 'https://www.richenstimm.com/',
  '4348 Tuller Rd', null, 40.107766, -83.105994, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Richens/Timm Academy' and city = 'Dublin'
);
-- Richens/Timm Academy, Dublin: 4348 TULLER RD, DUBLIN, OH, 43017

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Richens/Timm Academy', 'richens-timm-academy-columbus', 'Columbus', 'Ohio', 'United States', 'https://www.richenstimm.com/',
  '39 E State St', null, 39.960245, -82.998991, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Richens/Timm Academy' and city = 'Columbus'
);
-- Richens/Timm Academy, Columbus: 39 E STATE ST, COLUMBUS, OH, 43215

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Richens/Timm Academy', 'richens-timm-academy-beavercreek', 'Beavercreek', 'Ohio', 'United States', 'https://www.richenstimm.com/',
  '1990 Wilene Dr', '45432', 39.749802, -84.095976, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Richens/Timm Academy' and city = 'Beavercreek'
);
-- Richens/Timm Academy, Beavercreek: 1990 WILENE DR, BEAVERCREEK, OH, 45432

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Richens/Timm Academy', 'richens-timm-academy-kettering', 'Kettering', 'Ohio', 'United States', 'https://www.richenstimm.com/',
  '2655 Olson Dr', '45420', 39.694588, -84.118157, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Richens/Timm Academy' and city = 'Kettering'
);
-- Richens/Timm Academy, Kettering: 2655 OLSON DR, KETTERING, OH, 45420

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGovern Irish Dance', 'mcgovern-irish-dance-dayton', 'Dayton', 'Ohio', 'United States', 'https://www.mcgoverndance.org/',
  '818 Linden Ave', '45410', 39.753740, -84.152303, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGovern Irish Dance' and city = 'Dayton'
);
-- McGovern Irish Dance, Dayton: 818 LINDEN AVE, DAYTON, OH, 45410

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGovern Irish Dance', 'mcgovern-irish-dance-troy', 'Troy', 'Ohio', 'United States', 'https://www.mcgoverndance.org/',
  '101 W Franklin St', '45373', 40.039119, -84.205067, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGovern Irish Dance' and city = 'Troy'
);
-- McGovern Irish Dance, Troy: 101 W FRANKLIN ST, TROY, OH, 45373

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murphy Irish Arts Center', 'murphy-irish-arts-center-beachwood', 'Beachwood', 'Ohio', 'United States', 'https://murphyirishartscenter.com/',
  '24000 Mercantile Rd #10', '44122', 41.462017, -81.504695, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Murphy Irish Arts Center' and city = 'Beachwood'
);
-- Murphy Irish Arts Center, Beachwood: 24000 MERCANTILE RD, BEACHWOOD, OH, 44122

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Murphy Irish Arts Center', 'murphy-irish-arts-center-willoughby', 'Willoughby', 'Ohio', 'United States', 'https://murphyirishartscenter.com/',
  '36939 Ridge Rd', '44094', 41.619147, -81.423660, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Murphy Irish Arts Center' and city = 'Willoughby'
);
-- Murphy Irish Arts Center, Willoughby: 36939 RIDGE RD, WILLOUGHBY, OH, 44094

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'MacConmara Academy of Irish Dance', 'macconmara-academy-of-irish-dance-akron', 'Akron', 'Ohio', 'United States', 'https://www.macconmaraacademy.com/',
  '2006 Brown St', null, 41.028666, -81.510555, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'MacConmara Academy of Irish Dance' and city = 'Akron'
);
-- MacConmara Academy of Irish Dance, Akron: 2006 BROWN ST, AKRON, OH, 44319

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Burke School of Irish Dance', 'burke-school-of-irish-dance-fairview-park', 'Fairview Park', 'Ohio', 'United States', 'https://www.burkeirishdancecleveland.com/',
  '22374 Lorain Rd', '44126', 41.440032, -81.868450, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Burke School of Irish Dance' and city = 'Fairview Park'
);
-- Burke School of Irish Dance, Fairview Park: 22374 LORAIN AVE, FAIRVIEW PARK, OH, 44126

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Burke School of Irish Dance', 'burke-school-of-irish-dance-youngstown', 'Youngstown', 'Ohio', 'United States', 'https://burkeirishyoungstown.square.site/',
  '3155 Canfield Rd', '44511', 41.063711, -80.705263, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Burke School of Irish Dance' and city = 'Youngstown'
);
-- Burke School of Irish Dance, Youngstown: 3155 CANFIELD RD, YOUNGSTOWN, OH, 44511

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Egan Irish Dance', 'egan-irish-dance-chesterland', 'Chesterland', 'Ohio', 'United States', 'https://www.eganid.com/',
  '8389 Mayfield Rd', '44026', 41.522142, -81.342595, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Egan Irish Dance' and city = 'Chesterland'
);
-- Egan Irish Dance, Chesterland: 8389 MAYFIELD RD, CHESTERLAND, OH, 44026

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Egan Irish Dance', 'egan-irish-dance-richfield', 'Richfield', 'Ohio', 'United States', 'https://www.eganid.com/',
  '4131 W Streetsboro Rd', '44286', 41.239851, -81.636041, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Egan Irish Dance' and city = 'Richfield'
);
-- Egan Irish Dance, Richfield: 4131 W STREETSBORO RD, RICHFIELD, OH, 44286

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dwyer School of Irish Dance', 'dwyer-school-of-irish-dance-centerville', 'Centerville', 'Ohio', 'United States', 'https://www.dwyeririshdance.com/',
  '44 Westpark Rd', '45459', 39.629739, -84.144115, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Dwyer School of Irish Dance' and city = 'Centerville'
);
-- Dwyer School of Irish Dance, Centerville: 44 WESTPARK RD, CENTERVILLE, OH, 45459

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Dwyer School of Irish Dance', 'dwyer-school-of-irish-dance-columbus', 'Columbus', 'Ohio', 'United States', 'https://www.dwyeririshdance.com/',
  '728 E Lincoln Ave', null, 40.074800, -82.998937, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Dwyer School of Irish Dance' and city = 'Columbus'
);
-- Dwyer School of Irish Dance, Columbus: 728 E LINCOLN AVE, COLUMBUS, OH, 43229

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rankin O''Kennedy Holland Irish Dance Academy', 'rankin-okennedy-holland-irish-dance-academy-medina', 'Medina', 'Ohio', 'United States', null,
  '313 Medina Rd Ste 100', '44256', 41.136059, -81.698780, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rankin O''Kennedy Holland Irish Dance Academy' and city = 'Medina'
);
-- Rankin O'Kennedy Holland Irish Dance Academy, Medina: 313 MEDINA RD, MEDINA, OH, 44256

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rankin O''Kennedy Holland Irish Dance Academy', 'rankin-okennedy-holland-irish-dance-academy-hilliard', 'Hilliard', 'Ohio', 'United States', null,
  '4603 Northwest Pkwy', '43026', 40.038437, -83.140187, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rankin O''Kennedy Holland Irish Dance Academy' and city = 'Hilliard'
);
-- Rankin O'Kennedy Holland Irish Dance Academy, Hilliard: 4603 NORTHWEST PKWY, HILLIARD, OH, 43026

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Campbell Irish Dance School', 'brady-campbell-irish-dance-school-cleveland', 'Cleveland', 'Ohio', 'United States', 'https://www.bradycampbellirishdanceschool.com/',
  '17119 Lorain Ave', '44111', 41.450175, -81.816253, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Brady Campbell Irish Dance School' and city = 'Cleveland'
);
-- Brady Campbell Irish Dance School, Cleveland: 17119 LORAIN AVE, CLEVELAND, OH, 44111

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Campbell Irish Dance School', 'brady-campbell-irish-dance-school-avon-lake', 'Avon Lake', 'Ohio', 'United States', 'https://www.bradycampbellirishdanceschool.com/',
  '33540 Pin Oak Pkwy', '44012', 41.481707, -82.038265, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Brady Campbell Irish Dance School' and city = 'Avon Lake'
);
-- Brady Campbell Irish Dance School, Avon Lake: 33540 PIN OAK PKWY, AVON LAKE, OH, 44012

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Leneghan Academy of Irish Dance', 'leneghan-academy-of-irish-dance-westlake', 'Westlake', 'Ohio', 'United States', 'https://www.leneghanacademy.com/',
  '27327 Detroit Rd', '44145', 41.466897, -81.923738, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Leneghan Academy of Irish Dance' and city = 'Westlake'
);
-- Leneghan Academy of Irish Dance, Westlake: 27327 DETROIT RD, WESTLAKE, OH, 44145

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Leneghan Academy of Irish Dance', 'leneghan-academy-of-irish-dance-middleburg-heights', 'Middleburg Heights', 'Ohio', 'United States', 'https://www.leneghanacademy.com/',
  '7501 Pearl Rd', null, 41.361405, -81.812508, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Leneghan Academy of Irish Dance' and city = 'Middleburg Heights'
);
-- Leneghan Academy of Irish Dance, Middleburg Heights: 7501 PEARL RD, MIDDLEBURG HEIGHTS, OH, 44130

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Leneghan Academy of Irish Dance', 'leneghan-academy-of-irish-dance-euclid', 'Euclid', 'Ohio', 'United States', 'https://www.leneghanacademy.com/',
  '291 E 222nd St', '44123', 41.606846, -81.526769, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Leneghan Academy of Irish Dance' and city = 'Euclid'
);
-- Leneghan Academy of Irish Dance, Euclid: 291 E 222ND ST, EUCLID, OH, 44123

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Academy of Irish Dance', 'celtic-academy-of-irish-dance-dayton', 'Dayton', 'Ohio', 'United States', 'https://www.celticacademy.com/',
  '85 Woodman Dr', '45431', 39.768411, -84.123365, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Celtic Academy of Irish Dance' and city = 'Dayton'
);
-- Celtic Academy of Irish Dance, Dayton: 85 WOODMAN DR, DAYTON, OH, 45431

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Academy (Irish Dance Co)', 'the-academy-irish-dance-co-westerville', 'Westerville', 'Ohio', 'United States', 'https://www.theacademy-irishdance.com/',
  '6061 Chandler Ct', '43082', 40.154107, -82.923208, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The Academy (Irish Dance Co)' and city = 'Westerville'
);
-- The Academy (Irish Dance Co), Westerville: 6061 CHANDLER CT, WESTERVILLE, OH, 43082

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Academy (Irish Dance Co)', 'the-academy-irish-dance-co-strongsville', 'Strongsville', 'Ohio', 'United States', 'https://www.theacademy-irishdance.com/',
  null, null, 41.313200, -81.828500, 'city', 'city-centroid'
where not exists (
  select 1 from public.schools
  where name = 'The Academy (Irish Dance Co)' and city = 'Strongsville'
);
-- The Academy (Irish Dance Co), Strongsville: Strongsville, undefined undefined

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cannon Irish Dance', 'cannon-irish-dance-olmsted-falls', 'Olmsted Falls', 'Ohio', 'United States', 'https://www.csirishdance.com/',
  '8170 Mapleway Dr', '44138', 41.373272, -81.909572, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Cannon Irish Dance' and city = 'Olmsted Falls'
);
-- Cannon Irish Dance, Olmsted Falls: 8170 MAPLEWAY DR, OLMSTED FALLS, OH, 44138

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cannon Irish Dance', 'cannon-irish-dance-cleveland', 'Cleveland', 'Ohio', 'United States', 'https://www.csirishdance.com/',
  '5390 W 220th St', '44126', 41.428896, -81.864499, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Cannon Irish Dance' and city = 'Cleveland'
);
-- Cannon Irish Dance, Cleveland: 5390 W 220TH ST, CLEVELAND, OH, 44126

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Harmony Irish Dance', 'harmony-irish-dance-lancaster', 'Lancaster', 'Ohio', 'United States', 'https://harmonyirishdance.com/',
  '1623 Victor Rd NW', '43130', 39.749580, -82.651849, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Harmony Irish Dance' and city = 'Lancaster'
);
-- Harmony Irish Dance, Lancaster: 1623 VICTOR RD, LANCASTER, OH, 43130

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Nugent School of Irish Dance', 'nugent-school-of-irish-dance-centerville', 'Centerville', 'Ohio', 'United States', null,
  '941 E Franklin St', '45459', 39.628529, -84.140527, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Nugent School of Irish Dance' and city = 'Centerville'
);
-- Nugent School of Irish Dance, Centerville: 941 E FRANKLIN ST, CENTERVILLE, OH, 45459

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Moriarty Irish Dance Academy', 'moriarty-irish-dance-academy-reynoldsburg', 'Reynoldsburg', 'Ohio', 'United States', 'https://moriartyirishdance.com/',
  '2002 Officeview Pl', '43068', 39.940167, -82.828920, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Moriarty Irish Dance Academy' and city = 'Reynoldsburg'
);
-- Moriarty Irish Dance Academy, Reynoldsburg: 2002 OFFICEVIEW PL, REYNOLDSBURG, OH, 43068

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Erickson Academy of Irish Dance', 'erickson-academy-of-irish-dance-cincinnati', 'Cincinnati', 'Ohio', 'United States', 'https://www.ericksonirishdance.com/',
  '673 Wilmer Ave', '45226', 39.113796, -84.417990, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Erickson Academy of Irish Dance' and city = 'Cincinnati'
);
-- Erickson Academy of Irish Dance, Cincinnati: 673 WILMER AVE, CINCINNATI, OH, 45226

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Claddagh Columbus Irish Dance School', 'claddagh-columbus-irish-dance-school-worthington', 'Worthington', 'Ohio', 'United States', 'https://columbusirishdance.com/',
  '651 Lakeview Plaza Blvd Ste D', '43085', 40.113368, -82.998732, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Claddagh Columbus Irish Dance School' and city = 'Worthington'
);
-- Claddagh Columbus Irish Dance School, Worthington: 651 LAKEVIEW PLAZA BLVD, WORTHINGTON, OH, 43085

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGing Irish Dancers', 'mcging-irish-dancers-cincinnati', 'Cincinnati', 'Ohio', 'United States', 'https://www.mcgingdancers.com/',
  '8962 Blue Ash Rd', '45242', 39.221692, -84.383934, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGing Irish Dancers' and city = 'Cincinnati'
);
-- McGing Irish Dancers, Cincinnati: 8962 BLUE ASH RD, CINCINNATI, OH, 45242

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'The Irwin Academy of Irish Dance', 'the-irwin-academy-of-irish-dance-gahanna', 'Gahanna', 'Ohio', 'United States', 'https://www.irwinacademy.com/',
  '620 Taylor Station Rd Ste Q', '43230', 40.000980, -82.834656, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'The Irwin Academy of Irish Dance' and city = 'Gahanna'
);
-- The Irwin Academy of Irish Dance, Gahanna: 620 TAYLOR STATION RD, GAHANNA, OH, 43230

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Atlanta Irish Dance (Burke Connolly)', 'atlanta-irish-dance-atlanta', 'Atlanta', 'Georgia', 'United States', 'https://www.burkeconnolly.com/',
  '2219 Faulkner Rd NE', '30324', 33.811996, -84.357341, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Atlanta Irish Dance (Burke Connolly)' and city = 'Atlanta'
);
-- Atlanta Irish Dance (Burke Connolly), Atlanta: 2219 FAULKNER RD NE, ATLANTA, GA, 30324

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeNogla Academy', 'denogla-academy-little-falls', 'Little Falls', 'New Jersey', 'United States', 'https://www.denogla-academy.com/',
  '22 Muller Pl', '07424', 40.886377, -74.245151, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'DeNogla Academy' and city = 'Little Falls'
);
-- DeNogla Academy, Little Falls: 22 MULLER PL, LITTLE FALLS, NJ, 07424

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Woods School of Irish Dance', 'woods-school-of-irish-dance-south-boston', 'South Boston', 'Massachusetts', 'United States', 'https://www.woodsschoolirishdance.com/',
  '16 Ticknor St', '02127', 42.329711, -71.036064, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Woods School of Irish Dance' and city = 'South Boston'
);
-- Woods School of Irish Dance, South Boston: 16 TICKNOR ST, BOSTON, MA, 02127

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blackbird Academy', 'blackbird-academy-tinley-park', 'Tinley Park', 'Illinois', 'United States', 'https://blackbirdacademy.com/',
  '17749 Oak Park Ave', null, 41.568711, -87.784057, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Blackbird Academy' and city = 'Tinley Park'
);
-- Blackbird Academy, Tinley Park: 17749 OAK PARK AVE, TINLEY PARK, IL, 60477

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Haley School of Irish Dance', 'haley-school-of-irish-dance-whitman', 'Whitman', 'Massachusetts', 'United States', 'https://mhaleyirishdance.wixsite.com/haley-school-of-iris',
  '519 Washington St', '02382', 42.078910, -70.936622, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Haley School of Irish Dance' and city = 'Whitman'
);
-- Haley School of Irish Dance, Whitman: 519 WASHINGTON ST, WHITMAN, MA, 02382

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sullivan-Stewart School of Irish Dance', 'sullivan-stewart-school-of-irish-dance-plainville', 'Plainville', 'Massachusetts', 'United States', 'https://deirdresullivanste.wixsite.com/sullivanstewart',
  '1 George St', '02762', 42.007330, -71.311537, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Sullivan-Stewart School of Irish Dance' and city = 'Plainville'
);
-- Sullivan-Stewart School of Irish Dance, Plainville: 1 GEORGE ST, PLAINVILLE, MA, 02762

