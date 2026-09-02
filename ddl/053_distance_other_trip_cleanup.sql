-- DDL 053: Remove trip-level fields from distance_other_trip that are now
-- redundant with per-leg fields (payment_method, amount) or dead leftovers
-- from the old one-shot submission (trip_date, trip_time). remarks moves to
-- being a per-leg field instead of a single trip-wide note.
SET search_path TO myactivity;

ALTER TABLE distance_other_trip
  DROP COLUMN IF EXISTS trip_date,
  DROP COLUMN IF EXISTS trip_time,
  DROP COLUMN IF EXISTS payment_method,
  DROP COLUMN IF EXISTS remarks;
  -- `amount` column is KEPT — still computed internally as the sum of leg
  -- amounts for accounting reference; just no longer exposed in API responses.

ALTER TABLE distance_other_leg
  ADD COLUMN IF NOT EXISTS remarks VARCHAR(500);
