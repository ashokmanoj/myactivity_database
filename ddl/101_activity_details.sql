-- ============================================================================
-- DDL 101: activity_details — extra on-site checks recorded with a task
-- activity: whether the class was running and whether the VSAT was working,
-- each a Yes / No from the yes_no_option master (DDL 100). One row per
-- task_activity (UNIQUE), written by the mobile app through
-- POST /api/v1/task-activity (and /sync) as classRunStatusId / vsatStatusId.
--
-- Each answer is stored twice, both referencing the yes_no_option master:
-- *_status_id → yes_no_option(id) and *_status → yes_no_option(option_name)
-- ("Yes" / "No"), so the table reads easily on its own. Both are written
-- together by fn_activity_details_upsert; renaming an option flows into
-- *_status through ON UPDATE CASCADE.
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS activity_details (
    id                   SERIAL        PRIMARY KEY,
    task_activity_id     INT           NOT NULL UNIQUE REFERENCES task_activity(id) ON DELETE CASCADE,
    class_run_status_id  INT           REFERENCES yes_no_option(id),
    class_run_status     VARCHAR(20)   REFERENCES yes_no_option(option_name) ON UPDATE CASCADE,
    vsat_status_id       INT           REFERENCES yes_no_option(id),
    vsat_status          VARCHAR(20)   REFERENCES yes_no_option(option_name) ON UPDATE CASCADE,
    is_active            SMALLINT      NOT NULL DEFAULT 1,
    created_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Backfills the name columns for a DB where this file already ran once
-- before they were added to the CREATE TABLE above.
ALTER TABLE activity_details ADD COLUMN IF NOT EXISTS class_run_status VARCHAR(20)
    REFERENCES yes_no_option(option_name) ON UPDATE CASCADE;
ALTER TABLE activity_details ADD COLUMN IF NOT EXISTS vsat_status      VARCHAR(20)
    REFERENCES yes_no_option(option_name) ON UPDATE CASCADE;
