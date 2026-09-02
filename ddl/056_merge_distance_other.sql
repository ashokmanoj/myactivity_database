-- DDL 056: Merge "Other" trips (Bus/Auto/Taxi/mixed-vehicle) back into the
-- regular distance_tracking flow. A trip's vehicle_type ('Bike'/'Car'/'Others')
-- already lives on distance_tracking; ending an 'Others' trip now records its
-- modes of travel in this new child table instead of a parallel trip system.
-- GPS reuses the existing gps_location table (already generic, FK'd to
-- distance_tracking) — no separate GPS table needed anymore.
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS distance_leg (
  id             SERIAL PRIMARY KEY,
  trip_id        INT           NOT NULL REFERENCES distance_tracking(id) ON DELETE CASCADE,
  mode           VARCHAR(50)   NOT NULL,
  sort_order     INT           NOT NULL DEFAULT 0,
  payment_method VARCHAR(20),
  amount         NUMERIC(10,2),
  photo_path     VARCHAR(500),
  remarks        VARCHAR(500),
  created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_distance_leg_trip_id ON distance_leg(trip_id);

-- Drop the now-superseded parallel "Other trip" system (dependents first).
-- Migrations 039-055 that built these up are left in place (all guarded with
-- IF NOT EXISTS/IF EXISTS, so a full re-run harmlessly recreates-then-drops
-- them again — no errors, just a no-op cycle).
DROP TABLE IF EXISTS distance_other_gps;
DROP TABLE IF EXISTS distance_other_leg;
DROP TABLE IF EXISTS distance_other_trip;
