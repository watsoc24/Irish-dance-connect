-- School directory updates — Canada geocode pass (Nominatim) — 32 coordinate fills
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql and
-- AFTER running all seed files (schools_*_seed.sql) and
-- schools_idtana_audit_seed.sql + schools_idtana_audit_updates.sql
-- (this file touches only the 32 rows below, so order against the audit
-- updates file does not matter).
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Geocoded 2026-11-12 with OpenStreetMap Nominatim
-- (https://nominatim.openstreetmap.org — strict usage policy: max 1 req/s,
-- single thread, real User-Agent; results cached). Every street address
-- below was verified from IDTANA, the regional council, the school's own
-- site, or Planxti — see schools_canada-open-platform_seed.sql. No coordinate
-- was invented: 3 of the 35 Canadian street rows could not be resolved and
-- are NOT in this file (listed below); their coordinates stay NULL.
--
-- Counts: 32 coordinate fills (all guarded by AND latitude IS NULL, so the
--   file is safe to re-run). All set geo_precision = 'street',
--   geo_source = 'nominatim'. Verified Canadian postal codes are recorded
--   in each row's comment only — the schema's postal_code check accepts US
--   5-digit ZIPs only, so a Canadian postal can never go in the column
--   (same pattern as schools_idtana_audit_updates.sql).
--
-- Precision notes (coordinates are the best Nominatim returned):
--   4 rows are road-level results — Nominatim has the road but no house
--     number, so the pin is on the road, not the building: Ardan Windsor
--     (Walker Rd), Sionnaine Burnaby (Amberwood Pl), Prairie Gael Regina
--     (McDonald St), McConnell Brandon (10th St).
--   1 row is a postcode centroid — Nominatim matched the postal code, not
--     the street: Kilmartin Hudson (J0P 1H0). Pin is the postcode area.
--   1 row resolved to a bus-stop feature carrying the house number:
--     Zeph Caissie Halifax (1505 Barrington St, highway/bus_stop) —
--     house number, road and city all match; pin sits on the stop.
--   2 postal-code discrepancies — the school-published postal is kept in
--     the comment; Nominatim returned a different one for the same
--     address: Goggin-Stewart Oakville (seed L6J 2X7, Nominatim L6H 3K4),
--     Costello Saint-Lazare (seed J7T 3B4, Nominatim J7T 3B5). Re-verify
--     the postal before using it anywhere else.
--
-- NOT geocoded (left NULL — do not invent coordinates for these):
--   O'Brien School of Irish Dance, Victoria BC (574b Culduthel Rd):
--     Nominatim returned nothing for the street; the postal code V8Z 1G1
--     resolves to Saanich, not Victoria — wrong city, not used.
--   Victoria School of Irish Dance, Victoria BC (1701 Island Hwy):
--     Nominatim returned nothing for the street; the postal code V9B 1J1
--     matched a place literally named "Canada" in Pike County, Kentucky,
--     USA — wrong city, not used.
--   Casey-O'Loughlin Academy, Calgary AB (5918 5th St SE): Nominatim
--     returned nothing for the street; no postal code was published, so
--     no postal fallback was possible.
--
-- McConnell Irish Dance, Winnipeg is NOT in this file — the audit updates
-- file already geocoded it (49.881192, -97.137532, nominatim).
-- ===========================================================================

-- Ardan Academy of Irish Dance, Windsor (ardan-academy-of-irish-dance-windsor): 3595 Walker Road, Windsor, Ontario N8W 3S5, Canada. Nominatim highway/secondary; Walker Road, Chrysler Canada Windsor Assembly Plant, South Walkerville, Windsor, Southwestern Ontario, Ontario, N8W 3P8, Canada — road-level result (no house number in OSM); pin is on the road, not the building
update public.schools
set
  latitude = 42.295455,
  longitude = -82.990147,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'ardan-academy-of-irish-dance-windsor' and latitude is null;

-- Cornell School of Irish Dance, Chatham (cornell-school-of-irish-dance-chatham): 19 King St E, Chatham, Ontario, Canada. Nominatim place/house; 19, King Street East, Downtown Chatham, Chatham, Chatham-Kent, Southwestern Ontario, Ontario, N7M 3N1, Canada
update public.schools
set
  latitude = 42.404854,
  longitude = -82.180898,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'cornell-school-of-irish-dance-chatham' and latitude is null;

