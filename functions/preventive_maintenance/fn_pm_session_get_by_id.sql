-- Function: fn_pm_session_get_by_id  |  Domain: preventive_maintenance
-- Returns a single PM session with full project/institution/user detail,
-- expanded with one row per answer (LEFT JOIN so sessions with no answers are included).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_session_get_by_id(
    p_pm_id INT
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
    answer_id        INT,
    question_id      INT,
    q_id             VARCHAR,
    question         TEXT,
    q_type           VARCHAR,
    answer           VARCHAR,
    photo_path       VARCHAR,
    sort_order       INT
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
        a.answer_id,
        q.question_id,
        q.q_id,
        q.question,
        q.q_type,
        a.answer,
        a.photo_path,
        q.sort_order
    FROM preventive_maintenance pm
    LEFT JOIN project     p ON p.project_id   = pm.project_id
    LEFT JOIN institution i ON i.institute_id  = pm.institution_id
    LEFT JOIN user_tbl    u ON u.user_id       = pm.user_id
    LEFT JOIN pm_answer   a ON a.pm_id         = pm.pm_id
    LEFT JOIN pm_question q ON q.question_id   = a.question_id
    WHERE pm.pm_id = p_pm_id
    ORDER BY q.sort_order ASC NULLS LAST;
END;
$$ LANGUAGE plpgsql;
