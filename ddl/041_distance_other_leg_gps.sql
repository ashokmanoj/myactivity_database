-- DDL 041: Add GPS resolution columns to distance_other_leg
SET search_path TO myactivity;

ALTER TABLE distance_other_leg
  ADD COLUMN IF NOT EXISTS from_time VARCHAR(10),
  ADD COLUMN IF NOT EXISTS from_lat  NUMERIC(10,7),
  ADD COLUMN IF NOT EXISTS from_lng  NUMERIC(10,7),
  ADD COLUMN IF NOT EXISTS to_time   VARCHAR(10),
  ADD COLUMN IF NOT EXISTS to_lat    NUMERIC(10,7),
  ADD COLUMN IF NOT EXISTS to_lng    NUMERIC(10,7);

COMMENT ON COLUMN distance_other_leg.from_time IS 'Original time entered by user (HH:MM) when from_location was resolved from GPS';
COMMENT ON COLUMN distance_other_leg.to_time   IS 'Original time entered by user (HH:MM) when to_location was resolved from GPS';
