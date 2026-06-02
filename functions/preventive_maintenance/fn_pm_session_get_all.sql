-- Function: fn_pm_session_get_all  |  Domain: preventive_maintenance
-- Returns PM sessions with joined project, institution and user details.
-- All filter parameters are optional.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_session_get_all(
    p_project_id     INT         DEFAULT NULL,
    p_institution_id INT         DEFAULT NULL,
    p_user_id        INT         DEFAULT NULL,
    p_status         VARCHAR     DEFAULT NULL,
    p_from           TIMESTAMPTZ DEFAULT NULL,
    p_to             TIMESTAMPTZ DEFAULT NULL
)
RETURNS TABLE(
    pm_id            INT,
    uuid             VARCHAR,
    status           VARCHAR,
    project_id       INT,
    project_name     VARCHAR,
    institution_id   INT,
    institution_name VARCHAR,
    institute_code   VARCHAR,
    user_id          INT,
    full_name        VARCHAR,
    emp_code         VARCHAR,
    total_questions  INT,
    answered_count   INT,
    started_at       TIMESTAMPTZ,
    submitted_at     TIMESTAMPTZ,
    gps_lat          NUMERIC,
    gps_lng          NUMERIC,
    created_at       TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pm.pm_id,
        pm.uuid,
        pm.status,
        p.project_id,
        p.project_name,
        i.institute_id,
        i.institution_name,
        i.institute_code,
        u.user_id,
        u.full_name,
        u.emp_code,
        pm.total_questions,
        pm.answered_count,
        pm.started_at,
        pm.submitted_at,
        pm.gps_lat,
        pm.gps_lng,
        pm.created_at
    FROM preventive_maintenance pm
    LEFT JOIN project     p ON p.project_id   = pm.project_id
    LEFT JOIN institution i ON i.institute_id  = pm.institution_id
    LEFT JOIN user_tbl    u ON u.user_id       = pm.user_id
    WHERE (p_project_id     IS NULL OR pm.project_id     = p_project_id)
      AND (p_institution_id IS NULL OR pm.institution_id = p_institution_id)
      AND (p_user_id        IS NULL OR pm.user_id        = p_user_id)
      AND (p_status         IS NULL OR pm.status         = p_status)
      AND (p_from           IS NULL OR pm.created_at    >= p_from)
      AND (p_to             IS NULL OR pm.created_at    <= p_to)
    ORDER BY pm.created_at DESC;
END;
$$ LANGUAGE plpgsql;
