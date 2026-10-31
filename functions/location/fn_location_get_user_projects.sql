-- Function: fn_location_get_user_projects  |  Domain: location
-- Mobile "Add Location" Project dropdown — active projects whose state
-- matches the user's state of posting (user_information.state_of_posting).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_location_get_user_projects(
    p_user_id INT
)
RETURNS TABLE(
    project_id   INT,
    project_name VARCHAR,
    state        VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.project_id,
        p.project_name,
        p.state
    FROM user_information ui
    JOIN project p ON LOWER(TRIM(p.state)) = LOWER(TRIM(ui.state_of_posting))
    WHERE ui.user_id   = p_user_id
      AND p.is_active  = 1
    ORDER BY p.project_name ASC;
END;
$$ LANGUAGE plpgsql;
