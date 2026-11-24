-- Function: fn_institution_get_by_project  |  Domain: institution
-- Project → Institution dropdown (GET /dropdown/user-institutions?projectId=).
-- Every active institution belonging to the selected project, whether linked
-- through institution.project_id or through institution_project_map — not
-- limited to the logged-in user's user_institution_map assignments.
-- Same columns as fn_pwm_get_user_institutions so callers see no shape change.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_institution_get_by_project(
    p_project_id INT
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
    SELECT
        i.institute_id,
        i.institution_name,
        i.institute_code,
        p.project_id,
        p.project_name
    FROM institution i
    JOIN project p ON p.project_id = p_project_id
    WHERE i.is_active = 1
      AND (i.project_id = p_project_id
           OR EXISTS (
               SELECT 1 FROM institution_project_map m
               WHERE m.institute_id = i.institute_id
                 AND m.project_id   = p_project_id
                 AND m.is_active    = 1
           ))
    ORDER BY i.institution_name ASC;
END;
$$ LANGUAGE plpgsql;
