-- Seed data for ddl/087_activity_status.sql
-- sort_order also fixes the ids (1/2/3) that task_activity.status_id's
-- DEFAULT and fn_task_activity_update's "mark Completed" check rely on.
SET search_path TO myactivity;

INSERT INTO activity_status (status_name, sort_order) VALUES
    ('Pending',     1),
    ('In Progress', 2),
    ('Completed',   3)
ON CONFLICT (status_name) DO NOTHING;
