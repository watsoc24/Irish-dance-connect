-- Irish Dance Connect — school geocoding (2026-11-12)
-- Adds a street address and coordinates to public.schools so the directory
-- can sort schools nearest-first by a parent's ZIP code.
--
-- Columns are nullable: existing rows (and claims, which create schools
-- without an address) keep working. Geo fields are curated, not
-- user-editable, so they are deliberately NOT added to the column-level
-- grants in 20261103000000_init.sql; they are set by seed SQL or by a
-- platform admin running SQL directly.
--
-- geo_precision: 'street' = coordinates are for the street address,
--   'city' = city/ZIP centroid only (no street address published).
-- geo_source: how the coordinates were obtained ('census' = US Census
--   Geocoder, 'city-centroid' = ZIP/city centroid lookup).
-- postal_code is left NULL where no ZIP was verified for the address —
-- never guessed.

alter table public.schools
  add column street_address text check (street_address is null or char_length(street_address) <= 200),
  add column postal_code text check (postal_code is null or postal_code ~ '^[0-9]{5}$'),
  add column latitude numeric check (latitude is null or (latitude between -90 and 90)),
  add column longitude numeric check (longitude is null or (longitude between -180 and 180)),
  add column geo_precision text check (geo_precision is null or geo_precision in ('street', 'city')),
  add column geo_source text check (geo_source is null or char_length(geo_source) <= 40);

-- Coordinates and precision always travel together: a row must not claim
-- street precision with no coordinates, or carry coordinates with no
-- statement of what they represent.
alter table public.schools
  add constraint schools_geo_consistent
  check (
    (latitude is null and longitude is null and geo_precision is null)
    or (latitude is not null and longitude is not null and geo_precision is not null)
  );
