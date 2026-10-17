-- Function: fn_visit_get_all  |  Domain: visit
-- Lists visits newest-first, joined with project/institution/user for display.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_visit_get_all(
    p_project_id     INT     DEFAULT NULL,
    p_institution_id INT     DEFAULT NULL,
    p_user_id        INT     DEFAULT NULL,
    p_is_active      SMALLINT DEFAULT NULL
)
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
    WHERE (p_project_id     IS NULL OR v.project_id     = p_project_id)
      AND (p_institution_id IS NULL OR v.institution_id = p_institution_id)
      AND (p_user_id        IS NULL OR v.user_id        = p_user_id)
      AND (p_is_active      IS NULL OR v.is_active      = p_is_active)
    ORDER BY v.created_at DESC;
END;
$$ LANGUAGE plpgsql;
