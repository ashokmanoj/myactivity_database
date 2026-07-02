-- ============================================================================
-- DDL 024: Add GPS coordinates to task_list
-- ============================================================================
SET search_path TO myactivity;

ALTER TABLE task_list
    ADD COLUMN IF NOT EXISTS gps_lat  DOUBLE PRECISION DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS gps_lng  DOUBLE PRECISION DEFAULT NULL;

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.24', '024_task_add_gps.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
