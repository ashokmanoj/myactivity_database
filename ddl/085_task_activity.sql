-- ============================================================================
-- DDL 085: task_activity — one record per task worked on during a visit
-- (visit_details) — links a specific assign_task_list task to the visit it
-- was actioned in, with its own start/end timestamps, status and remarks.
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS task_activity (
    id                SERIAL        PRIMARY KEY,
    uuid              VARCHAR(100)  UNIQUE,
    visit_uuid        VARCHAR(100)  REFERENCES visit_details(uuid)      ON DELETE SET NULL,
    task_id           INT           REFERENCES assign_task_list(task_id) ON DELETE SET NULL,
    remarks           TEXT,
    status_id         INT           NOT NULL DEFAULT 1 REFERENCES activity_status(id), -- 1=Pending (see seed/087_activity_status.sql)
    is_active         SMALLINT      NOT NULL DEFAULT 1,
    activity_start_at TIMESTAMPTZ,
    activity_end_at   TIMESTAMPTZ,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Backfills remarks for when this file already ran once before that column
-- was added to the CREATE TABLE above.
ALTER TABLE task_activity ADD COLUMN IF NOT EXISTS remarks TEXT;

CREATE INDEX IF NOT EXISTS idx_task_activity_uuid       ON task_activity(uuid);
CREATE INDEX IF NOT EXISTS idx_task_activity_visit_uuid ON task_activity(visit_uuid);
CREATE INDEX IF NOT EXISTS idx_task_activity_task_id    ON task_activity(task_id);
CREATE INDEX IF NOT EXISTS idx_task_activity_status_id  ON task_activity(status_id);
