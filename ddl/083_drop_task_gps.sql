-- ============================================================================
-- DDL 083: Drop gps_lat/gps_lng from assign_task_list — unused (never set by
-- any screen, no reads anywhere outside the task functions/controller
-- themselves). Added by 024_task_add_gps.sql, now archived — see
-- database/ddl/archive/README.md.
-- ============================================================================
SET search_path TO myactivity;

ALTER TABLE assign_task_list
    DROP COLUMN IF EXISTS gps_lat,
    DROP COLUMN IF EXISTS gps_lng;
