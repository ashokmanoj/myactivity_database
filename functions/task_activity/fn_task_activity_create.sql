-- Function: fn_task_activity_create  |  Domain: task_activity
-- Starts a task activity during a visit. Idempotent on uuid (same pattern as
-- fn_visit_create/fn_distance_start): a mobile retry that resends the same
-- client-generated uuid returns the existing row instead of erroring.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_activity_create(
    p_uuid       VARCHAR DEFAULT NULL,
    p_visit_uuid VARCHAR DEFAULT NULL,
    p_task_id    INT     DEFAULT NULL,
    p_status_id  INT     DEFAULT NULL,
    p_remarks    TEXT    DEFAULT NULL
)
RETURNS SETOF task_activity AS $$
BEGIN
    IF p_uuid IS NOT NULL THEN
        RETURN QUERY SELECT * FROM task_activity WHERE uuid = p_uuid;
        IF FOUND THEN RETURN; END IF;
    END IF;

    RETURN QUERY
    INSERT INTO task_activity (
        uuid, visit_uuid, task_id, status_id, remarks, activity_start_at
    ) VALUES (
        p_uuid, p_visit_uuid, p_task_id, COALESCE(p_status_id, 1), p_remarks, NOW()
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
