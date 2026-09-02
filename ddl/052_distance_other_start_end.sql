-- DDL 052: "Other" trips move from one-shot submission to Start/End, mirroring
-- the regular bike/car flow. Drop the from/to-location + distance concept from
-- legs entirely (and the GPS/time-based resolution feature that filled them in).
SET search_path TO myactivity;

ALTER TABLE distance_other_trip
  ADD COLUMN IF NOT EXISTS uuid            VARCHAR(100),
  ADD COLUMN IF NOT EXISTS start_timestamp BIGINT,
  ADD COLUMN IF NOT EXISTS end_timestamp   BIGINT;

CREATE INDEX IF NOT EXISTS idx_dot_uuid ON distance_other_trip(uuid);

ALTER TABLE distance_other_leg
  DROP COLUMN IF EXISTS from_location,
  DROP COLUMN IF EXISTS to_location,
  DROP COLUMN IF EXISTS distance,
  DROP COLUMN IF EXISTS from_time,
  DROP COLUMN IF EXISTS from_lat,
  DROP COLUMN IF EXISTS from_lng,
  DROP COLUMN IF EXISTS to_time,
  DROP COLUMN IF EXISTS to_lat,
  DROP COLUMN IF EXISTS to_lng;