-- Davidson Academy of Irish Dance, Mississauga (davidson-academy-of-irish-dance-mississauga): 2570 Haines Road, Unit 2, Mississauga, Ontario, Canada. Nominatim place/house; 2570, Haines Road, Dixie, Mississauga, Peel Region, Ontario, L4Y 4G6, Canada
update public.schools
set
  latitude = 43.597148,
  longitude = -79.596276,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'davidson-academy-of-irish-dance-mississauga' and latitude is null;

-- De Menezes Reilly Irish Dance, Niagara Falls (de-menezes-reilly-irish-dance-niagara-falls): 6161 Thorold Stone Rd, Niagara Falls, Ontario, Canada. Nominatim amenity/fast_food; McDonald's, 6161, Thorold Stone Road, Niagara Falls, Niagara Region, Ontario, L2J 1A4, Canada
update public.schools
set
  latitude = 43.115800,
  longitude = -79.095831,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'de-menezes-reilly-irish-dance-niagara-falls' and latitude is null;

-- DeVoy Academy of Irish Dance, Toronto (devoy-academy-of-irish-dance-toronto): 2464 Yonge St, 2nd Floor, Toronto, Ontario, Canada. Nominatim amenity/dancing_school; The Martha Hicks School of Ballet, 2464, Yonge Street, Mount Pleasant East, Eglinton—Lawrence, Toronto, Ontario, M4P 2H5, Canada
update public.schools
set
  latitude = 43.711265,
  longitude = -79.399593,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'devoy-academy-of-irish-dance-toronto' and latitude is null;

-- Goggin-Stewart School of Irish Dance, Oakville (goggin-stewart-school-of-irish-dance-oakville): 1040 South Service Rd E, Oakville, Ontario L6J 2X7, Canada. Nominatim place/house; 1040, South Service Road East, Oakville, Halton Region, Ontario, L6H 3K4, Canada — NOTE: Nominatim returned postal L6H 3K4 for this address; seed postal L6J 2X7 kept, re-verify
update public.schools
set
  latitude = 43.468403,
  longitude = -79.675467,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'goggin-stewart-school-of-irish-dance-oakville' and latitude is null;

-- Johnson Academy of Irish Dance (Johnson Irish Dance), Toronto (johnson-academy-of-irish-dance-johnson-irish-dance-toronto): 95 Lavinia Ave, Toronto, Ontario M6S 3H9, Canada. Nominatim amenity/community_centre; Swansea Town Hall, 95, Lavinia Avenue, Swansea, High Park-Swansea, Parkdale—High Park, Toronto, Ontario, M6S 4Z9, Canada
update public.schools
set
  latitude = 43.647611,
  longitude = -79.477856,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'johnson-academy-of-irish-dance-johnson-irish-dance-toronto' and latitude is null;

-- McGinley Academy of Irish Dance, Georgetown (mcginley-academy-of-irish-dance-georgetown): 78 Mill St, Georgetown, Ontario, Canada. Nominatim place/house; 78, Mill Street, Downtown Georgetown, Georgetown, Halton Hills, Halton Region, Ontario, L7G 3G3, Canada
update public.schools
set
  latitude = 43.650112,
  longitude = -79.925331,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'mcginley-academy-of-irish-dance-georgetown' and latitude is null;

-- Ottawa Irish Dance Company, Ottawa (ottawa-irish-dance-company-ottawa): 1101 Baxter Rd, Unit 2, Ottawa, Ontario, Canada. Nominatim office/newspaper; Ottawa Citizen, 1101, Baxter Road, College, Ottawa, Eastern Ontario, Ontario, K2C 1M1, Canada
update public.schools
set
  latitude = 45.352655,
  longitude = -75.781612,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'ottawa-irish-dance-company-ottawa' and latitude is null;

