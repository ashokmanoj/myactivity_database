SET search_path TO myactivity;

-- Store latitude / longitude exactly as received, with no limit on decimals.
--
-- institution.latitude/longitude were NUMERIC(8,6)/(9,6) and locations.lat/lon
-- NUMERIC(10,7), so Postgres rounded every saved value: a mobile point of
-- 90.659274512 became 90.6592745 in locations, and became 90.659275 once an
-- RM pressed Update on All Location Mapping. Plain NUMERIC (no precision /
-- scale) keeps every digit sent. Widening a NUMERIC never changes existing
-- values, so this is safe on live data — but digits already rounded away
-- before this migration cannot be recovered.
--
-- Idempotent: re-running it on already-plain NUMERIC columns is a no-op.
ALTER TABLE institution
  ALTER COLUMN latitude  TYPE NUMERIC,
  ALTER COLUMN longitude TYPE NUMERIC;

ALTER TABLE locations
  ALTER COLUMN lat TYPE NUMERIC,
  ALTER COLUMN lon TYPE NUMERIC;
