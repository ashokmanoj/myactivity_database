-- Function: fn_location_get_user_projects  |  Domain: location
-- Mobile "Add Location" Project dropdown — active projects in the user's own
-- state (fn_user_posting_state: state of posting, falling back to address state).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_location_get_user_projects(
    p_user_id INT
)
RETURNS TABLE(
    project_id   INT,
    project_name VARCHAR,
    state        VARCHAR
) AS $$
DECLARE
  v_state VARCHAR;
BEGIN
    v_state := fn_user_posting_state(p_user_id);

    RETURN QUERY
    SELECT
        p.project_id,
        p.project_name,
        p.state
    FROM project p
    WHERE p.is_active = 1
      AND v_state IS NOT NULL
      AND LOWER(TRIM(p.state)) = LOWER(v_state)
    ORDER BY p.project_name ASC;
END;
$$ LANGUAGE plpgsql;
