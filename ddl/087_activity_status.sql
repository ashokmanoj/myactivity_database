-- ============================================================================
-- DDL 087: activity_status — lookup table for task_activity.status_id
-- (Pending | In Progress | Completed), replacing the bare int + comment that
-- used to live directly on task_activity. Seed rows live in
-- database/seed/087_activity_status.sql (DDL files are schema-only).
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS activity_status (
    id          SERIAL       PRIMARY KEY,
    status_name VARCHAR(50)  NOT NULL UNIQUE,
    sort_order  INT          NOT NULL DEFAULT 0,
    is_active   SMALLINT     NOT NULL DEFAULT 1,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
