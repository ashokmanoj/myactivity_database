-- Function: fn_pm_get_user_institutions  |  Domain: preventive_maintenance
-- Returns distinct institutions assigned to a user, optionally filtered by project.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_get_user_institutions(
    p_user_id    INT,
    p_project_id INT DEFAULT NULL
)
RETURNS TABLE(
    institute_id     INT,
    institution_name VARCHAR,
    institute_code   VARCHAR,
    project_id       INT,
    project_name     VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        i.institute_id,
        i.institution_name,
        i.institute_code,
        p.project_id,
        p.project_name
    FROM user_institution_map m
    JOIN institution i ON i.institute_id = m.institution_id
    JOIN project     p ON p.project_id   = m.project_id
    WHERE m.user_id   = p_user_id
      AND m.active    = 1
      AND i.is_active = 1
      AND (p_project_id IS NULL OR m.project_id = p_project_id)
    ORDER BY i.institution_name ASC;
END;
$$ LANGUAGE plpgsql;
