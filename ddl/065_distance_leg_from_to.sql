-- DDL 065: Capture a from/to location per leg of an 'Others' trip (e.g. "From
-- Guwahati To Jorhat" for a bus leg), alongside the existing mode/amount/photo.
SET search_path TO myactivity;

ALTER TABLE distance_leg
  ADD COLUMN IF NOT EXISTS from_location VARCHAR(200),
  ADD COLUMN IF NOT EXISTS to_location   VARCHAR(200);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','065_distance_leg_from_to.sql') ON CONFLICT DO NOTHING;
