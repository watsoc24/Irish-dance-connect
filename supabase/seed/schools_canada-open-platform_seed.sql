-- School directory seed — Canada (all provinces) + open-platform US schools (CRN / WIDA): 93 locations
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql.
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Every row below was verified 2026-11-12 from IDTANA Find a School, the
-- Eastern/Western Canada regional sites, CRN (crn.ie), WIDA GoFeis, the
-- FeisWorx school list as a cross-check, each school's own website, and
-- published feis results/programmes (Canadian National Irish Dance
-- Championships, Western Canadian Regional Oireachtas, Brady Spring Feis
-- 2026, Mae & Paddy Butler Feis). No address was invented. Street address +
-- postal code are shown ONLY where the school itself or Planxti publishes
-- them; otherwise the row is city-only. See
-- research_notes/irish-dance-schools-all-us/canada-open-platform.md for
-- sources and the full "Unverified / partial" list — nothing from that
-- section is seeded here. Prince Edward Island has no dedicated Irish
-- step-dance school found (0 rows); Yukon / Northwest Territories / Nunavut
-- none found.
--
-- One row per LOCATION: multi-location schools repeat the school name with
-- a distinct slug per location, so each location is searchable by distance.
--
-- Counts: Canada 86 — ON 26, QC 5, BC 23, AB 17, SK 6, MB 4, NS 3, NB 1,
-- NL 1. United States (open-platform only) 7 — PA 3 (McGinley Lemoyne, Rince
-- Ri Southampton, Irish Stars Hellertown), VA 2 (Rose & Sword Yorktown,
-- Crossroads North Chesterfield), KS 1 (Corry Kechi), NY 1 (Bethlehem
-- Traditional Irish Dance, Bethlehem/Delmar). 93 total; the research file
-- lists 99 verified — 6 rows were dropped or merged, see below. Street
-- precision 43 (36 Canada + 7 US), city precision 50.
--
-- Completeness (from the research file): coverage is built from regional feis
-- lists, results and school sites because IDTANA's Find a School map could
-- not be read directly, so a few small/school-only schools may still be
-- missing; the FeisWorx alpha list M–Z was never retrieved (rate-limited),
-- so schools known only from that half are unplaced. The public WIDA/GoFeis
-- schools list as crawled showed UK schools only (likely JS pagination), so
-- more US WIDA schools may exist beyond the three seeded here. Ontario
-- feis-list names with unknown locations (Wilson-Bryson-Dennis, Miller,
-- Taylor, Graham, O'Donnell, MacVoy, Plummer Donaghy, Rince Na Tiarna,
-- Crossbane-Grant, Doyle Corrigan, Gaelic Origins, Celtic Thunder, Sarnia)
-- are NOT seeded.
--
-- Postal codes: the schema's postal_code check accepts US ZIPs only
-- (^[0-9]{5}$), so Canadian postal codes CANNOT be stored in postal_code —
-- every Canada row has postal_code NULL even where a postal code was
-- verified. Verified Canadian postal codes are recorded in each row's
-- trailing comment instead (e.g. Ardan Academy, Windsor ON N8W 3S5). The US
-- open-platform rows in this file keep their verified 5-digit ZIPs.
--
-- website_url is NULL for 57 rows: 36 because the schools' sites are
-- http-only as published in the sources (Davidson Academy, De Menezes
-- Reilly, DeVoy Academy, Finnegan School ON, Goggin-Stewart, Johnson
-- Academy, Ottawa Irish Dance Company, Sue Fay Healy School, Bernadette
-- Short School, Blakey School Okanagan, O'Connor School BC, Sionnaine
-- Academy, Brady Academy CA/SK/MB, Possak Hampshire, Living Skies Irish
-- Dance, Prairie Gael School, SASK Irish Dance, Rince Ri Southampton,
-- Irish Stars Parker, Rose & Sword Yorktown, Crossroads, Bethlehem
-- Traditional Irish Dance), 19 because no website was found
-- (Butler-Fearon-O'Connor Ottawa/Montreal, Hamilton School ON, McGinley
-- Academy Georgetown ON, Sian McQuillan Academy, Yvonne Kelly Dance
-- Academy, Costello Irish Dance, Castilla School, Victoria School of Irish
-- Dance, Fort McMurray Celtic Dance Studio, Corry Academy, Greene School
-- Dartmouth, Siamsa Rince Gaelach, Mount Pearl School of Dance), 1 because
-- tonycomerford.com shows as an expired domain (Comerford School,
-- Vancouver BC), and 1 because its site was unresolvable from this
-- environment on 2026-11-12 (Edmonton Ceili Dancers — not proven dead,
-- re-check before linking). Every other https URL kept here was checked
-- live on 2026-11-12 (HTTP 200).
--
-- Coordinates: NONE of the 86 Canada rows carry coordinates. The US Census
-- Geocoder covers the United States only, and the Zippopotam.us Canada
-- endpoint returned 404 for every Canadian postal code tested on 2026-11-12,
-- so no sanctioned geocode source exists for Canada in this pass; the rows
-- keep latitude/longitude/geo_precision/geo_source NULL rather than invented
-- coordinates. The 7 US rows were geocoded with the US Census Geocoder
-- (Public_AR_Current benchmark); Corry Academy, Kechi KS (724 E Kechi Rd),
-- did not match Census and has no verified ZIP, so it is kept as published
-- with no coordinates. A Canada geocode pass (e.g. Nominatim or a postal
-- code lookup the project approves) is still needed before nearest-first
-- search works for Canadian visitors.
-- Blakey O'Brien Irish Dance has THREE studios in Calgary (Chinook,
-- Bonavista, Highwood) — same name, same city — so for those three rows the
-- idempotency guard is on the slug, not on name+city (a name+city guard
-- would block the 2nd and 3rd studios). Their slugs are
-- blakey-obrien-irish-dance-calgary-chinook / -bonavista / -highwood.
-- Merged/dropped rows (6): McGovern Irish Dance, Dayton OH and Troy OH
-- (CRN list copies — Ohio seed already has them); McGovern Lafayette IN and
-- Fort Wayne IN (CRN list copies — kept in the mid-america file); Breffny
-- Irish Dancers, Pittsfield MA (CRN list still uses the old Breffny name —
-- merged into the new-england file's Scoil Rince Bréifne Ó Ruairc,
-- Pittsfield, current name, with this file's street/ZIP carried over);
-- Rose & Sword Academy, Williamsburg VA (WIDA copy — merged into the
-- mid-atlantic file, with this file's street/ZIP carried over). Diaga Irish
-- Dance, Halifax NS, is counted once as Zeph Caissie Academy (same phone —
-- almost certainly a rename). McGinley Academy, Georgetown ON, is kept as
-- its own row; a possible link to the CRN McGinley School, Lemoyne PA, is
-- NOT assumed. McConnell schools (Cornwall ON, Winnipeg/Brandon MB,
-- Parksville BC) are separate schools/rows under similar names.
--
-- Idempotent: a row is inserted only when no school with the same name and
-- city already exists — except the three Blakey O'Brien Calgary rows, which
-- guard on slug (see above) — so the file is safe to re-run. Status is
-- 'unclaimed' (default) — these listings have not been claimed by the
-- schools.
-- ===========================================================================

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Aroon Academy of Irish Dance', 'aroon-academy-of-irish-dance-richmond-hill', 'Richmond Hill', 'Ontario', 'Canada', 'https://www.aroonirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Aroon Academy of Irish Dance' and city = 'Richmond Hill'
);
-- Aroon Academy of Irish Dance, Richmond Hill: Richmond Hill, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ardan Academy of Irish Dance', 'ardan-academy-of-irish-dance-windsor', 'Windsor', 'Ontario', 'Canada', 'https://www.ardanacademy.com/',
  '3595 Walker Road', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ardan Academy of Irish Dance' and city = 'Windsor'
);
-- Ardan Academy of Irish Dance, Windsor: 3595 Walker Road, Windsor, ON N8W 3S5 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Branton Academy of Irish Dance (Emerald Isle Dance Society)', 'branton-academy-of-irish-dance-emerald-isle-dance-society-windsor', 'Windsor', 'Ontario', 'Canada', 'https://www.irishdancewindsor.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Branton Academy of Irish Dance (Emerald Isle Dance Society)' and city = 'Windsor'
);
-- Branton Academy of Irish Dance (Emerald Isle Dance Society), Windsor: Windsor, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Butler-Fearon-O''Connor School of Irish Dance', 'butler-fearon-oconnor-school-of-irish-dance-ottawa', 'Ottawa', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Butler-Fearon-O''Connor School of Irish Dance' and city = 'Ottawa'
);
-- Butler-Fearon-O'Connor School of Irish Dance, Ottawa: Ottawa, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Academy Canada (Celtic Academy Irish Dance Canada)', 'celtic-academy-canada-celtic-academy-irish-dance-canada-erin', 'Erin', 'Ontario', 'Canada', 'https://celticacademy.ca/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Celtic Academy Canada (Celtic Academy Irish Dance Canada)' and city = 'Erin'
);
-- Celtic Academy Canada (Celtic Academy Irish Dance Canada), Erin: Erin, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Claddagh Irish Dance', 'claddagh-irish-dance-toronto', 'Toronto', 'Ontario', 'Canada', 'https://www.claddaghirishdanceto.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Claddagh Irish Dance' and city = 'Toronto'
);
-- Claddagh Irish Dance, Toronto: Toronto, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Cornell School of Irish Dance', 'cornell-school-of-irish-dance-chatham', 'Chatham', 'Ontario', 'Canada', 'https://irishdance.ca/',
  '19 King St E', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Cornell School of Irish Dance' and city = 'Chatham'
);
-- Cornell School of Irish Dance, Chatham: 19 King St E, Chatham, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Davidson Academy of Irish Dance', 'davidson-academy-of-irish-dance-mississauga', 'Mississauga', 'Ontario', 'Canada', null,
  '2570 Haines Road, Unit 2', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Davidson Academy of Irish Dance' and city = 'Mississauga'
);
-- Davidson Academy of Irish Dance, Mississauga: 2570 Haines Road, Unit 2, Mississauga, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'De Menezes Reilly Irish Dance', 'de-menezes-reilly-irish-dance-niagara-falls', 'Niagara Falls', 'Ontario', 'Canada', null,
  '6161 Thorold Stone Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'De Menezes Reilly Irish Dance' and city = 'Niagara Falls'
);
-- De Menezes Reilly Irish Dance, Niagara Falls: 6161 Thorold Stone Rd, Niagara Falls, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeVoy Academy of Irish Dance', 'devoy-academy-of-irish-dance-toronto', 'Toronto', 'Ontario', 'Canada', null,
  '2464 Yonge St, 2nd Floor', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'DeVoy Academy of Irish Dance' and city = 'Toronto'
);
-- DeVoy Academy of Irish Dance, Toronto: 2464 Yonge St, 2nd Floor, Toronto, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'DeVoy Academy of Irish Dance', 'devoy-academy-of-irish-dance-brampton', 'Brampton', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'DeVoy Academy of Irish Dance' and city = 'Brampton'
);
-- DeVoy Academy of Irish Dance, Brampton: Brampton, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan School of Irish Dance', 'finnegan-school-of-irish-dance-milton', 'Milton', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan School of Irish Dance' and city = 'Milton'
);
-- Finnegan School of Irish Dance, Milton: Milton, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Finnegan School of Irish Dance', 'finnegan-school-of-irish-dance-guelph', 'Guelph', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Finnegan School of Irish Dance' and city = 'Guelph'
);
-- Finnegan School of Irish Dance, Guelph: Guelph, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goggin-Stewart School of Irish Dance', 'goggin-stewart-school-of-irish-dance-oakville', 'Oakville', 'Ontario', 'Canada', null,
  '1040 South Service Rd E', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Goggin-Stewart School of Irish Dance' and city = 'Oakville'
);
-- Goggin-Stewart School of Irish Dance, Oakville: 1040 South Service Rd E, Oakville, ON L6J 2X7 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goggin-Stewart School of Irish Dance', 'goggin-stewart-school-of-irish-dance-london', 'London', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Goggin-Stewart School of Irish Dance' and city = 'London'
);
-- Goggin-Stewart School of Irish Dance, London: London, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Goggin-Stewart School of Irish Dance', 'goggin-stewart-school-of-irish-dance-st-thomas', 'St. Thomas', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Goggin-Stewart School of Irish Dance' and city = 'St. Thomas'
);
-- Goggin-Stewart School of Irish Dance, St. Thomas: St. Thomas, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Hamilton School of Irish Dance', 'hamilton-school-of-irish-dance-hamilton', 'Hamilton', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Hamilton School of Irish Dance' and city = 'Hamilton'
);
-- Hamilton School of Irish Dance, Hamilton: Hamilton, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Johnson Academy of Irish Dance (Johnson Irish Dance)', 'johnson-academy-of-irish-dance-johnson-irish-dance-toronto', 'Toronto', 'Ontario', 'Canada', null,
  '95 Lavinia Ave', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Johnson Academy of Irish Dance (Johnson Irish Dance)' and city = 'Toronto'
);
-- Johnson Academy of Irish Dance (Johnson Irish Dance), Toronto: 95 Lavinia Ave, Toronto, ON M6S 3H9 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance (The Kelly School)', 'kelly-school-of-irish-dance-the-kelly-school-mississauga', 'Mississauga', 'Ontario', 'Canada', 'https://thekellyschool.wixsite.com/kelly',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance (The Kelly School)' and city = 'Mississauga'
);
-- Kelly School of Irish Dance (The Kelly School), Mississauga: Mississauga, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kelly School of Irish Dance', 'kelly-school-of-irish-dance-belleville', 'Belleville', 'Ontario', 'Canada', 'https://thekellyschool.wixsite.com/kelly',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kelly School of Irish Dance' and city = 'Belleville'
);
-- Kelly School of Irish Dance, Belleville: Belleville, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGinley Academy of Irish Dance', 'mcginley-academy-of-irish-dance-georgetown', 'Georgetown', 'Ontario', 'Canada', null,
  '78 Mill St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McGinley Academy of Irish Dance' and city = 'Georgetown'
);
-- McGinley Academy of Irish Dance, Georgetown: 78 Mill St, Georgetown, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ottawa Irish Dance Company', 'ottawa-irish-dance-company-ottawa', 'Ottawa', 'Ontario', 'Canada', null,
  '1101 Baxter Rd, Unit 2', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ottawa Irish Dance Company' and city = 'Ottawa'
);
-- Ottawa Irish Dance Company, Ottawa: 1101 Baxter Rd, Unit 2, Ottawa, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Scoil Rince McConnell', 'scoil-rince-mcconnell-cornwall', 'Cornwall', 'Ontario', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Scoil Rince McConnell' and city = 'Cornwall'
);
-- Scoil Rince McConnell, Cornwall: Cornwall, ON (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sue Fay Healy School of Irish Dance (SFH Irish Dance Studio)', 'sue-fay-healy-school-of-irish-dance-sfh-irish-dance-studio-ottawa', 'Ottawa', 'Ontario', 'Canada', null,
  '174 Colonnade Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sue Fay Healy School of Irish Dance (SFH Irish Dance Studio)' and city = 'Ottawa'
);
-- Sue Fay Healy School of Irish Dance (SFH Irish Dance Studio), Ottawa: 174 Colonnade Rd, Ottawa, ON K2E 7M3 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sian McQuillan Academy of Irish Dance', 'sian-mcquillan-academy-of-irish-dance-toronto', 'Toronto', 'Ontario', 'Canada', null,
  '2 Wembley Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sian McQuillan Academy of Irish Dance' and city = 'Toronto'
);
-- Sian McQuillan Academy of Irish Dance, Toronto: 2 Wembley Rd, Toronto, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Yvonne Kelly Dance Academy (YKDA)', 'yvonne-kelly-dance-academy-ykda-newmarket', 'Newmarket', 'Ontario', 'Canada', null,
  '1211 Gorham St #6', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Yvonne Kelly Dance Academy (YKDA)' and city = 'Newmarket'
);
-- Yvonne Kelly Dance Academy (YKDA), Newmarket: 1211 Gorham St #6, Newmarket, ON (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bernadette Short School of Irish Dancing', 'bernadette-short-school-of-irish-dancing-kirkland', 'Kirkland', 'Quebec', 'Canada', null,
  '16743 Boul Hymus', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bernadette Short School of Irish Dancing' and city = 'Kirkland'
);
-- Bernadette Short School of Irish Dancing, Kirkland: 16743 Boul Hymus, Kirkland, QC (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bernadette Short School of Irish Dancing', 'bernadette-short-school-of-irish-dancing-chateauguay', 'Châteauguay', 'Quebec', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Bernadette Short School of Irish Dancing' and city = 'Châteauguay'
);
-- Bernadette Short School of Irish Dancing, Châteauguay: Châteauguay, QC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Butler-Fearon-O''Connor School of Irish Dance', 'butler-fearon-oconnor-school-of-irish-dance-montreal', 'Montreal', 'Quebec', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Butler-Fearon-O''Connor School of Irish Dance' and city = 'Montreal'
);
-- Butler-Fearon-O'Connor School of Irish Dance, Montreal: Montreal, QC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Costello Irish Dance', 'costello-irish-dance-saint-lazare', 'Saint-Lazare', 'Quebec', 'Canada', null,
  '1850 Rue des Loisirs, Local 123', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Costello Irish Dance' and city = 'Saint-Lazare'
);
-- Costello Irish Dance, Saint-Lazare: 1850 Rue des Loisirs, Local 123, Saint-Lazare, QC J7T 3B4 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Kilmartin Irish Dance School (KIDS)', 'kilmartin-irish-dance-school-kids-hudson', 'Hudson', 'Quebec', 'Canada', 'https://kilmartinirishdance.com/',
  '642 Main Road', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Kilmartin Irish Dance School (KIDS)' and city = 'Hudson'
);
-- Kilmartin Irish Dance School (KIDS), Hudson: 642 Main Road, Hudson, QC J0P 1H0 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blakey School — Okanagan', 'blakey-school-okanagan-kelowna', 'Kelowna', 'British Columbia', 'Canada', null,
  '1920 Kent Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Blakey School — Okanagan' and city = 'Kelowna'
);
-- Blakey School — Okanagan, Kelowna: 1920 Kent Rd, Kelowna, BC (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blakey School — Okanagan', 'blakey-school-okanagan-vernon', 'Vernon', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Blakey School — Okanagan' and city = 'Vernon'
);
-- Blakey School — Okanagan, Vernon: Vernon, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blakey School — Invermere', 'blakey-school-invermere', 'Invermere', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Blakey School — Invermere' and city = 'Invermere'
);
-- Blakey School — Invermere, Invermere: Invermere, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Castilla School of Irish Dance', 'castilla-school-of-irish-dance-kelowna', 'Kelowna', 'British Columbia', 'Canada', null,
  '721 Bernard Ave', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Castilla School of Irish Dance' and city = 'Kelowna'
);
-- Castilla School of Irish Dance, Kelowna: 721 Bernard Ave, Kelowna, BC (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Comerford School of Irish Dance — Vancouver', 'comerford-school-of-irish-dance-vancouver', 'Vancouver', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Comerford School of Irish Dance — Vancouver' and city = 'Vancouver'
);
-- Comerford School of Irish Dance — Vancouver, Vancouver: Vancouver, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McConnell Irish Dance', 'mcconnell-irish-dance-parksville', 'Parksville', 'British Columbia', 'Canada', 'https://www.mcconnelldancers.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McConnell Irish Dance' and city = 'Parksville'
);
-- McConnell Irish Dance, Parksville: Parksville, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Brien School of Irish Dance', 'obrien-school-of-irish-dance-victoria', 'Victoria', 'British Columbia', 'Canada', 'https://obrienirishdance.com/',
  '574b Culduthel Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Brien School of Irish Dance' and city = 'Victoria'
);
-- O'Brien School of Irish Dance, Victoria: 574b Culduthel Rd, Victoria, BC V8Z 1G1 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Brien School of Irish Dance', 'obrien-school-of-irish-dance-ladner', 'Ladner', 'British Columbia', 'Canada', 'https://obrienirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Brien School of Irish Dance' and city = 'Ladner'
);
-- O'Brien School of Irish Dance, Ladner: Ladner, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'O''Connor School of Irish Dance, BC', 'oconnor-school-of-irish-dance-bc-vancouver', 'Vancouver', 'British Columbia', 'Canada', null,
  '2020 W 6th Ave', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'O''Connor School of Irish Dance, BC' and city = 'Vancouver'
);
-- O'Connor School of Irish Dance, BC, Vancouver: 2020 W 6th Ave, Vancouver, BC (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Penk O''Donnell School of Irish Dancing', 'penk-odonnell-school-of-irish-dancing-burnaby', 'Burnaby', 'British Columbia', 'Canada', 'https://www.penkodonnell.ca/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Penk O''Donnell School of Irish Dancing' and city = 'Burnaby'
);
-- Penk O'Donnell School of Irish Dancing, Burnaby: Burnaby, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Penk O''Donnell School of Irish Dancing', 'penk-odonnell-school-of-irish-dancing-coquitlam', 'Coquitlam', 'British Columbia', 'Canada', 'https://www.penkodonnell.ca/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Penk O''Donnell School of Irish Dancing' and city = 'Coquitlam'
);
-- Penk O'Donnell School of Irish Dancing, Coquitlam: Coquitlam, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Penk O''Donnell School of Irish Dancing', 'penk-odonnell-school-of-irish-dancing-vancouver', 'Vancouver', 'British Columbia', 'Canada', 'https://www.penkodonnell.ca/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Penk O''Donnell School of Irish Dancing' and city = 'Vancouver'
);
-- Penk O'Donnell School of Irish Dancing, Vancouver: Vancouver, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine)', 'sionnaine-irish-dance-academy-dance-vancouver-sionnaine-burnaby', 'Burnaby', 'British Columbia', 'Canada', null,
  '8212 Amberwood Pl', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine)' and city = 'Burnaby'
);
-- Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine), Burnaby: 8212 Amberwood Pl, Burnaby, BC V5A 3V2 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Steel School of Irish Dance', 'steel-school-of-irish-dance-vancouver', 'Vancouver', 'British Columbia', 'Canada', 'https://www.steelschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Steel School of Irish Dance' and city = 'Vancouver'
);
-- Steel School of Irish Dance, Vancouver: Vancouver, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Steel School of Irish Dance', 'steel-school-of-irish-dance-cloverdale', 'Cloverdale', 'British Columbia', 'Canada', 'https://www.steelschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Steel School of Irish Dance' and city = 'Cloverdale'
);
-- Steel School of Irish Dance, Cloverdale: Cloverdale, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Steel School of Irish Dance', 'steel-school-of-irish-dance-white-rock', 'White Rock', 'British Columbia', 'Canada', 'https://www.steelschoolofirishdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Steel School of Irish Dance' and city = 'White Rock'
);
-- Steel School of Irish Dance, White Rock: White Rock, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ticálié Irish Dance Academy', 'ticalie-irish-dance-academy-west-kelowna', 'West Kelowna', 'British Columbia', 'Canada', 'https://www.ticalieacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ticálié Irish Dance Academy' and city = 'West Kelowna'
);
-- Ticálié Irish Dance Academy, West Kelowna: West Kelowna, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Ticálié Irish Dance Academy', 'ticalie-irish-dance-academy-kelowna', 'Kelowna', 'British Columbia', 'Canada', 'https://www.ticalieacademy.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Ticálié Irish Dance Academy' and city = 'Kelowna'
);
-- Ticálié Irish Dance Academy, Kelowna: Kelowna, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Victoria School of Irish Dance', 'victoria-school-of-irish-dance-victoria', 'Victoria', 'British Columbia', 'Canada', null,
  '1701 Island Hwy', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Victoria School of Irish Dance' and city = 'Victoria'
);
-- Victoria School of Irish Dance, Victoria: 1701 Island Hwy, Victoria, BC V9B 1J1 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Victoria School of Irish Dance', 'victoria-school-of-irish-dance-sidney', 'Sidney', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Victoria School of Irish Dance' and city = 'Sidney'
);
-- Victoria School of Irish Dance, Sidney: Sidney, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Victoria School of Irish Dance', 'victoria-school-of-irish-dance-westshore', 'Westshore', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Victoria School of Irish Dance' and city = 'Westshore'
);
-- Victoria School of Irish Dance, Westshore: Westshore, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Victoria School of Irish Dance', 'victoria-school-of-irish-dance-esquimalt', 'Esquimalt', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Victoria School of Irish Dance' and city = 'Esquimalt'
);
-- Victoria School of Irish Dance, Esquimalt: Esquimalt, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Victoria School of Irish Dance', 'victoria-school-of-irish-dance-nanaimo', 'Nanaimo', 'British Columbia', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Victoria School of Irish Dance' and city = 'Nanaimo'
);
-- Victoria School of Irish Dance, Nanaimo: Nanaimo, BC (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blakey O''Brien Irish Dance', 'blakey-obrien-irish-dance-calgary-chinook', 'Calgary', 'Alberta', 'Canada', 'https://www.blakeyobrien.com/',
  '5524 1A Street SW, Bay 4', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where slug = 'blakey-obrien-irish-dance-calgary-chinook'
);
-- Blakey O'Brien Irish Dance, Calgary: 5524 1A Street SW, Bay 4, Calgary, AB (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blakey O''Brien Irish Dance', 'blakey-obrien-irish-dance-calgary-bonavista', 'Calgary', 'Alberta', 'Canada', 'https://www.blakeyobrien.com/',
  '1215 Lake Sylvan Drive SE, Bay 15', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where slug = 'blakey-obrien-irish-dance-calgary-bonavista'
);
-- Blakey O'Brien Irish Dance, Calgary: 1215 Lake Sylvan Drive SE, Bay 15, Calgary, AB (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Blakey O''Brien Irish Dance', 'blakey-obrien-irish-dance-calgary-highwood', 'Calgary', 'Alberta', 'Canada', 'https://www.blakeyobrien.com/',
  '16 Harlow Ave NW', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where slug = 'blakey-obrien-irish-dance-calgary-highwood'
);
-- Blakey O'Brien Irish Dance, Calgary: 16 Harlow Ave NW, Calgary, AB (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-calgary', 'Calgary', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Calgary'
);
-- Brady Academy of Irish Dance, Calgary: Calgary, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-edmonton', 'Edmonton', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Edmonton'
);
-- Brady Academy of Irish Dance, Edmonton: Edmonton, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-fort-mcmurray', 'Fort McMurray', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Fort McMurray'
);
-- Brady Academy of Irish Dance, Fort McMurray: Fort McMurray, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Casey O''Loughlin Academy of Irish Dance', 'casey-oloughlin-academy-of-irish-dance-calgary', 'Calgary', 'Alberta', 'Canada', 'https://www.caseyacademy.com/',
  '5918 5th St SE', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Casey O''Loughlin Academy of Irish Dance' and city = 'Calgary'
);
-- Casey O'Loughlin Academy of Irish Dance, Calgary: 5918 5th St SE, Calgary, AB (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Celtic Ceilidh Dance Academy', 'celtic-ceilidh-dance-academy-edmonton', 'Edmonton', 'Alberta', 'Canada', 'https://celticceilidhdance.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Celtic Ceilidh Dance Academy' and city = 'Edmonton'
);
-- Celtic Ceilidh Dance Academy, Edmonton: Edmonton, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Fort McMurray Celtic Dance Studio (Celtic Dance Studio — FMM)', 'fort-mcmurray-celtic-dance-studio-celtic-dance-studio-fmm-fort-mcmurray', 'Fort McMurray', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Fort McMurray Celtic Dance Studio (Celtic Dance Studio — FMM)' and city = 'Fort McMurray'
);
-- Fort McMurray Celtic Dance Studio (Celtic Dance Studio — FMM), Fort McMurray: Fort McMurray, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Edmonton Ceili Dancers Association', 'edmonton-ceili-dancers-association-edmonton', 'Edmonton', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Edmonton Ceili Dancers Association' and city = 'Edmonton'
);
-- Edmonton Ceili Dancers Association, Edmonton: Edmonton, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Gott-Hughton Irish Dance Academy', 'gott-hughton-irish-dance-academy-calgary', 'Calgary', 'Alberta', 'Canada', 'https://iangottacademy.com/',
  '407 Forge Rd SE', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Gott-Hughton Irish Dance Academy' and city = 'Calgary'
);
-- Gott-Hughton Irish Dance Academy, Calgary: 407 Forge Rd SE, Calgary, AB (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Knock O''Hogan School of Irish Dance', 'knock-ohogan-school-of-irish-dance-edmonton', 'Edmonton', 'Alberta', 'Canada', 'https://www.knockohogan.com/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Knock O''Hogan School of Irish Dance' and city = 'Edmonton'
);
-- Knock O'Hogan School of Irish Dance, Edmonton: Edmonton, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mattierin School of Irish Dancing', 'mattierin-school-of-irish-dancing-edmonton', 'Edmonton', 'Alberta', 'Canada', 'https://www.mattierin.ca/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mattierin School of Irish Dancing' and city = 'Edmonton'
);
-- Mattierin School of Irish Dancing, Edmonton: Edmonton, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Possak Hampshire Academy of Irish Dance', 'possak-hampshire-academy-of-irish-dance-calgary', 'Calgary', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Possak Hampshire Academy of Irish Dance' and city = 'Calgary'
);
-- Possak Hampshire Academy of Irish Dance, Calgary: Calgary, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Possak Hampshire Academy of Irish Dance', 'possak-hampshire-academy-of-irish-dance-okotoks', 'Okotoks', 'Alberta', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Possak Hampshire Academy of Irish Dance' and city = 'Okotoks'
);
-- Possak Hampshire Academy of Irish Dance, Okotoks: Okotoks, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shamrock School of Irish Dance', 'shamrock-school-of-irish-dance-edmonton', 'Edmonton', 'Alberta', 'Canada', 'https://shamrockdance.ca/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Shamrock School of Irish Dance' and city = 'Edmonton'
);
-- Shamrock School of Irish Dance, Edmonton: Edmonton, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Shamrock School of Irish Dance', 'shamrock-school-of-irish-dance-fort-saskatchewan', 'Fort Saskatchewan', 'Alberta', 'Canada', 'https://shamrockdance.ca/',
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Shamrock School of Irish Dance' and city = 'Fort Saskatchewan'
);
-- Shamrock School of Irish Dance, Fort Saskatchewan: Fort Saskatchewan, AB (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-regina', 'Regina', 'Saskatchewan', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Regina'
);
-- Brady Academy of Irish Dance, Regina: Regina, SK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-saskatoon', 'Saskatoon', 'Saskatchewan', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Saskatoon'
);
-- Brady Academy of Irish Dance, Saskatoon: Saskatoon, SK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-prince-albert', 'Prince Albert', 'Saskatchewan', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Prince Albert'
);
-- Brady Academy of Irish Dance, Prince Albert: Prince Albert, SK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Living Skies Irish Dance', 'living-skies-irish-dance-regina', 'Regina', 'Saskatchewan', 'Canada', null,
  '1630 Albert St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Living Skies Irish Dance' and city = 'Regina'
);
-- Living Skies Irish Dance, Regina: 1630 Albert St, Regina, SK (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Prairie Gael School of Irish Dance', 'prairie-gael-school-of-irish-dance-regina', 'Regina', 'Saskatchewan', 'Canada', null,
  '1602 B McDonald St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Prairie Gael School of Irish Dance' and city = 'Regina'
);
-- Prairie Gael School of Irish Dance, Regina: 1602 B McDonald St, Regina, SK S4N 6R5 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'SASK Irish Dance', 'sask-irish-dance-saskatoon', 'Saskatoon', 'Saskatchewan', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'SASK Irish Dance' and city = 'Saskatoon'
);
-- SASK Irish Dance, Saskatoon: Saskatoon, SK (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Brady Academy of Irish Dance', 'brady-academy-of-irish-dance-winnipeg', 'Winnipeg', 'Manitoba', 'Canada', null,
  '1845 Portage Avenue', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Brady Academy of Irish Dance' and city = 'Winnipeg'
);
-- Brady Academy of Irish Dance, Winnipeg: 1845 Portage Avenue, Winnipeg, MB (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McConnell Irish Dance', 'mcconnell-irish-dance-winnipeg', 'Winnipeg', 'Manitoba', 'Canada', 'https://www.mcconnelldancers.com/',
  '2 Donald Street', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McConnell Irish Dance' and city = 'Winnipeg'
);
-- McConnell Irish Dance, Winnipeg: 2 Donald Street, Winnipeg, MB (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McConnell Irish Dance', 'mcconnell-irish-dance-brandon', 'Brandon', 'Manitoba', 'Canada', 'https://www.mcconnelldancers.com/',
  '126 10th St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McConnell Irish Dance' and city = 'Brandon'
);
-- McConnell Irish Dance, Brandon: 126 10th St, Brandon, MB R7A 4E7 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McDonnell School of Irish Dance', 'mcdonnell-school-of-irish-dance-winnipeg', 'Winnipeg', 'Manitoba', 'Canada', 'https://mcdonnellirishdance.com/',
  '460 Main St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'McDonnell School of Irish Dance' and city = 'Winnipeg'
);
-- McDonnell School of Irish Dance, Winnipeg: 460 Main St, Winnipeg, MB R3B 1B6 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Zeph Caissie Academy of Irish Dance (formerly Diaga Irish Dance)', 'zeph-caissie-academy-of-irish-dance-formerly-diaga-irish-dance-halifax', 'Halifax', 'Nova Scotia', 'Canada', 'https://www.zephcaissieacademy.ca/',
  '1505 Barrington St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Zeph Caissie Academy of Irish Dance (formerly Diaga Irish Dance)' and city = 'Halifax'
);
-- Zeph Caissie Academy of Irish Dance (formerly Diaga Irish Dance), Halifax: 1505 Barrington St, Halifax, NS (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Greene School of Irish Dance', 'greene-school-of-irish-dance-dartmouth', 'Dartmouth', 'Nova Scotia', 'Canada', null,
  '230 Pleasant St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Greene School of Irish Dance' and city = 'Dartmouth'
);
-- Greene School of Irish Dance, Dartmouth: 230 Pleasant St, Dartmouth, NS B2Y 3R8 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rising Tide Irish Dance Academy', 'rising-tide-irish-dance-academy-bedford', 'Bedford', 'Nova Scotia', 'Canada', 'https://risingtideacademy.ca/',
  '325 Rocky Lake Drive', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Rising Tide Irish Dance Academy' and city = 'Bedford'
);
-- Rising Tide Irish Dance Academy, Bedford: 325 Rocky Lake Drive, Bedford, NS B4A 2T3 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Siamsa Rince Gaelach Irish Dance Studio', 'siamsa-rince-gaelach-irish-dance-studio-fredericton', 'Fredericton', 'New Brunswick', 'Canada', null,
  '732 Charlotte St', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Siamsa Rince Gaelach Irish Dance Studio' and city = 'Fredericton'
);
-- Siamsa Rince Gaelach Irish Dance Studio, Fredericton: 732 Charlotte St, Fredericton, NB E3B 1M5 (postal not stored — schema postal_code is US ZIP only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Mount Pearl School of Dance (Irish dance — Rising Tide remote programme)', 'mount-pearl-school-of-dance-irish-dance-rising-tide-remote-programme-mount-pearl', 'Mount Pearl', 'Newfoundland and Labrador', 'Canada', null,
  null, null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Mount Pearl School of Dance (Irish dance — Rising Tide remote programme)' and city = 'Mount Pearl'
);
-- Mount Pearl School of Dance (Irish dance — Rising Tide remote programme), Mount Pearl: Mount Pearl, NL (city-only)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'McGinley School of Irish Dance', 'mcginley-school-of-irish-dance-lemoyne', 'Lemoyne', 'Pennsylvania', 'United States', 'https://www.mcginleyirishdancers.com/',
  '701 Pear Street', '17043', 40.242699, -76.898096, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'McGinley School of Irish Dance' and city = 'Lemoyne'
);
-- McGinley School of Irish Dance, Lemoyne: 701 PEAR ST, LEMOYNE, PA, 17043

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rince Ri School of Irish Dance', 'rince-ri-school-of-irish-dance-southampton', 'Southampton', 'Pennsylvania', 'United States', null,
  '1900 Bristol Rd', null, 40.173357, -75.001971, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rince Ri School of Irish Dance' and city = 'Southampton'
);
-- Rince Ri School of Irish Dance, Southampton: 1900 BRISTOL RD, SOUTHAMPTON, PA, 18966

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Corry Academy of Irish Dancing', 'corry-academy-of-irish-dancing-kechi', 'Kechi', 'Kansas', 'United States', null,
  '724 E Kechi Rd', null, null, null, null, null
