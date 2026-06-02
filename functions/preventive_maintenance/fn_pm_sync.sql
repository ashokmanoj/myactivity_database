-- Function: fn_pm_sync  |  Domain: preventive_maintenance
-- Upserts a PM session from the mobile app sync payload.
-- On conflict (uuid) it marks the session submitted and sets is_synced=1.
-- Returns the pm_id of the inserted or updated row.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_sync(
    p_uuid             VARCHAR,
    p_project_id       INT,
    p_institution_id   INT,
    p_user_id          INT,
    p_submitted_at     TIMESTAMPTZ,
    p_total_questions  INT,
    p_answered_count   INT,
    p_gps_lat          NUMERIC DEFAULT NULL,
    p_gps_lng          NUMERIC DEFAULT NULL
)
RETURNS INT AS $$
DECLARE
    v_pm_id INT;
BEGIN
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
        p_submitted_at,
        p_gps_lat,
        p_gps_lng,
        1,
        NOW(),
        NOW()
    )
    ON CONFLICT (uuid) DO UPDATE
        SET status          = 'submitted',
            project_id      = EXCLUDED.project_id,
            institution_id  = EXCLUDED.institution_id,
            user_id         = EXCLUDED.user_id,
            total_questions = EXCLUDED.total_questions,
            answered_count  = EXCLUDED.answered_count,
            submitted_at    = EXCLUDED.submitted_at,
            gps_lat         = EXCLUDED.gps_lat,
            gps_lng         = EXCLUDED.gps_lng,
            is_synced       = 1,
            updated_at      = NOW()
    RETURNING pm_id INTO v_pm_id;

    RETURN v_pm_id;
END;
$$ LANGUAGE plpgsql;
