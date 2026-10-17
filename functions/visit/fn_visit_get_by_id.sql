-- Function: fn_visit_get_by_id  |  Domain: visit
-- Single-visit counterpart to fn_visit_get_all — same joins, filtered to one id.
-- Used to return the full joined row after create/end instead of the bare
-- visit_details row.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_visit_get_by_id(p_id INT)
RETURNS TABLE(
    id                INT,
    uuid              VARCHAR,
    project_id        INT,
    project_name      VARCHAR,
    institution_id    INT,
    institution_name  VARCHAR,
    institute_code    VARCHAR,
    user_id           INT,
    full_name         VARCHAR,
    emp_code          VARCHAR,
    visit_start_image VARCHAR,
    visit_start_at    TIMESTAMPTZ,
    visit_end_image   VARCHAR,
    visit_end_at      TIMESTAMPTZ,
    is_active         SMALLINT,
    created_at        TIMESTAMPTZ,
    updated_at        TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        v.id, v.uuid,
        p.project_id, p.project_name,
        i.institute_id, i.institution_name, i.institute_code,
        u.user_id, u.full_name, u.emp_code,
        v.visit_start_image, v.visit_start_at,
        v.visit_end_image, v.visit_end_at,
        v.is_active, v.created_at, v.updated_at
    FROM visit_details v
    LEFT JOIN project     p ON p.project_id   = v.project_id
    LEFT JOIN institution i ON i.institute_id = v.institution_id
    LEFT JOIN user_tbl    u ON u.user_id       = v.user_id
    WHERE v.id = p_id;
END;
$$ LANGUAGE plpgsql;
