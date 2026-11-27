-- Function: fn_activity_details_upsert  |  Domain: task_activity
-- Saves the class-run / VSAT status (yes_no_option ids) for one task
-- activity, plus each option's name ("Yes" / "No") alongside it. One row per
-- activity: a repeat call (mobile retry, or a later correction) updates it.
-- A NULL argument keeps the value already stored, so a retry that omits a
-- field doesn't wipe it.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_activity_details_upsert(
    p_task_activity_id    INT,
    p_class_run_status_id INT DEFAULT NULL,
    p_vsat_status_id      INT DEFAULT NULL
)
RETURNS SETOF activity_details AS $$
BEGIN
    RETURN QUERY
    INSERT INTO activity_details (
        task_activity_id,
        class_run_status_id, class_run_status,
        vsat_status_id,      vsat_status
    ) VALUES (
        p_task_activity_id,
        p_class_run_status_id, (SELECT option_name FROM yes_no_option WHERE id = p_class_run_status_id),
        p_vsat_status_id,      (SELECT option_name FROM yes_no_option WHERE id = p_vsat_status_id)
    )
    ON CONFLICT (task_activity_id) DO UPDATE
    SET class_run_status_id = COALESCE(EXCLUDED.class_run_status_id, activity_details.class_run_status_id),
        class_run_status    = COALESCE(EXCLUDED.class_run_status,    activity_details.class_run_status),
        vsat_status_id      = COALESCE(EXCLUDED.vsat_status_id,      activity_details.vsat_status_id),
        vsat_status         = COALESCE(EXCLUDED.vsat_status,         activity_details.vsat_status),
        updated_at          = NOW()
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
