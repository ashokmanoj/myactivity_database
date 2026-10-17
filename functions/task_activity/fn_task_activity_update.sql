-- Function: fn_task_activity_update  |  Domain: task_activity
-- Updates status_id, remarks and/or is_active. activity_end_at is set once,
-- the first time status_id becomes the 'Completed' row in activity_status —
-- COALESCE keeps the original value on a retry, same idempotency pattern as
-- fn_visit_end. Looked up by name (not a hardcoded id) so it stays correct
-- even if activity_status rows are ever re-seeded in a different order.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_activity_update(
    p_id        INT,
    p_status_id INT      DEFAULT NULL,
    p_remarks   TEXT     DEFAULT NULL,
    p_is_active SMALLINT DEFAULT NULL
)
RETURNS SETOF task_activity AS $$
DECLARE
    v_completed_id INT;
BEGIN
    SELECT id INTO v_completed_id FROM activity_status WHERE status_name = 'Completed';

    RETURN QUERY
    UPDATE task_activity
    SET status_id        = COALESCE(p_status_id, status_id),
        remarks          = COALESCE(p_remarks, remarks),
        is_active        = COALESCE(p_is_active, is_active),
        activity_end_at  = CASE WHEN p_status_id = v_completed_id THEN COALESCE(activity_end_at, NOW()) ELSE activity_end_at END,
        updated_at       = NOW()
    WHERE id = p_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
