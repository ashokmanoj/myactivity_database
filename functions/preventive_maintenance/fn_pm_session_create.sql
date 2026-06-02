-- Function: fn_pm_session_create  |  Domain: preventive_maintenance
-- Creates a new PM inspection session with status 'submitted'.
-- Returns the full inserted row.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_session_create(
    p_uuid             VARCHAR,
    p_project_id       INT,
    p_institution_id   INT,
    p_user_id          INT,
    p_total_questions  INT,
    p_answered_count   INT,
    p_gps_lat          NUMERIC DEFAULT NULL,
    p_gps_lng          NUMERIC DEFAULT NULL
)
RETURNS SETOF preventive_maintenance AS $$
BEGIN
    RETURN QUERY
    INSERT INTO preventive_maintenance (
        uuid,
        project_id,
        institution_id,
        user_id,
        status,
        total_questions,
        answered_count,
        started_at,
        submitted_at,
        gps_lat,
        gps_lng,
        is_synced,
        created_at,
        updated_at
    )
    VALUES (
        p_uuid,
        p_project_id,
        p_institution_id,
        p_user_id,
        'submitted',
        p_total_questions,
        p_answered_count,
        NOW(),
        NOW(),
        p_gps_lat,
        p_gps_lng,
        0,
        NOW(),
        NOW()
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
