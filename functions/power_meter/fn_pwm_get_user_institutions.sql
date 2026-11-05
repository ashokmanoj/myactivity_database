-- Function: fn_pwm_get_user_institutions  |  Domain: power_meter
-- Primary: institutions this executive is explicitly mapped to (user_institution_map).
-- Fallback: same as fn_pwm_get_user_projects — if they have no mapping yet, show
-- every active institution under the active, state-matched project(s) instead
-- (narrowed to p_project_id when one was picked), so picking a state-fallback
-- project doesn't immediately dead-end on an empty institution list.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_get_user_institutions(
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
DECLARE
  v_state VARCHAR;
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

    IF FOUND THEN
      RETURN;
    END IF;

    SELECT NULLIF(TRIM(ui.state_of_posting), '')
    INTO v_state
    FROM user_information ui
    WHERE ui.user_id = p_user_id;

    RETURN QUERY
    SELECT DISTINCT
        i.institute_id,
        i.institution_name,
        i.institute_code,
        p.project_id,
        p.project_name
    FROM institution i
    JOIN project p ON p.project_id = i.project_id
    WHERE i.is_active = 1
      AND p.is_active = 1
      AND v_state IS NOT NULL
      AND LOWER(TRIM(p.state)) = LOWER(v_state)
      AND (p_project_id IS NULL OR i.project_id = p_project_id)
    ORDER BY i.institution_name ASC;
END;
$$ LANGUAGE plpgsql;