-- Sue Fay Healy School of Irish Dance (SFH Irish Dance Studio), Ottawa (sue-fay-healy-school-of-irish-dance-sfh-irish-dance-studio-ottawa): 174 Colonnade Rd, Ottawa, Ontario K2E 7M3, Canada. Nominatim building/commercial; 174, Colonnade Road South, Knoxdale-Merivale, Nepean, Ottawa, Eastern Ontario, Ontario, K2E 7J6, Canada
update public.schools
set
  latitude = 45.342419,
  longitude = -75.713347,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'sue-fay-healy-school-of-irish-dance-sfh-irish-dance-studio-ottawa' and latitude is null;

-- Sian McQuillan Academy of Irish Dance, Toronto (sian-mcquillan-academy-of-irish-dance-toronto): 2 Wembley Rd, Toronto, Ontario, Canada. Nominatim amenity/place_of_worship; Forest Hill United Church, 2, Wembley Road, Forest Hill North, Eglinton—Lawrence, Toronto, Ontario, M6C 2B6, Canada
update public.schools
set
  latitude = 43.701955,
  longitude = -79.426091,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'sian-mcquillan-academy-of-irish-dance-toronto' and latitude is null;

-- Yvonne Kelly Dance Academy (YKDA), Newmarket (yvonne-kelly-dance-academy-ykda-newmarket): 1211 Gorham St #6, Newmarket, Ontario, Canada. Nominatim building/industrial; 1211, Gorham Street, Newmarket, York Region, Ontario, L3Y 8E4, Canada
update public.schools
set
  latitude = 44.059061,
  longitude = -79.424156,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'yvonne-kelly-dance-academy-ykda-newmarket' and latitude is null;

-- Bernadette Short School of Irish Dancing, Kirkland (bernadette-short-school-of-irish-dancing-kirkland): 16743 Boul Hymus, Kirkland, Quebec, Canada. Nominatim place/house; 16743, Boulevard Hymus, Kirkland, Agglomération de Montréal, Montréal (région administrative), Québec, H9H 3W7, Canada
update public.schools
set
  latitude = 45.450698,
  longitude = -73.846861,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'bernadette-short-school-of-irish-dancing-kirkland' and latitude is null;

-- Costello Irish Dance, Saint-Lazare (costello-irish-dance-saint-lazare): 1850 Rue des Loisirs, Local 123, Saint-Lazare, Quebec J7T 3B4, Canada. Nominatim place/house; 1850, Rue des Loisirs, Saint-Lazare, Vaudreuil-Soulanges, Montérégie, Québec, J7T 3B5, Canada — NOTE: Nominatim returned postal J7T 3B5 for this address; seed postal J7T 3B4 kept, re-verify
update public.schools
set
  latitude = 45.397378,
  longitude = -74.141023,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'costello-irish-dance-saint-lazare' and latitude is null;

-- Kilmartin Irish Dance School (KIDS), Hudson (kilmartin-irish-dance-school-kids-hudson): 642 Main Road, Hudson, Quebec J0P 1H0, Canada. Nominatim place/postcode; J0P 1H0, Hudson, Vaudreuil-Soulanges, Montérégie, Québec, Canada — postcode-centroid result (J0P 1H0 matched, not the street); pin is the postcode area
update public.schools
set
  latitude = 45.459268,
  longitude = -74.160066,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'kilmartin-irish-dance-school-kids-hudson' and latitude is null;

-- Blakey School — Okanagan, Kelowna (blakey-school-okanagan-kelowna): 1920 Kent Rd, Kelowna, British Columbia, Canada. Nominatim place/house; 1920, Kent Road, Midtown, Kelowna, Westbank First Nation #9, Regional District of Central Okanagan, British Columbia, V1Y 7S6, Canada
update public.schools
set
  latitude = 49.878647,
  longitude = -119.454293,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'blakey-school-okanagan-kelowna' and latitude is null;

-- Castilla School of Irish Dance, Kelowna (castilla-school-of-irish-dance-kelowna): 721 Bernard Ave, Kelowna, British Columbia, Canada. Nominatim place/house; 721, Bernard Avenue, Kelowna, Westbank First Nation #9, Regional District of Central Okanagan, British Columbia, V1Y 6J3, Canada
update public.schools
set
  latitude = 49.886176,
  longitude = -119.488194,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'castilla-school-of-irish-dance-kelowna' and latitude is null;

