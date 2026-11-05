-- Function: fn_pwm_get_user_projects  |  Domain: power_meter
-- Primary: projects this executive is explicitly mapped to (user_institution_map,
-- set up via Tech Exec Mapping). Fallback: if they have no mapping yet (e.g. a
-- newly onboarded executive), show every active project in their own posted
-- state instead, so the dropdown isn't empty while they're waiting to be mapped.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_get_user_projects(
    p_user_id INT
)
RETURNS TABLE(
    project_id   INT,
    project_name VARCHAR
) AS $$
DECLARE
  v_state VARCHAR;
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        p.project_id,
        p.project_name
    FROM user_institution_map m
    JOIN project p ON p.project_id = m.project_id
    WHERE m.user_id  = p_user_id
      AND m.active   = 1
      AND p.is_active = 1
    ORDER BY p.project_name ASC;

    IF FOUND THEN
      RETURN;
    END IF;

    SELECT NULLIF(TRIM(ui.state_of_posting), '')
    INTO v_state
    FROM user_information ui
    WHERE ui.user_id = p_user_id;

    RETURN QUERY
    SELECT p.project_id, p.project_name
    FROM project p
    WHERE p.is_active = 1
      AND v_state IS NOT NULL
      AND LOWER(TRIM(p.state)) = LOWER(v_state)
    ORDER BY p.project_name ASC;
END;
$$ LANGUAGE plpgsql;