where not exists (
  select 1 from public.schools
  where name = 'Corry Academy of Irish Dancing' and city = 'Kechi'
);
-- Corry Academy of Irish Dancing, Kechi: 724 E Kechi Rd, Kechi, KS (street address did not match Census (batch + single-lookup variants); no verified ZIP, so no coordinates — kept as published)

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Irish Stars Parker School of Irish Dance', 'irish-stars-parker-school-of-irish-dance-hellertown', 'Hellertown', 'Pennsylvania', 'United States', null,
  '427 Main St #3', null, 40.576717, -75.340533, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Irish Stars Parker School of Irish Dance' and city = 'Hellertown'
);
-- Irish Stars Parker School of Irish Dance, Hellertown: 427 MAIN ST, HELLERTOWN, PA, 18055

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Rose & Sword Academy of Irish Dance', 'rose-sword-academy-of-irish-dance-yorktown', 'Yorktown', 'Virginia', 'United States', null,
  '4839 George Washington Memorial Hwy', null, 37.152697, -76.461009, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Rose & Sword Academy of Irish Dance' and city = 'Yorktown'
);
-- Rose & Sword Academy of Irish Dance, Yorktown: 4839 GEORGE WASHINGTON MEMORIAL HWY, YORKTOWN, VA, 23692

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Crossroads Irish Dance', 'crossroads-irish-dance-north-chesterfield', 'North Chesterfield', 'Virginia', 'United States', null,
  '730 Research Road, Suite B', '23236', 37.503499, -77.602115, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Crossroads Irish Dance' and city = 'North Chesterfield'
);
-- Crossroads Irish Dance, North Chesterfield: 730 RESEARCH RD, NORTH CHESTERFIELD, VA, 23236

insert into public.schools
  (name, slug, city, region, country, website_url, street_address, postal_code, latitude, longitude, geo_precision, geo_source)
select
  'Bethlehem Traditional Irish Dance, LLC', 'bethlehem-traditional-irish-dance-llc-bethlehem', 'Bethlehem', 'New York', 'United States', null,
  '180 Delaware Ave', '12054', 42.628775, -73.812869, 'street', 'census'
where not exists (
  select 1 from public.schools
  where name = 'Bethlehem Traditional Irish Dance, LLC' and city = 'Bethlehem'
);
-- Bethlehem Traditional Irish Dance, LLC, Bethlehem: 180 DELAWARE AVE, DELMAR, NY, 12054