-- O'Connor School of Irish Dance, BC, Vancouver (oconnor-school-of-irish-dance-bc-vancouver): 2020 W 6th Ave, Vancouver, British Columbia, Canada. Nominatim amenity/social_centre; Royal Canadian Legion - Branch 178 (Shalom), 2020, West 6th Avenue, Kitsilano, Vancouver, Metro Vancouver Regional District, British Columbia, V6J 1R9, Canada
update public.schools
set
  latitude = 49.266070,
  longitude = -123.151092,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'oconnor-school-of-irish-dance-bc-vancouver' and latitude is null;

-- Sionnaine Irish Dance Academy (Dance Vancouver — Sionnaine), Burnaby (sionnaine-irish-dance-academy-dance-vancouver-sionnaine-burnaby): 8212 Amberwood Pl, Burnaby, British Columbia V5A 3V2, Canada. Nominatim highway/residential; Amberwood Place, Forest Meadows, Burnaby Mountain, Burnaby, Metro Vancouver Regional District, British Columbia, V5A 4W2, Canada — road-level result (no house number in OSM); pin is on the road, not the building
update public.schools
set
  latitude = 49.262620,
  longitude = -122.924306,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'sionnaine-irish-dance-academy-dance-vancouver-sionnaine-burnaby' and latitude is null;

-- Blakey O'Brien Irish Dance, Calgary (blakey-obrien-irish-dance-calgary-chinook): 5524 1A Street SW, Bay 4, Calgary, Alberta, Canada. Nominatim building/commercial; 5524, 1A Street SW, Manchester, Calgary, Alberta, T2H 0E7, Canada
update public.schools
set
  latitude = 51.005006,
  longitude = -114.066839,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'blakey-obrien-irish-dance-calgary-chinook' and latitude is null;

-- Blakey O'Brien Irish Dance, Calgary (blakey-obrien-irish-dance-calgary-bonavista): 1215 Lake Sylvan Drive SE, Bay 15, Calgary, Alberta, Canada. Nominatim shop/mall; 1215, Lake Sylvan Drive SE, Bonavista Downs, Calgary, Alberta, T2J 2L1, Canada
update public.schools
set
  latitude = 50.942248,
  longitude = -114.032377,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'blakey-obrien-irish-dance-calgary-bonavista' and latitude is null;

-- Blakey O'Brien Irish Dance, Calgary (blakey-obrien-irish-dance-calgary-highwood): 16 Harlow Ave NW, Calgary, Alberta, Canada. Nominatim amenity/community_centre; Highwood Community Hall, 16, Harlow Avenue NW, Highwood, Calgary, Alberta, T2K 3H6, Canada
update public.schools
set
  latitude = 51.090816,
  longitude = -114.077403,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'blakey-obrien-irish-dance-calgary-highwood' and latitude is null;

-- Gott-Hughton Irish Dance Academy, Calgary (gott-hughton-irish-dance-academy-calgary): 407 Forge Rd SE, Calgary, Alberta, Canada. Nominatim place/house; 407, Forge Road SE, Fairview Industrial, Calgary, Alberta, T2H 0S8, Canada
update public.schools
set
  latitude = 50.992790,
  longitude = -114.055736,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'gott-hughton-irish-dance-academy-calgary' and latitude is null;

-- Living Skies Irish Dance, Regina (living-skies-irish-dance-regina): 1630 Albert St, Regina, Saskatchewan, Canada. Nominatim building/retail; 1630, Albert Street, Downtown, Regina, Saskatchewan, S4P 2S6, Canada
update public.schools
set
  latitude = 50.452834,
  longitude = -104.618591,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'living-skies-irish-dance-regina' and latitude is null;

-- Prairie Gael School of Irish Dance, Regina (prairie-gael-school-of-irish-dance-regina): 1602 B McDonald St, Regina, Saskatchewan S4N 6R5, Canada. Nominatim highway/primary; McDonald Street, Regina, Saskatchewan, S4P 3A1, Canada — road-level result (no house number in OSM); pin is on the road, not the building
update public.schools
set
  latitude = 50.480860,
  longitude = -104.572500,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'prairie-gael-school-of-irish-dance-regina' and latitude is null;

