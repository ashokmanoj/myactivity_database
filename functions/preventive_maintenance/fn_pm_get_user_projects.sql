-- Function: fn_pm_get_user_projects  |  Domain: preventive_maintenance
-- Returns distinct projects assigned to a user via user_institution_map.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_get_user_projects(
    p_user_id INT
)
RETURNS TABLE(
    project_id   INT,
    project_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        p.project_id,
        p.project_name
    FROM user_institution_map m
    JOIN project p ON p.project_id = m.project_id
    WHERE m.user_id = p_user_id
      AND m.active  = 1
      AND p.is_active = 1
    ORDER BY p.project_name ASC;
END;
$$ LANGUAGE plpgsql;
