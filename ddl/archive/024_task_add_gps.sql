-- ============================================================================
-- DDL 024: Add GPS coordinates to assign_task_list
-- ============================================================================
SET search_path TO myactivity;

ALTER TABLE assign_task_list
    ADD COLUMN IF NOT EXISTS gps_lat  DOUBLE PRECISION DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS gps_lng  DOUBLE PRECISION DEFAULT NULL;