-- Brady Academy of Irish Dance, Winnipeg (brady-academy-of-irish-dance-winnipeg): 1845 Portage Avenue, Winnipeg, Manitoba, Canada. Nominatim building/yes; St. James Hall, 1845, Portage Avenue, King Edward, River Heights, Tuxedo, Winnipeg, Manitoba, R3J 0G7, Canada
update public.schools
set
  latitude = 49.878955,
  longitude = -97.216107,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'brady-academy-of-irish-dance-winnipeg' and latitude is null;

-- McConnell Irish Dance, Brandon (mcconnell-irish-dance-brandon): 126 10th St, Brandon, Manitoba R7A 4E7, Canada. Nominatim highway/tertiary; 10th Street, Trinity Park, East End, Brandon, Manitoba, R7A 3P6, Canada — road-level result (no house number in OSM); pin is on the road, not the building
update public.schools
set
  latitude = 49.835090,
  longitude = -99.951413,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'mcconnell-irish-dance-brandon' and latitude is null;

-- McDonnell School of Irish Dance, Winnipeg (mcdonnell-school-of-irish-dance-winnipeg): 460 Main St, Winnipeg, Manitoba R3B 1B6, Canada. Nominatim building/yes; 460, Main Street, Exchange District, St. Boniface, Downtown, Winnipeg, Manitoba, R3B 1B6, Canada
update public.schools
set
  latitude = 49.897516,
  longitude = -97.139498,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'mcdonnell-school-of-irish-dance-winnipeg' and latitude is null;

-- Zeph Caissie Academy of Irish Dance (formerly Diaga Irish Dance), Halifax (zeph-caissie-academy-of-irish-dance-formerly-diaga-irish-dance-halifax): 1505 Barrington St, Halifax, Nova Scotia, Canada. Nominatim highway/bus_stop; 6123 - Barrington St Before Spring Garden Rd, 1505, Barrington Street, Fort Massey, Downtown Halifax, Halifax, Halifax Regional Municipality, Halifax County, Nova Scotia, B3J 3K5, Canada — resolved to a bus-stop feature carrying house number 1505; pin sits on the stop
update public.schools
set
  latitude = 44.644117,
  longitude = -63.572310,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'zeph-caissie-academy-of-irish-dance-formerly-diaga-irish-dance-halifax' and latitude is null;

-- Greene School of Irish Dance, Dartmouth (greene-school-of-irish-dance-dartmouth): 230 Pleasant St, Dartmouth, Nova Scotia B2Y 3R8, Canada. Nominatim amenity/community_centre; North Woodside Community Centre, 230, Pleasant Street, Woodside, Dartmouth, Halifax Regional Municipality, Halifax County, Nova Scotia, B2Y 3R7, Canada
update public.schools
set
  latitude = 44.658211,
  longitude = -63.551312,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'greene-school-of-irish-dance-dartmouth' and latitude is null;

-- Rising Tide Irish Dance Academy, Bedford (rising-tide-irish-dance-academy-bedford): 325 Rocky Lake Drive, Bedford, Nova Scotia B4A 2T3, Canada. Nominatim building/yes; 325, Rocky Lake Drive, Bedford Trade Mart, Rocky Lake, Bedford, Halifax Regional Municipality, Halifax County, Nova Scotia, B4A 2T3, Canada
update public.schools
set
  latitude = 44.738167,
  longitude = -63.645555,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'rising-tide-irish-dance-academy-bedford' and latitude is null;

-- Siamsa Rince Gaelach Irish Dance Studio, Fredericton (siamsa-rince-gaelach-irish-dance-studio-fredericton): 732 Charlotte St, Fredericton, New Brunswick E3B 1M5, Canada. Nominatim amenity/arts_centre; Charlotte Street Arts Centre, 732, Rue Charlotte Street, Queen's Park, Town Plat, Fredericton, City of Fredericton, York County, New Brunswick / Nouveau-Brunswick, E3B 1M5, Canada
update public.schools
set
  latitude = 45.955763,
  longitude = -66.639327,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'siamsa-rince-gaelach-irish-dance-studio-fredericton' and latitude is null;
