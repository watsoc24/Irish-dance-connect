-- School directory updates — IDTANA audit address/coordinate upgrades (122 address updates + 4 website fills)
-- ===========================================================================
-- Run this in Supabase Dashboard -> SQL Editor against the live project,
-- AFTER applying supabase/migrations/20261112000000_schools_geo.sql and
-- AFTER running schools_idtana_audit_seed.sql (the two files touch different
-- rows, so order between them does not matter).
-- DO NOT run it against a test database or the RLS shim (see README).
--
-- Reconciled 2026-11-12 from the seven regional IDTANA audit reports in
-- ~/workspace/research_notes/irish-dance-schools-idtana-audit/. Every
-- address below was verified from IDTANA, the regional council, or the
-- school's / venue's own site — see the per-statement comment. No address
-- was invented.
--
-- Counts: 106 street-address upgrades to city-only rows (guarded by
--   AND street_address IS NULL), 9 US ZIP-only fills for rows that
--   already have a street (guarded by AND postal_code IS NULL), 7
--   corrections/replacements of a wrong or stale seeded value (no IS NULL
--   guard — they deliberately overwrite), 4 website fills for seeded
--   rows with a NULL (or Facebook-only) website, and 7 Canadian
--   postal-code verifications recorded as comments only (postal_code is US
--   5-digit ZIP only, so a Canadian postal can never go in the column).
--   105 of the address updates carry coordinates (US Census Geocoder
--   or Nominatim); 8 carry a verified street address the
--   geocoders could not match, so their coordinates stay NULL.
--
-- Coordinates travel with their street address: where a correction replaces
-- a street whose old coordinates are on file (Harris-Grieco Kenmore,
-- Shovlin Pittsburgh), and the new street could not be geocoded, the old
-- latitude/longitude/geo_precision/geo_source are set to NULL rather than
-- left pointing at the old address.
--
-- DO NOT APPLY — unresolved conflicts (nothing below overwrites these):
--   Rince Na Sonas, Liverpool NY — seeded ZIP 13090 vs IDTANA 13088 for
--     604 Old Liverpool Rd. Verify before changing.
--   Hunt School, Crofton MD — seeded Suite 11 vs IDTANA #12 at
--     2431 Crofton Ln. Suite-number conflict.
--   Brady Academy, Edmonton AB — WCIDTA gives two different Edmonton
--     addresses (12964-52 St, T5A 0B8 vs 12832 53 St NW); own site gives
--     none. No upgrade.
--   Mattierin School, Edmonton AB — IDTANA #4 15808 112 Ave NW vs WCIDTA
--     12621-125 Street NW; own site gives none. No upgrade.
--   Steel School, White Rock / South Surrey BC — IDTANA Unit 15, 15515
--     24 Ave, V4A 2J4 vs WCIDTA #108, 15585 24 Ave (different street
--     numbers). No upgrade for the White Rock row.
--   Kelly School, Greater Providence RI — IDTANA 10 Exchange Court,
--     Pawtucket RI 02903 vs own site KSID at Moses Brown, 250 Lloyd Ave,
--     Providence RI 02906. Own site preferred; Pawtucket not applied.
--   Inis Acla, Memphis TN — IDTANA venue 1705 Poplar Ave vs listing
--     820 Herbert Rd (studio vs venue). The school is seeded city-only in
--     the audit seed file; no address applied here.
--   Goode Academy, Tulsa OK — IDTANA 3872 S Hudson Ave vs live listing
--     3972 S Hudson Ave. Street-number conflict; no upgrade.
--   Cass-Barrington, Katy TX — IDTANA 1012 S Mason Rd #100 vs place
--     listing 4142 Dayflower Dr, Katy. No upgrade.
--   McTeggart North Texas, Hurst TX — old North Richland Hills address
--     (8401 Boulevard 26 Ste 7, 76180) is superseded; the CURRENT address
--     (145 West Harwood Rd, 76054) IS applied below.
--   Morgan Legacy, Falls Church VA — seeded 900 S Washington St #B101
--     (McGrath Academy's studio per its own site) vs IDTANA Ballet Nova,
--     3443 Carlin Springs Rd. Seeded row left untouched.
--   Morgan Legacy, Rockville MD — IDTANA typo Nicklson Ln; seeded
--     spelling (5050 Nicholson Ln, Suite D) is correct. No change.
--   Walsh Kelley, Charlotte NC — seeded 5668 International Dr, 28270
--     matches the school's own site; IDTANA's 709 International Dr Ste F
--     conflicts. Seeded address kept.
--   Sullivan School, Newton MA — QUALIFIED: own site publishes only a
--     Watertown contact/mailing address (520 Pleasant St, Watertown MA
--     02472), not the Newton studio. No address applied.
--   McTeggart Kentucky, Berea KY — venue name only (First Christian
--     Church, Berea), no street address published. No update.
--   Castilla, Kelowna BC — IDTANA 1180 Houghton Rd conflicts with the
--     school's own site (721 Bernard Ave, matching the seed) and WCIDTA's
--     21 Bernard Ave (evident typo for 721). Seeded address kept.
--   Keenan School, Petaluma CA — IDTANA carries two addresses (326
--     Petaluma Blvd N, 94952 and 451 Almanor Ave) vs the seeded own-site
--     address (211 Liberty St, 94952). Unresolved; no rows added.
--   Rise Academy, Clearfield UT — IDTANA 540 E 1700 S Clearfield (no ZIP)
--     vs own-site footer 739 N 2475 W, Layton UT 84041 (already seeded).
--     Seeded Layton address kept.
--   Legacy, Mt. Pleasant SC — street 561 Belle Station Blvd already
--     seeded; ZIP still not verified anywhere. No upgrade.
--   Sionnaine, Vancouver BC — no separate row (Wednesday Vancouver
--     classes likely at the seeded Burnaby studio).
--   McNulty park-district locations (16 seeded rows) — IDTANA and the
--     school's own site give city names only; no street addresses exist to
--     apply. Lead only (not verified): 4222 N Arlington Heights Rd,
--     Arlington Heights IL 60004 (2019-20 ArtLook report).
--
-- CANADIAN POSTALS VERIFIED (comment-only — postal_code is US ZIP only):
--   Costello Irish Dance, Saint-Lazare QC — J7T 3B4; Kilmartin Irish Dance
--     School, Hudson QC — J0P 1H0; Sue Fay Healy School, Ottawa ON —
--     K2E 7M3; Johnson Academy, Toronto ON — M6S 3H9; Goggin-Stewart,
--     Oakville ON — L6J 2X7; McConnell Irish Dance, Brandon MB — R7A 4E7;
--     Gott-Hughton Irish Dance Academy, Calgary AB — T2H 0S9. (Each is
--     also recorded on its own statement comment below.)
--
-- NOTES ON SECOND VENUES (one street column per row):
--   Tara Academy, Seattle WA — IDTANA also lists a second Seattle studio
--     (8551 Greenwood Ave N Suite 4, Seattle WA 98103); the row already has
--     14032 Aurora Ave N. No schema for a second address; recorded here.
--   SASK Irish Dance, Saskatoon SK — second studio A2-1502 Quebec Ave
--     (WCIDTA); Hanselman Court address applied below.
--   Clann Kelly, Houston TX — second venue 4007 D Bellaire Blvd, Houston
--     TX 77025 (West University Dance Center); 747 N Shepherd Dr applied.
--   Lenahan, Sparta NJ — second venue 329 Sparta Ave, Sparta NJ.
--
-- UNGEOCODED UPGRADES/CORRECTIONS (street text applied, coordinates NULL):
--   Harris-Grieco Kenmore NY (3200 Elmwood Ave; old coords nulled);
--   Shovlin Pittsburgh PA (5 Lobaugh St, Oakdale; old coords nulled);
--   Anam Cara Stamford CT (72 Camp Ave); BoSoma Hamilton MA (15 Walnut Rd);
--   McGough Rehoboth Beach DE (34823 Derrickson Dr); Champagne North
--   Liberty IA (365 Beaver Creek Center); Maguire Houston TX
--   (24914 Tomball Pkwy); McTeggart Fort Collins CO
--   (1532 E Mulberry St Unit B).
--   (Geocoded by single-lookup retry after a Census batch tie/no-match:
--   Hamlin Cameron NC, Maguire Dallas TX, McTeggart Kentucky Lexington KY,
--   Eilís Academy Twin Cities MN via Anoka, Heritage Clinton NJ via
--   Annandale, Carroll-Henderson Edmonds WA via Lynnwood, Irish Dance
--   Company North Castle NY via White Plains.)
-- ===========================================================================

-- Clann na Cara / Harris-Grieco Academy of Irish Dance, Kenmore (clann-na-cara-harris-grieco-academy-of-irish-dance-kenmore): 3200 Elmwood Ave, Kenmore, New York 14217. Own-site footer; replaces seeded 2958 Delaware Ave; site writes Buffalo, NY 14217, ZIP is Kenmore
update public.schools
set
  street_address = '3200 Elmwood Ave',
  postal_code = '14217',
  latitude = null,
  longitude = null,
  geo_precision = null,
  geo_source = null
where slug = 'clann-na-cara-harris-grieco-academy-of-irish-dance-kenmore';

-- Shovlin Academy of Irish Dance, Pittsburgh (shovlin-academy-of-irish-dance-pittsburgh): 5 Lobaugh St, Pittsburgh, Pennsylvania 15071. Current studio Oakdale/Collier Twp per IDTANA + directory listing; seeded 1444 Hillsdale Ave Pittsburgh 15216 is from a 2007-08 schedule (Dormont Municipal Building)
update public.schools
set
  street_address = '5 Lobaugh St',
  postal_code = '15071',
  latitude = null,
  longitude = null,
  geo_precision = null,
  geo_source = null
where slug = 'shovlin-academy-of-irish-dance-pittsburgh';

-- Steel School of Irish Dance, Vancouver (steel-school-of-irish-dance-vancouver): 65A Avenue, Panorama Ridge, Newton, Surrey, Metro Vancouver Regional District, British Columbia, V3X 1G1, Canada. [Canadian postal V3S 5N4 — not stored in postal_code column.] Row is Surrey, not Vancouver (IDTANA + WCIDTA + own site); founded Vancouver 1981, classes now Surrey/Cloverdale/White Rock
update public.schools
set
  street_address = 'Unit 104 - 17670 65A Ave',
  city = 'Surrey',
  latitude = 49.121175,
  longitude = -122.849684,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'steel-school-of-irish-dance-vancouver';

-- Hamilton School of Irish Dance, Hamilton (hamilton-school-of-irish-dance-hamilton): 166, Saunders Road, Barrie, Central Ontario, Ontario, L4N 6B3, Canada. Relocated Hamilton -> Barrie per own site (hamiltonirishdance.com); no Hamilton street ever published; slug kept (identifier only)
update public.schools
set
  street_address = '166 Saunders Rd',
  city = 'Barrie',
  latitude = 44.332555,
  longitude = -79.676138,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'hamilton-school-of-irish-dance-hamilton';

-- McConnell Irish Dance, Winnipeg (mcconnell-irish-dance-winnipeg): Donald Street, River–Osborne, Osborne Village, Downtown, Winnipeg, Manitoba, R3L 2S6, Canada. Own site; adds unit no. to seeded '2 Donald Street'
update public.schools
set
  street_address = 'Unit 6 - 2 Donald St',
  latitude = 49.881192,
  longitude = -97.137532,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'mcconnell-irish-dance-winnipeg';

-- McTeggart Irish Dancers of North Texas, Hurst (mcteggart-irish-dancers-of-north-texas-hurst): 145 W HARWOOD RD, HURST, TX, 76054. IDTANA + own-site footer 2026; older North Richland Hills address (8401 Boulevard 26 Ste 7, 76180) superseded - use current one only
update public.schools
set
  street_address = '145 West Harwood Rd',
  postal_code = '76054',
  latitude = 32.848636,
  longitude = -97.174210,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcteggart-irish-dancers-of-north-texas-hurst';

-- Legacy Irish Dance Academy, Summerville (legacy-irish-dance-academy-summerville): 119 E 4TH NORTH ST, SUMMERVILLE, SC, 29483. 2026-2027 class schedule (Summerville Dance Academy); supersedes IDTANA older 351 Old Summerville Rd
update public.schools
set
  street_address = '119 E 4th N St',
  postal_code = '29483',
  latitude = 33.025098,
  longitude = -80.170816,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'legacy-irish-dance-academy-summerville';

-- Mulcahy Academy of Irish Dance, Glastonbury (mulcahy-academy-of-irish-dance-glastonbury): 160 OAK ST, GLASTONBURY, CT, 06033. IDTANA; no ZIP published. FLAG: Feb 2026 Glastonbury zoning agenda lists a proposed Mulcahy studio change at 313 New London Tpke - 160 Oak St may be superseded, verify before relying
update public.schools
set
  street_address = '160 Oak St, Suite 212',
  latitude = 41.710257,
  longitude = -72.591779,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mulcahy-academy-of-irish-dance-glastonbury' and street_address is null;

-- Horgan Academy of Irish Dance, Naugatuck (horgan-academy-of-irish-dance-naugatuck): 198 MEADOW ST, NAUGATUCK, CT, 06770. IDTANA
update public.schools
set
  street_address = '198 Meadow Street',
  postal_code = '06770',
  latitude = 41.492718,
  longitude = -73.056092,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'horgan-academy-of-irish-dance-naugatuck' and street_address is null;

-- Scoil Rince Luimni, South Windsor (scoil-rince-luimni-south-windsor): 400 CHAPEL RD, SOUTH WINDSOR, CT, 06074. IDTANA
update public.schools
set
  street_address = '400 Chapel Road, 2H',
  postal_code = '06074',
  latitude = 41.810245,
  longitude = -72.605655,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'scoil-rince-luimni-south-windsor' and street_address is null;

-- Anam Cara Irish Dance School, Stamford (anam-cara-irish-dance-school-stamford): 72 Camp Avenue, Stamford, Connecticut 06907. IDTANA; studio address (mailing 94 Club Rd 06905 not used)
update public.schools
set
  street_address = '72 Camp Avenue',
  postal_code = '06907'
where slug = 'anam-cara-irish-dance-school-stamford' and street_address is null;

-- Harney Pender Keady Academy of Irish Dance, Stamford (harney-pender-keady-academy-of-irish-dance-stamford): 9 HYDE ST, STAMFORD, CT, 06907. IDTANA
update public.schools
set
  street_address = '9 Hyde Street',
  postal_code = '06907',
  latitude = 41.093845,
  longitude = -73.517671,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'harney-pender-keady-academy-of-irish-dance-stamford' and street_address is null;

-- Griffith Academy of Irish Dance, Wethersfield (griffith-academy-of-irish-dance-wethersfield): 275 MAIN ST, WETHERSFIELD, CT, 06109. IDTANA + own site mailing address
update public.schools
set
  street_address = '275 Main St',
  postal_code = '06109',
  latitude = 41.714204,
  longitude = -72.652724,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'griffith-academy-of-irish-dance-wethersfield' and street_address is null;

-- Thorne Academy of Irish Dance, Danbury (thorne-academy-of-irish-dance-danbury): 6 LAKE AVE, DANBURY, CT, 06810. School business listing; ZIP from co-located Greater Danbury Irish Cultural Center
update public.schools
set
  street_address = '6 Lake Ave Ext',
  postal_code = '06810',
  latitude = 41.391784,
  longitude = -73.465083,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'thorne-academy-of-irish-dance-danbury' and street_address is null;

-- Brennan-Lucey Irish Dance Academy, Hamden (brennan-lucey-irish-dance-academy-hamden): 109 SANFORD ST, HAMDEN, CT, 06514. Own site schedule; Studio 2, Joni's Dance Center, 109 Sanford Street, Unit D-2
update public.schools
set
  street_address = '109 Sanford St, Unit D-2',
  postal_code = '06514',
  latitude = 41.381752,
  longitude = -72.915267,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'brennan-lucey-irish-dance-academy-hamden' and street_address is null;

-- Heavey Quinn Academy of Irish Dance, Framingham (heavey-quinn-academy-of-irish-dance-framingham): 92 BLANDIN AVE, FRAMINGHAM, MA, 01702. IDTANA; also fills seeded NULL website
update public.schools
set
  street_address = '92 Blandin Ave',
  postal_code = '01702',
  website_url = 'https://www.heaveyquinn.com/',
  latitude = 42.274205,
  longitude = -71.410677,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'heavey-quinn-academy-of-irish-dance-framingham' and street_address is null;

-- Petrocelli Academy of Irish Dance, Pembroke (petrocelli-academy-of-irish-dance-pembroke): 808 WASHINGTON ST, PEMBROKE, MA, 02359. IDTANA + own site; also fills seeded NULL website
update public.schools
set
  street_address = '808 Washington Street',
  postal_code = '02359',
  website_url = 'https://petrocelliacademyid.com/',
  latitude = 42.066071,
  longitude = -70.775147,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'petrocelli-academy-of-irish-dance-pembroke' and street_address is null;

-- Forbes School of Irish Dance, Quincy (forbes-school-of-irish-dance-quincy): 7 FOSTER ST, QUINCY, MA, 02169. IDTANA; no ZIP published; former 38 Woodward Ave location closed
update public.schools
set
  street_address = '7 Foster St',
  latitude = 42.249647,
  longitude = -71.000770,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'forbes-school-of-irish-dance-quincy' and street_address is null;

-- O'Shea-Chaplin Academy of Irish Dance, Melrose (oshea-chaplin-academy-of-irish-dance-melrose): 121 W FOSTER ST, MELROSE, MA, 02176. Own site 2026-27 schedule; First Congregational Church; no ZIP published
update public.schools
set
  street_address = '121 W Foster Street',
  latitude = 42.455157,
  longitude = -71.067413,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'oshea-chaplin-academy-of-irish-dance-melrose' and street_address is null;

-- O'Shea-Chaplin Academy of Irish Dance, Watertown (oshea-chaplin-academy-of-irish-dance-watertown): 151 WATERTOWN ST, WATERTOWN, MA, 02472. Own site 2026-27 schedule; AOH Hibernian Hall; no ZIP published
update public.schools
set
  street_address = '151 Watertown Street',
  latitude = 42.362634,
  longitude = -71.192319,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'oshea-chaplin-academy-of-irish-dance-watertown' and street_address is null;

-- BoSoma School of Irish Dance, Georgetown (bosoma-school-of-irish-dance-georgetown): 52 CENTRAL ST, GEORGETOWN, MA, 01833. Own site; no ZIP published
update public.schools
set
  street_address = '52 Central St',
  latitude = 42.721445,
  longitude = -70.992410,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'bosoma-school-of-irish-dance-georgetown' and street_address is null;

-- BoSoma School of Irish Dance, Hamilton (bosoma-school-of-irish-dance-hamilton): 15 Walnut Road, Hamilton, Massachusetts. Own site; no ZIP published
update public.schools
set
  street_address = '15 Walnut Road'
where slug = 'bosoma-school-of-irish-dance-hamilton' and street_address is null;

-- Kanaley School of Irish Dance, East Wareham (kanaley-school-of-irish-dance-east-wareham): 3187 CRANBERRY HWY, EAST WAREHAM, MA, 02538. Own site; no ZIP published
update public.schools
set
  street_address = '3187 Cranberry Highway',
  latitude = 41.750801,
  longitude = -70.630220,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'kanaley-school-of-irish-dance-east-wareham' and street_address is null;

-- Kanaley School of Irish Dance, Yarmouth (kanaley-school-of-irish-dance-yarmouth): 633 MAIN ST, W YARMOUTH, MA, 02673. Business listing (lower confidence - street not stated on own site pages fetched); no ZIP published
update public.schools
set
  street_address = '633 Main St',
  latitude = 41.649110,
  longitude = -70.227305,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'kanaley-school-of-irish-dance-yarmouth' and street_address is null;

-- Claddagh School of Irish Dance, Springfield (claddagh-school-of-irish-dance-springfield): 33 PROGRESS AVE, SPRINGFIELD, MA, 01104. Own site + venue site; John Boyle O'Reilly Club
update public.schools
set
  street_address = '33 Progress Ave',
  postal_code = '01104',
  latitude = 42.142511,
  longitude = -72.534334,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'claddagh-school-of-irish-dance-springfield' and street_address is null;

-- Murphy Academy of Irish Dance, South Grafton (murphy-academy-of-irish-dance-south-grafton): 16 FERRY ST, SOUTH GRAFTON, MA, 01560. IDTANA; IDTANA city is Grafton; venue for seeded South Grafton row
update public.schools
set
  street_address = '16 Ferry Street',
  postal_code = '01560',
  latitude = 42.177081,
  longitude = -71.694557,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'murphy-academy-of-irish-dance-south-grafton' and street_address is null;

-- Harney-Crawford Academy of Irish Dance, Walpole (harney-crawford-academy-of-irish-dance-walpole): 945 MAIN ST, WALPOLE, MA, 02081. Own site; same Walpole studio IDTANA lists for Harney Pender Keady
update public.schools
set
  street_address = '945 Main Street',
  postal_code = '02081',
  latitude = 42.146652,
  longitude = -71.252492,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'harney-crawford-academy-of-irish-dance-walpole' and street_address is null;

-- Kelly School of Irish Dance, Bristol (kelly-school-of-irish-dance-bristol): 1 SHANNON CT, BRISTOL, RI, 02809. IDTANA + own site
update public.schools
set
  street_address = '1 Shannon Court',
  postal_code = '02809',
  latitude = 41.702283,
  longitude = -71.269102,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'kelly-school-of-irish-dance-bristol' and street_address is null;

-- Kelly School of Irish Dance, Cranston (kelly-school-of-irish-dance-cranston): 50 AMERICA ST, CRANSTON, RI, 02920. Own site + IDTANA (Goulding entry); Irish Ceilidhe Club of RI
update public.schools
set
  street_address = '50 America Street',
  postal_code = '02920',
  latitude = 41.784101,
  longitude = -71.462810,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'kelly-school-of-irish-dance-cranston' and street_address is null;

-- Clann Lir Academy, Middletown (clann-lir-academy-middletown): 390 W MAIN RD, MIDDLETOWN, RI, 02842. Business listing; no ZIP published; Middletown operation confirmed Mar 2026
update public.schools
set
  street_address = '390 W Main Rd',
  latitude = 41.515931,
  longitude = -71.301028,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'clann-lir-academy-middletown' and street_address is null;

-- McAleer-Paulson School of Irish Dance, Claymont (mcaleer-paulson-school-of-irish-dance-claymont): 3301 GREEN ST, CLAYMONT, DE, 19703. IDTANA; Claymont Community Center
update public.schools
set
  street_address = '3301 Green St',
  postal_code = '19703',
  latitude = 39.801233,
  longitude = -75.465928,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcaleer-paulson-school-of-irish-dance-claymont' and street_address is null;

-- McAleer-Paulson School of Irish Dance, Lewes (mcaleer-paulson-school-of-irish-dance-lewes): 1600 PENNSYLVANIA AVE, LEWES, DE, 19958. IDTANA; Right Balance Pilates
update public.schools
set
  street_address = '1600 Pennsylvania Ave',
  postal_code = '19958',
  latitude = 38.735032,
  longitude = -75.162491,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcaleer-paulson-school-of-irish-dance-lewes' and street_address is null;

-- McAleer-Paulson School of Irish Dance, Newark (mcaleer-paulson-school-of-irish-dance-newark): 168 S MAIN ST, NEWARK, DE, 19711. IDTANA; Delaware Dance Company
update public.schools
set
  street_address = '168 S Main St #1',
  postal_code = '19711',
  latitude = 39.679385,
  longitude = -75.760430,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcaleer-paulson-school-of-irish-dance-newark' and street_address is null;

-- D'Arcy School of Irish Dance, Fair Haven (darcy-school-of-irish-dance-fair-haven): 200 FAIR HAVEN RD, FAIR HAVEN, NJ, 07704. IDTANA
update public.schools
set
  street_address = '200 Fair Haven Rd',
  postal_code = '07704',
  latitude = 40.361927,
  longitude = -74.033153,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'darcy-school-of-irish-dance-fair-haven' and street_address is null;

-- D'Arcy School of Irish Dance, Brick (darcy-school-of-irish-dance-brick): 60 DRUM POINT RD, BRICK, NJ, 08723. IDTANA
update public.schools
set
  street_address = '60 Drum Point Rd',
  postal_code = '08723',
  latitude = 40.045498,
  longitude = -74.138388,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'darcy-school-of-irish-dance-brick' and street_address is null;

-- D'Arcy School of Irish Dance, Wall Township (darcy-school-of-irish-dance-wall-township): IDTANA; street 2400 Belmar Blvd already seeded
update public.schools
set
  postal_code = '07719'
where slug = 'darcy-school-of-irish-dance-wall-township' and postal_code is null;

-- Devrin Academy of Irish Dance, Point Pleasant (devrin-academy-of-irish-dance-point-pleasant): IDTANA; street 632 Ocean Rd already seeded
update public.schools
set
  postal_code = '08742'
where slug = 'devrin-academy-of-irish-dance-point-pleasant' and postal_code is null;

-- Heritage Irish Dance Company, Green Brook (heritage-irish-dance-company-green-brook): 319 US HWY 22, GREEN BROOK, NJ, 08812. IDTANA; no ZIP published
update public.schools
set
  street_address = '319 Rt. 22 East',
  latitude = 40.588344,
  longitude = -74.504085,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'heritage-irish-dance-company-green-brook' and street_address is null;

-- Heritage Irish Dance Company, Clinton (heritage-irish-dance-company-clinton): 1465 STATE RTE 31, ANNANDALE, NJ, 08801. IDTANA; Hunterdon Hills Ballet, Annandale/Clinton; no ZIP published
update public.schools
set
  street_address = '1465 Route 31 South',
  latitude = 40.631769,
  longitude = -74.882688,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'heritage-irish-dance-company-clinton' and street_address is null;

-- Lenahan School of Irish Dance, Sparta (lenahan-school-of-irish-dance-sparta): 191 WOODPORT RD, SPARTA, NJ, 07871. IDTANA; second Sparta venue 329 Sparta Ave (same school, no ZIP either) - see row comment in seed file
update public.schools
set
  street_address = '191 Woodport Rd',
  latitude = 41.023864,
  longitude = -74.629757,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'lenahan-school-of-irish-dance-sparta' and street_address is null;

-- Aisling Mor Academy of Irish Dance, Hatfield (aisling-mor-academy-of-irish-dance-hatfield): IDTANA; street 2501 Bethlehem Pike already seeded
update public.schools
set
  postal_code = '19440'
where slug = 'aisling-mor-academy-of-irish-dance-hatfield' and postal_code is null;

-- Hooley School of Irish Dance, Brownstown (hooley-school-of-irish-dance-brownstown): IDTANA; street 1 S State St already seeded; IDTANA city name Leola, same address
update public.schools
set
  postal_code = '17540'
where slug = 'hooley-school-of-irish-dance-brownstown' and postal_code is null;

-- Hooley School of Irish Dance, West Reading (hooley-school-of-irish-dance-west-reading): IDTANA; street 511 Reading Ave already seeded
update public.schools
set
  postal_code = '19611'
where slug = 'hooley-school-of-irish-dance-west-reading' and postal_code is null;

-- McGough Academy, West Chester (mcgough-academy-west-chester): 1510 PAOLI PIKE, WEST CHESTER, PA, 19380. IDTANA
update public.schools
set
  street_address = '1510 Paoli Pike',
  postal_code = '19380',
  latitude = 39.990755,
  longitude = -75.549438,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcgough-academy-west-chester' and street_address is null;

-- McGough Academy, Rehoboth Beach (mcgough-academy-rehoboth-beach): 34823 Derrickson Dr, Rehoboth Beach, Delaware 19971. IDTANA
update public.schools
set
  street_address = '34823 Derrickson Dr',
  postal_code = '19971'
where slug = 'mcgough-academy-rehoboth-beach' and street_address is null;

-- Bell School of Irish Dance, Pittsburgh (bell-school-of-irish-dance-pittsburgh): 75 SHENOT RD, WEXFORD, PA, 15090. IDTANA; address is in Wexford, not Pittsburgh proper; confirmed by both Mid-Atlantic and Mid-America reports
update public.schools
set
  street_address = '75 Shenot Rd',
  postal_code = '15090',
  latitude = 40.649161,
  longitude = -80.079875,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'bell-school-of-irish-dance-pittsburgh' and street_address is null;

-- Niall O'Leary School of Irish Dance, New York (niall-oleary-school-of-irish-dance-new-york): 500 8TH AVE, NEW YORK, NY, 10018. IDTANA
update public.schools
set
  street_address = '500 8th Ave',
  postal_code = '10018',
  latitude = 40.752877,
  longitude = -73.992876,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'niall-oleary-school-of-irish-dance-new-york' and street_address is null;

-- Morgan Legacy Academy (formerly McGrath Morgan Academy), Millersville (morgan-legacy-academy-formerly-mcgrath-morgan-academy-millersville): IDTANA; street 1035 Benfield Blvd already seeded
update public.schools
set
  postal_code = '21108'
where slug = 'morgan-legacy-academy-formerly-mcgrath-morgan-academy-millersville' and postal_code is null;

-- District Irish Dance Academy, Washington (district-irish-dance-academy-washington): IDTANA + own site; street 4435 Wisconsin Ave NW Suite LL10 already seeded
update public.schools
set
  postal_code = '20016'
where slug = 'district-irish-dance-academy-washington' and postal_code is null;

-- Hester Academy of Irish Dance, Wyoming (hester-academy-of-irish-dance-wyoming): Own site; street 200 Southern Blvd already seeded
update public.schools
set
  postal_code = '19934'
where slug = 'hester-academy-of-irish-dance-wyoming' and postal_code is null;

-- Dunleavy Irish Dance, Mendon (dunleavy-irish-dance-mendon): 3A ASSEMBLY DR, MENDON, NY, 14506. Own site footer
update public.schools
set
  street_address = '3A Assembly Dr',
  postal_code = '14506',
  latitude = 43.000210,
  longitude = -77.506149,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'dunleavy-irish-dance-mendon' and street_address is null;

-- Dunleavy Irish Dance, Rochester (dunleavy-irish-dance-rochester): 101 LINCOLN PKWY, E ROCHESTER, NY, 14445. Own site Google Maps pin; East Rochester (city-name variant)
update public.schools
set
  street_address = '101 Lincoln Pkwy',
  postal_code = '14445',
  latitude = 43.115799,
  longitude = -77.480051,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'dunleavy-irish-dance-rochester' and street_address is null;

-- Rochester Academy of Irish Dance, Rochester (rochester-academy-of-irish-dance-rochester): IDTANA; street 1598 Penfield Rd already seeded
update public.schools
set
  postal_code = '14625'
where slug = 'rochester-academy-of-irish-dance-rochester' and postal_code is null;

-- Chicago Irish Dance Studio, Chicago (chicago-irish-dance-studio-chicago): 2853 W MONTROSE AVE, CHICAGO, IL, 60618. IDTANA; Dovetail Studios
update public.schools
set
  street_address = '2853 W Montrose Ave',
  postal_code = '60618',
  latitude = 41.961181,
  longitude = -87.700233,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'chicago-irish-dance-studio-chicago' and street_address is null;

-- Harling School of Irish Dance, Countryside (harling-school-of-irish-dance-countryside): 919 W 55TH ST, COUNTRYSIDE, IL, 60525. IDTANA
update public.schools
set
  street_address = '919 W 55th St, Unit B',
  postal_code = '60525',
  latitude = 41.790179,
  longitude = -87.879871,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'harling-school-of-irish-dance-countryside' and street_address is null;

-- Lavin-Cassidy School of Irish Dance, Worth (lavin-cassidy-school-of-irish-dance-worth): 6401 W 107TH ST, WORTH, IL, 60482. IDTANA
update public.schools
set
  street_address = '6401 W. 107th St',
  postal_code = '60482',
  latitude = 41.697623,
  longitude = -87.779187,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'lavin-cassidy-school-of-irish-dance-worth' and street_address is null;

-- O'Shea Irish Dance, St. Paul (oshea-irish-dance-st-paul): 836 N PRIOR AVE, SAINT PAUL, MN, 55104. IDTANA
update public.schools
set
  street_address = '836 Prior Ave N',
  postal_code = '55104',
  latitude = 44.966178,
  longitude = -93.182205,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'oshea-irish-dance-st-paul' and street_address is null;

-- Eilís Academy of Irish Dance, Twin Cities (eilis-academy-of-irish-dance-twin-cities): 440 BUNKER LAKE BLVD NE, ANOKA, MN, 55304. IDTANA; studio is in Anoka, MN; seed city stays Twin Cities; no ZIP published
update public.schools
set
  street_address = '440 Bunker Lake Blvd',
  latitude = 45.218817,
  longitude = -93.256060,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'eilis-academy-of-irish-dance-twin-cities' and street_address is null;

-- Saol Academy of Irish Dance, Chicago (saol-academy-of-irish-dance-chicago): 6650 N NORTHWEST HWY, CHICAGO, IL, 60631. IDTANA; Edison Park
update public.schools
set
  street_address = '6650 N. Northwest Hwy',
  postal_code = '60631',
  latitude = 42.001747,
  longitude = -87.814643,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'saol-academy-of-irish-dance-chicago' and street_address is null;

-- Fitzpatrick School of Irish Dance, Lake Forest (fitzpatrick-school-of-irish-dance-lake-forest): 60 ATTERIDGE RD, LAKE FOREST, IL, 60045. IDTANA; IL school, not Doylestown PA school
update public.schools
set
  street_address = '60 Atteridge Road',
  postal_code = '60045',
  latitude = 42.257363,
  longitude = -87.845470,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'fitzpatrick-school-of-irish-dance-lake-forest' and street_address is null;

-- The Driscoll School of Irish Dance, Shawnee (the-driscoll-school-of-irish-dance-shawnee): 10820 W 64TH ST, SHAWNEE, KS, 66203. IDTANA
update public.schools
set
  street_address = '10820 W 64th St, Suite 101',
  postal_code = '66227',
  latitude = 39.013438,
  longitude = -94.711327,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'the-driscoll-school-of-irish-dance-shawnee' and street_address is null;

-- McNamara McCarthy School of Irish Dance, Wauwatosa (mcnamara-mccarthy-school-of-irish-dance-wauwatosa): 11727 W NORTH AVE, WAUWATOSA, WI, 53226. IDTANA
update public.schools
set
  street_address = '11727 W. North Ave.',
  postal_code = '53226',
  latitude = 43.059959,
  longitude = -88.059288,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcnamara-mccarthy-school-of-irish-dance-wauwatosa' and street_address is null;

-- Mactír Academy of Irish Dance, Minneapolis (mactir-academy-of-irish-dance-minneapolis): 3715 MINNEHAHA AVE, MINNEAPOLIS, MN, 55406. IDTANA; no ZIP published
update public.schools
set
  street_address = '3715 Minnehaha Ave, Suite B',
  latitude = 44.935475,
  longitude = -93.224797,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mactir-academy-of-irish-dance-minneapolis' and street_address is null;

-- Meghan Torno School of Irish Dance, St. Louis (meghan-torno-school-of-irish-dance-st-louis): 2641 S HANLEY RD, SAINT LOUIS, MO, 63144. IDTANA
update public.schools
set
  street_address = '2641 South Hanley Road',
  postal_code = '63144',
  latitude = 38.614239,
  longitude = -90.334010,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'meghan-torno-school-of-irish-dance-st-louis' and street_address is null;

-- The Clark Academy of Irish Dance, St. Louis (the-clark-academy-of-irish-dance-st-louis): 9226 WATSON RD, SAINT LOUIS, MO, 63126. IDTANA
update public.schools
set
  street_address = '9226 Watson Road',
  postal_code = '63126',
  latitude = 38.560056,
  longitude = -90.373632,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'the-clark-academy-of-irish-dance-st-louis' and street_address is null;

-- Onórach Mulhern Geraghty School of Irish Dance (OMG), Eden Prairie (onorach-mulhern-geraghty-school-of-irish-dance-omg-eden-prairie): 14500 MARTIN DR, EDEN PRAIRIE, MN, 55344. IDTANA
update public.schools
set
  street_address = '14500 Martin Dr.',
  postal_code = '55344',
  latitude = 44.864393,
  longitude = -93.460975,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'onorach-mulhern-geraghty-school-of-irish-dance-omg-eden-prairie' and street_address is null;

-- O'Riada Manning Academy of Irish Dance, Mission (oriada-manning-academy-of-irish-dance-mission): 6001 JOHNSON DR, MISSION, KS, 66202. IDTANA
update public.schools
set
  street_address = '6001 Johnson Dr',
  postal_code = '66202',
  latitude = 39.022072,
  longitude = -94.654951,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'oriada-manning-academy-of-irish-dance-mission' and street_address is null;

-- Champagne Academy of Irish Dance, North Liberty (champagne-academy-of-irish-dance-north-liberty): 365 Beaver Creek Center, North Liberty, Iowa. IDTANA; no ZIP published
update public.schools
set
  street_address = '365 Beaver Creek Center'
where slug = 'champagne-academy-of-irish-dance-north-liberty' and street_address is null;

-- McClanahan School of Irish Dance, Louisville (mcclanahan-school-of-irish-dance-louisville): 1820 PRODUCTION CT, LOUISVILLE, KY, 40299. IDTANA
update public.schools
set
  street_address = '1820 Production Court',
  postal_code = '40299',
  latitude = 38.219769,
  longitude = -85.565040,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcclanahan-school-of-irish-dance-louisville' and street_address is null;

-- Milwaukee Irish Dance Academy, Milwaukee (milwaukee-irish-dance-academy-milwaukee): 3555B N OAKLAND AVE, MILWAUKEE, WI, 53211. IDTANA; address is in Shorewood, WI, not Milwaukee proper
update public.schools
set
  street_address = '3555b N Oakland Ave',
  postal_code = '53211',
  latitude = 43.083166,
  longitude = -87.887707,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'milwaukee-irish-dance-academy-milwaukee' and street_address is null;

-- Richens/Timm Academy of Irish Dance, Indianapolis (richens-timm-academy-of-irish-dance-indianapolis): 4369 W 96TH ST, INDIANAPOLIS, IN, 46268. IDTANA
update public.schools
set
  street_address = '4369 W 96th St',
  postal_code = '46268',
  latitude = 39.926062,
  longitude = -86.234445,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'richens-timm-academy-of-irish-dance-indianapolis' and street_address is null;

-- Bratten School of Irish Dance, Columbia (bratten-school-of-irish-dance-columbia): 2300 BERNADETTE DR, COLUMBIA, MO, 65203. Own site; Columbia Mall
update public.schools
set
  street_address = '2300 Bernadette Dr.',
  postal_code = '65203',
  latitude = 38.965880,
  longitude = -92.374972,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'bratten-school-of-irish-dance-columbia' and street_address is null;

-- McTeggart Irish Dancers — Kentucky, Lexington (mcteggart-irish-dancers-kentucky-lexington): 570 DELZAN PLZ, LEXINGTON, KY, 40503. Own site We've moved page (Sep 2025 move); First Floor; no ZIP published
update public.schools
set
  street_address = '570 Delzan Place, Suites 12-13',
  latitude = 37.996131,
  longitude = -84.546298,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcteggart-irish-dancers-kentucky-lexington' and street_address is null;

-- Shamrock Academy of Irish Dance, Champaign (shamrock-academy-of-irish-dance-champaign): 311 S STALEY RD, CHAMPAIGN, IL, 61822. Own site; no ZIP published
update public.schools
set
  street_address = '311 S Staley Rd, Ste B',
  latitude = 40.114454,
  longitude = -88.314614,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'shamrock-academy-of-irish-dance-champaign' and street_address is null;

-- Trinity Academy of Irish Dance — Elmhurst, Elmhurst (trinity-academy-of-irish-dance-elmhurst): 747 CHURCH RD, ELMHURST, IL, 60126. IDTANA (via Mid-America name-variant resolution); ZIP 60126 already seeded, kept
update public.schools
set
  street_address = '747 N. Church Rd A5',
  latitude = 41.920912,
  longitude = -87.953639,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'trinity-academy-of-irish-dance-elmhurst' and street_address is null;

-- Hamlin School of Irish Dance, Cameron (hamlin-school-of-irish-dance-cameron): 1486 NC 24, CAMERON, NC, 28326. IDTANA; Encore Performing Arts Studio
update public.schools
set
  street_address = '1486 NC-24/87',
  postal_code = '28326',
  latitude = 35.272146,
  longitude = -79.085125,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'hamlin-school-of-irish-dance-cameron' and street_address is null;

-- Hamlin School of Irish Dance, Southern Pines (hamlin-school-of-irish-dance-southern-pines): 160 E NEW HAMPSHIRE AVE, SOUTHERN PINES, NC, 28387. IDTANA; The Encore Centre
update public.schools
set
  street_address = '160 E New Hampshire Ave',
  postal_code = '28387',
  latitude = 35.173819,
  longitude = -79.390032,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'hamlin-school-of-irish-dance-southern-pines' and street_address is null;

-- Drake Irish Dance, Coral Springs (drake-irish-dance-coral-springs): 10450 W ATLANTIC BLVD, CORAL SPRINGS, FL, 33071. IDTANA; do not copy to Fort Lauderdale row - no address given for it
update public.schools
set
  street_address = '10450 W Atlantic Blvd',
  postal_code = '33071',
  latitude = 26.240560,
  longitude = -80.266391,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'drake-irish-dance-coral-springs' and street_address is null;

-- O'Donovan School of Irish Dance, Sherwood (odonovan-school-of-irish-dance-sherwood): 5710 WARDEN RD, SHERWOOD, AR, 72120. IDTANA + own site
update public.schools
set
  street_address = '5710 Warden Rd, Suite 8',
  postal_code = '72120',
  latitude = 34.805929,
  longitude = -92.210927,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'odonovan-school-of-irish-dance-sherwood' and street_address is null;

-- McCafferty Academy of Irish Dance, Little Rock (mccafferty-academy-of-irish-dance-little-rock): 6805 W 12TH ST, LITTLE ROCK, AR, 72204. IDTANA; website Facebook only
update public.schools
set
  street_address = '6805 W 12th St',
  postal_code = '72204',
  latitude = 34.741682,
  longitude = -92.351620,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mccafferty-academy-of-irish-dance-little-rock' and street_address is null;

-- McCafferty Academy of Irish Dance, Tahlequah (mccafferty-academy-of-irish-dance-tahlequah): 17328 S MUSKOGEE AVE, TAHLEQUAH, OK, 74464. IDTANA
update public.schools
set
  street_address = '17328 S Muskogee',
  postal_code = '74464',
  latitude = 35.851152,
  longitude = -94.996734,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mccafferty-academy-of-irish-dance-tahlequah' and street_address is null;

-- Walsh Kelley School of Irish Dancing, Greensboro (walsh-kelley-school-of-irish-dancing-greensboro): 200 N DAVIE ST, GREENSBORO, NC, 27401. IDTANA; Greensboro Cultural Center
update public.schools
set
  street_address = '200 North Davie St',
  postal_code = '27401',
  latitude = 36.073432,
  longitude = -79.788936,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'walsh-kelley-school-of-irish-dancing-greensboro' and street_address is null;

-- Walsh Kelley School of Irish Dancing, Wilmington (walsh-kelley-school-of-irish-dancing-wilmington): 902 S COLLEGE RD, WILMINGTON, NC, 28403. IDTANA; Wilmington Conservatory of Fine Arts
update public.schools
set
  street_address = '902 S College Rd',
  postal_code = '28403',
  latitude = 34.218521,
  longitude = -77.885228,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'walsh-kelley-school-of-irish-dancing-wilmington' and street_address is null;

-- McTeggart Irish Dancers of South Texas (Houston), Houston (mcteggart-irish-dancers-of-south-texas-houston): 701 MAIN ST, HOUSTON, TX, 77002. IDTANA + listings; venue is in Tomball, not Houston proper - row city kept as Houston, flag for coordinator
update public.schools
set
  street_address = '701 E Main St',
  postal_code = '77375',
  latitude = 29.759113,
  longitude = -95.363128,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcteggart-irish-dancers-of-south-texas-houston' and street_address is null;

-- McLane School of Irish Dance, Richardson (mclane-school-of-irish-dance-richardson): 2080 N COLLINS BLVD, RICHARDSON, TX, 75080. IDTANA
update public.schools
set
  street_address = '2080 N. Collins Blvd',
  postal_code = '75080',
  latitude = 32.976972,
  longitude = -96.720345,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mclane-school-of-irish-dance-richardson' and street_address is null;

-- Clann Kelly School of Irish Dance, Houston (clann-kelly-school-of-irish-dance-houston): 747 N SHEPHERD DR, HOUSTON, TX, 77007. IDTANA; second Houston venue 4007 D Bellaire Blvd, Houston 77025 (West University Dance Center) - one street column, see row comment
update public.schools
set
  street_address = '747 N Shepherd Dr',
  postal_code = '77007',
  latitude = 29.784147,
  longitude = -95.409767,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'clann-kelly-school-of-irish-dance-houston' and street_address is null;

-- Cass-Barrington Academy of Irish Dance, Houston (cass-barrington-academy-of-irish-dance-houston): 1314 W PATTON ST, HOUSTON, TX, 77009. IDTANA
update public.schools
set
  street_address = '1314 W Patton St, #100',
  postal_code = '77009',
  latitude = 29.798114,
  longitude = -95.380358,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'cass-barrington-academy-of-irish-dance-houston' and street_address is null;

-- Maguire Academy of Irish Dance, Dallas (maguire-academy-of-irish-dance-dallas): 718 BUCKNER BLVD, DALLAS, TX, 75217. IDTANA; no ZIP published
update public.schools
set
  street_address = '718 N Buckner Blvd',
  latitude = 32.724817,
  longitude = -96.682820,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'maguire-academy-of-irish-dance-dallas' and street_address is null;

-- Maguire Academy of Irish Dance, Houston (maguire-academy-of-irish-dance-houston): 24914 Tomball Pkwy, Houston, Texas. IDTANA; venue in Tomball, TX; no ZIP published - row city kept as Houston, flag for coordinator
update public.schools
set
  street_address = '24914 Tomball Pkwy'
where slug = 'maguire-academy-of-irish-dance-houston' and street_address is null;

-- Inis Cairde School of Irish Dance, Raleigh (inis-cairde-school-of-irish-dance-raleigh): 6166A FALLS OF NEUSE RD, RALEIGH, NC, 27609. Own site; also fills seeded NULL website
update public.schools
set
  street_address = '6166A Falls of Neuse Rd',
  postal_code = '27609',
  website_url = 'https://www.iniscairde.com/',
  latitude = 35.866532,
  longitude = -78.620550,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'inis-cairde-school-of-irish-dance-raleigh' and street_address is null;

-- O'Keefe Academy of Irish Dance, Summerville (okeefe-academy-of-irish-dance-summerville): 124 HEMPHILL CT, SUMMERVILLE, SC, 29483. Own-site contact page
update public.schools
set
  street_address = '124 Hemphill Ct',
  postal_code = '29483',
  latitude = 33.019156,
  longitude = -80.169601,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'okeefe-academy-of-irish-dance-summerville' and street_address is null;

-- Legacy Irish Dance Academy, Savannah (legacy-irish-dance-academy-savannah): 7210 SKIDAWAY RD, SAVANNAH, GA, 31406. IDTANA + SouthernMamas (ZIP); 2026-2027 classes confirmed
update public.schools
set
  street_address = '7210 Skidaway Rd',
  postal_code = '31406',
  latitude = 31.994571,
  longitude = -81.078308,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'legacy-irish-dance-academy-savannah' and street_address is null;

-- Magennis Academy of Irish Dance, Orlando (magennis-academy-of-irish-dance-orlando): 11747 WHITEWING CT, ORLANDO, FL, 32837. IDTANA only; own site lists no street and markets only Orlando & Melbourne - IDTANA Lake Nona/Oviedo/Winter Garden/Saint Cloud locations NOT confirmed current, no rows added
update public.schools
set
  street_address = '11747 Whitewing Ct',
  postal_code = '32837',
  latitude = 28.395539,
  longitude = -81.412180,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'magennis-academy-of-irish-dance-orlando' and street_address is null;

-- Scariff Locklier Leonelli School of Irish Dance, Tampa (scariff-locklier-leonelli-school-of-irish-dance-tampa): 8019 N HIMES AVE, TAMPA, FL, 33614. Street from business listing (Active); ZIP 33614 corroborated by multiple FL corporate filings - listing-sourced, flagged
update public.schools
set
  street_address = '8019 N Himes Ave',
  postal_code = '33614',
  latitude = 28.022870,
  longitude = -82.500718,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'scariff-locklier-leonelli-school-of-irish-dance-tampa' and street_address is null;

-- McTeggart Irish Dance (Oklahoma), Oklahoma City (mcteggart-irish-dance-oklahoma-oklahoma-city): 5119 N PORTLAND AVE, OKLAHOMA CITY, OK, 73112. IDTANA; own site mcteggartokc.org
update public.schools
set
  street_address = '5119 N Portland Ave',
  postal_code = '73112',
  latitude = 35.522494,
  longitude = -97.583506,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcteggart-irish-dance-oklahoma-oklahoma-city' and street_address is null;

-- Bracken School of Irish Dance, Mesa (bracken-school-of-irish-dance-mesa): 2450 W BROADWAY RD, MESA, AZ, 85202. IDTANA
update public.schools
set
  street_address = '2450 W Broadway Rd Ste 117',
  postal_code = '85202',
  latitude = 33.407595,
  longitude = -111.884123,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'bracken-school-of-irish-dance-mesa' and street_address is null;

-- McKeever School of Irish Dance, Sacramento (mckeever-school-of-irish-dance-sacramento): 2420 N ST, SACRAMENTO, CA, 95816. IDTANA; CLARA Performing Arts Studios
update public.schools
set
  street_address = '2420 N St',
  postal_code = '95816',
  latitude = 38.570689,
  longitude = -121.476182,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mckeever-school-of-irish-dance-sacramento' and street_address is null;

-- Maguire Academy of Irish Dance, Tucson (maguire-academy-of-irish-dance-tucson): 2100 N WILMOT RD, TUCSON, AZ, 85712. IDTANA; no ZIP published
update public.schools
set
  street_address = '2100 N Wilmot Rd Unit 309',
  latitude = 32.248518,
  longitude = -110.857862,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'maguire-academy-of-irish-dance-tucson' and street_address is null;

-- Carroll-Henderson School of Irish Dancing, Missoula (carroll-henderson-school-of-irish-dancing-missoula): 126 E BROADWAY ST, MISSOULA, MT, 59802. IDTANA
update public.schools
set
  street_address = '126 E Broadway St',
  postal_code = '59801',
  latitude = 46.872051,
  longitude = -113.993579,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'carroll-henderson-school-of-irish-dancing-missoula' and street_address is null;

-- Carroll-Henderson School of Irish Dancing, Edmonds (carroll-henderson-school-of-irish-dancing-edmonds): 6121 176TH ST SW, LYNNWOOD, WA, 98037. IDTANA; billed as N. Edmonds Classes - studio is in Lynnwood, WA
update public.schools
set
  street_address = '6121 176th St Suite C',
  postal_code = '98036',
  latitude = 47.839227,
  longitude = -122.315940,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'carroll-henderson-school-of-irish-dancing-edmonds' and street_address is null;

-- Blackthorn Academy of Irish Dance, Eugene (blackthorn-academy-of-irish-dance-eugene): 420 W 12TH AVE, EUGENE, OR, 97401. IDTANA
update public.schools
set
  street_address = '420 W 12th Ave',
  postal_code = '97401',
  latitude = 44.046558,
  longitude = -123.099191,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'blackthorn-academy-of-irish-dance-eugene' and street_address is null;

-- Yeates Academy of Irish Dance, Portland (yeates-academy-of-irish-dance-portland): 4231 N INTERSTATE AVE, PORTLAND, OR, 97217. IDTANA
update public.schools
set
  street_address = '4231 N Interstate Ave',
  postal_code = '97217',
  latitude = 45.554450,
  longitude = -122.682147,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'yeates-academy-of-irish-dance-portland' and street_address is null;

-- Scoil Rince Ni Riada Irish Dance, Las Vegas (scoil-rince-ni-riada-irish-dance-las-vegas): 7024 W CHARLESTON BLVD, LAS VEGAS, NV, 89117. IDTANA
update public.schools
set
  street_address = '7024 W Charleston Blvd',
  postal_code = '89117',
  latitude = 36.159221,
  longitude = -115.251211,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'scoil-rince-ni-riada-irish-dance-las-vegas' and street_address is null;

-- Brightburn Academy of Irish Dance, Rio Rancho (brightburn-academy-of-irish-dance-rio-rancho): 801 LOMA COLORADO DR NE, RIO RANCHO, NM, 87124. IDTANA
update public.schools
set
  street_address = '801 Loma Colorado Dr',
  postal_code = '87124',
  latitude = 35.269762,
  longitude = -106.660804,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'brightburn-academy-of-irish-dance-rio-rancho' and street_address is null;

-- McTeggart Irish Dancers (McTeggart, Western U.S. Region), Boulder (mcteggart-irish-dancers-mcteggart-western-u-s-region-boulder): 2440 30TH ST, BOULDER, CO, 80301. IDTANA
update public.schools
set
  street_address = '2440 30th St',
  postal_code = '80301',
  latitude = 40.025729,
  longitude = -105.253608,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'mcteggart-irish-dancers-mcteggart-western-u-s-region-boulder' and street_address is null;

-- McTeggart Irish Dancers, Fort Collins (mcteggart-irish-dancers-fort-collins): 1532 E Mulberry St Unit B, Fort Collins, Colorado 80524. IDTANA
update public.schools
set
  street_address = '1532 E Mulberry St Unit B',
  postal_code = '80524'
where slug = 'mcteggart-irish-dancers-fort-collins' and street_address is null;

-- Claddagh Dance Company (Claddagh Western U.S.), Ventura (claddagh-dance-company-claddagh-western-u-s-ventura): 1729 E MAIN ST, VENTURA, CA, 93001. IDTANA
update public.schools
set
  street_address = '1729 E Main St',
  postal_code = '93001',
  latitude = 34.279123,
  longitude = -119.274370,
  geo_precision = 'street',
  geo_source = 'census'
where slug = 'claddagh-dance-company-claddagh-western-u-s-ventura' and street_address is null;

-- Fort McMurray Celtic Dance Studio (Celtic Dance Studio — FMM), Fort McMurray (fort-mcmurray-celtic-dance-studio-celtic-dance-studio-fmm-fort-mcmurray): Sparrow Hawk Drive, Eagle Ridge, Thickwood, Fort McMurray, Wood Buffalo, Alberta, T9K 2Z7, Canada. [Canadian postal T9K 0P1 — not stored in postal_code column.] IDTANA
update public.schools
set
  street_address = '#2 - 301 Sparrow Hawk Drive',
  latitude = 56.748024,
  longitude = -111.430696,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'fort-mcmurray-celtic-dance-studio-celtic-dance-studio-fmm-fort-mcmurray' and street_address is null;

-- Possak Hampshire Academy of Irish Dance, Calgary (possak-hampshire-academy-of-irish-dance-calgary): 5524, 1A Street SW, Manchester, Calgary, Alberta, T2H 0E7, Canada. IDTANA + WCIDTA; no postal published
update public.schools
set
  street_address = '5524 1A St SW #4',
  latitude = 51.005006,
  longitude = -114.066839,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'possak-hampshire-academy-of-irish-dance-calgary' and street_address is null;

-- Possak Hampshire Academy of Irish Dance, Okotoks (possak-hampshire-academy-of-irish-dance-okotoks): Fisher Crescent, Business Park, Okotoks, Town of Okotoks, Alberta, T1S 2N7, Canada. IDTANA + WCIDTA; listed as 309 #3 Fisher Crescent; no postal published
update public.schools
set
  street_address = '309 Fisher Crescent, Unit 3',
  latitude = 50.722710,
  longitude = -113.952880,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'possak-hampshire-academy-of-irish-dance-okotoks' and street_address is null;

-- Ticálié Irish Dance Academy, West Kelowna (ticalie-irish-dance-academy-west-kelowna): 2081, McDougall Road, Lakeview Heights, West Kelowna, Westbank First Nation #9, Regional District of Central Okanagan, British Columbia, V1Z 1G2, Canada. WCIDTA; no postal published
update public.schools
set
  street_address = '2081 McDougall Road',
  latitude = 49.876825,
  longitude = -119.572322,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'ticalie-irish-dance-academy-west-kelowna' and street_address is null;

-- Ticálié Irish Dance Academy, Kelowna (ticalie-irish-dance-academy-kelowna): Rotary Centre for the Arts, 421, Cawston Avenue, Kelowna, Westbank First Nation #9, Regional District of Central Okanagan, British Columbia, V1Y 6Z1, Canada. WCIDTA; no postal published
update public.schools
set
  street_address = '421 Cawston Avenue',
  latitude = 49.891259,
  longitude = -119.494946,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'ticalie-irish-dance-academy-kelowna' and street_address is null;

-- Brady Academy of Irish Dance, Calgary (brady-academy-of-irish-dance-calgary): Springbank High School, 32226, Springbank Road, Calgary, Rocky View County, Alberta, T3Z 2L9, Canada. WCIDTA; no postal published
update public.schools
set
  street_address = '32226 Springbank Road',
  latitude = 51.068375,
  longitude = -114.348717,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'brady-academy-of-irish-dance-calgary' and street_address is null;

-- Brady Academy of Irish Dance, Fort McMurray (brady-academy-of-irish-dance-fort-mcmurray): 7317, Railway Avenue, Waterways, Fort McMurray, Wood Buffalo, Alberta, T9H 1C4, Canada. WCIDTA; no postal published
update public.schools
set
  street_address = '7317 Railway Ave',
  latitude = 56.700948,
  longitude = -111.338671,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'brady-academy-of-irish-dance-fort-mcmurray' and street_address is null;

-- Brady Academy of Irish Dance, Saskatoon (brady-academy-of-irish-dance-saskatoon): 2610, Thayer Avenue, Airport Business Area, Riel Industrial Sector, Saskatoon, Saskatchewan, S7L 5X9, Canada. WCIDTA; no postal published
update public.schools
set
  street_address = '2610 Thayer Avenue',
  latitude = 52.167313,
  longitude = -106.679580,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'brady-academy-of-irish-dance-saskatoon' and street_address is null;

-- SASK Irish Dance, Saskatoon (sask-irish-dance-saskatoon): Hanselman Court, Airport Business Area, Riel Industrial Sector, Saskatoon, Saskatchewan, S7L 6A4, Canada. [Canadian postal S7L 6A8 — not stored in postal_code column.] Own site (rivercityirishdance.com); merged school - River City Studio; second studio A2-1502 Quebec Avenue per WCIDTA (one street column, see row comment). River City NOT added as a separate school (merged into SASK Irish Dance)
update public.schools
set
  street_address = '2213F Hanselman Court',
  latitude = 52.160251,
  longitude = -106.680161,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'sask-irish-dance-saskatoon' and street_address is null;

-- McConnell Irish Dance, Brandon (mcconnell-irish-dance-brandon): Canadian postal R7A 4E7 verified — recorded here only (postal_code column is US 5-digit ZIP only). Own site; street 126 10th St already seeded - Canadian postal verified, recorded here only (postal_code column is US 5-digit ZIP only)
-- Gott-Hughton Irish Dance Academy, Calgary (gott-hughton-irish-dance-academy-calgary): Canadian postal T2H 0S9 verified — recorded here only (postal_code column is US 5-digit ZIP only). IDTANA; street 407 Forge Rd SE already seeded - Canadian postal verified, recorded here only
-- Aroon Academy of Irish Dance, Richmond Hill (aroon-academy-of-irish-dance-richmond-hill): 70, Newkirk Road, Richmond Hill, York Region, Ontario, L4G 3G6, Canada. IDTANA + own site; no postal published
update public.schools
set
  street_address = '70 Newkirk Rd',
  latitude = 43.880195,
  longitude = -79.427426,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'aroon-academy-of-irish-dance-richmond-hill' and street_address is null;

-- Branton Academy of Irish Dance (Emerald Isle Dance Society), Windsor (branton-academy-of-irish-dance-emerald-isle-dance-society-windsor): 3900, Walker Road, Devonshire, Windsor, Southwestern Ontario, Ontario, N8V 1A1, Canada. [Canadian postal N8W 3T3 — not stored in postal_code column.] IDTANA; confirmed by both Mid-America and Eastern Canada reports (Windsor ON listed under Mid-America region by IDTANA)
update public.schools
set
  street_address = '3900 Walker Road',
  latitude = 42.265728,
  longitude = -82.970827,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'branton-academy-of-irish-dance-emerald-isle-dance-society-windsor' and street_address is null;

-- Finnegan School of Irish Dance, Milton (finnegan-school-of-irish-dance-milton): 925, Main Street East, Milton, Halton Region, Ontario, L9T 0J4, Canada. [Canadian postal L9T 4H8 — not stored in postal_code column.] IDTANA; also matches business listing
update public.schools
set
  street_address = '925 Main Street East, Unit 5',
  latitude = 43.528103,
  longitude = -79.867968,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'finnegan-school-of-irish-dance-milton' and street_address is null;

-- Finnegan School of Irish Dance, Guelph (finnegan-school-of-irish-dance-guelph): 375, Southgate Drive, Clairfields, Guelph, Southwestern Ontario, Ontario, N1G 3W6, Canada. [Canadian postal N1G 3W6 — not stored in postal_code column.] Finnegan class schedule names Emotion Dance Company as Guelph venue; Emotion Dance Company's own site publishes the address
update public.schools
set
  street_address = '375 Southgate Drive #2',
  latitude = 43.501537,
  longitude = -80.220481,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'finnegan-school-of-irish-dance-guelph' and street_address is null;

-- Celtic Academy Canada (Celtic Academy Irish Dance Canada), Erin (celtic-academy-canada-celtic-academy-irish-dance-canada-erin): Erin District High School, 14, Boland Drive, Erin, Wellington County, Southwestern Ontario, Ontario, N0B 1T0, Canada. Own site; Erin/Hillsburgh: Center 2000 Main Lobby, 14 Boland Drive, Erin; no postal published
update public.schools
set
  street_address = '14 Boland Drive',
  latitude = 43.778942,
  longitude = -80.067780,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'celtic-academy-canada-celtic-academy-irish-dance-canada-erin' and street_address is null;

-- Claddagh Irish Dance, Toronto (claddagh-irish-dance-toronto): 833, Broadview Avenue, The Danforth, Playter Estates-Danforth, Toronto—Danforth, Toronto, Ontario, M4K 2P9, Canada. Business listing for Claddagh Irish Dance (Metro Movement studio address, where Claddagh holds most classes per its own classes page); own site names venues but publishes no street itself - treat as venue address
update public.schools
set
  street_address = '833 Broadview Ave',
  latitude = 43.678860,
  longitude = -79.357850,
  geo_precision = 'street',
  geo_source = 'nominatim'
where slug = 'claddagh-irish-dance-toronto' and street_address is null;

-- Costello Irish Dance, Saint-Lazare (costello-irish-dance-saint-lazare): Canadian postal J7T 3B4 verified — recorded here only (postal_code column is US 5-digit ZIP only). Verified postal for seeded street 1850 Rue des Loisirs, Local 123 (Eastern Canada report); recorded here only - postal_code column is US 5-digit ZIP only
-- Kilmartin Irish Dance School (KIDS), Hudson (kilmartin-irish-dance-school-kids-hudson): Canadian postal J0P 1H0 verified — recorded here only (postal_code column is US 5-digit ZIP only). Own site; verified postal for seeded street 642 Main Road (Eastern Canada report); recorded here only
-- Sue Fay Healy School of Irish Dance (SFH Irish Dance Studio), Ottawa (sue-fay-healy-school-of-irish-dance-sfh-irish-dance-studio-ottawa): Canadian postal K2E 7M3 verified — recorded here only (postal_code column is US 5-digit ZIP only). Verified postal for seeded street 174 Colonnade Rd, Nepean (Eastern Canada report); recorded here only
-- Johnson Academy of Irish Dance (Johnson Irish Dance), Toronto (johnson-academy-of-irish-dance-johnson-irish-dance-toronto): Canadian postal M6S 3H9 verified — recorded here only (postal_code column is US 5-digit ZIP only). Verified postal for seeded street 95 Lavinia Ave (Eastern Canada report); recorded here only
-- Goggin-Stewart School of Irish Dance, Oakville (goggin-stewart-school-of-irish-dance-oakville): Canadian postal L6J 2X7 verified — recorded here only (postal_code column is US 5-digit ZIP only). Own-site structured data; verified postal for seeded street 1040 South Service Rd E (Eastern Canada report); recorded here only
-- Heavey Quinn Academy of Irish Dance, Chelmsford (heavey-quinn-academy-of-irish-dance-chelmsford): New England report; seeded website was NULL
update public.schools
set
  website_url = 'https://www.heaveyquinn.com/'
where slug = 'heavey-quinn-academy-of-irish-dance-chelmsford' and website_url is null;

-- Dunleavy Boyle Academy of Irish Dance, Hanover (dunleavy-boyle-academy-of-irish-dance-hanover): New England report; seeded website was a Facebook URL only - replaced with the school's own https site
update public.schools
set
  website_url = 'https://southshoreirishdance.com/'
where slug = 'dunleavy-boyle-academy-of-irish-dance-hanover';

-- Clan Rince School of Irish Dance, San Diego (clan-rince-school-of-irish-dance-san-diego): Western US report; seeded website was NULL
update public.schools
set
  website_url = 'https://www.clanrince.com'
where slug = 'clan-rince-school-of-irish-dance-san-diego' and website_url is null;

-- Castilla School of Irish Dance, Kelowna (castilla-school-of-irish-dance-kelowna): Western Canada report; seeded website was NULL
update public.schools
set
  website_url = 'https://www.castillairishdance.com/'
where slug = 'castilla-school-of-irish-dance-kelowna' and website_url is null;
