-- DDL 055: Start/end selfie images for "Other" trips, mirroring the regular
-- bike/car flow's startSelfie/endSelfie concept.
SET search_path TO myactivity;

ALTER TABLE distance_other_trip
  ADD COLUMN IF NOT EXISTS start_image_path VARCHAR(500),
  ADD COLUMN IF NOT EXISTS end_image_path   VARCHAR(500);
