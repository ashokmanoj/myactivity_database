-- Function: fn_documentation_report_type_get_all  |  Domain: documentation
-- Report types for the "Select Report Type" dropdown, filtered by state.
-- p_project_id resolves the state from project.state; p_state filters by a
-- state name directly; both NULL returns every active type (web admin view).
-- State names compare case-insensitively.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_report_type_get_all(
  p_state      VARCHAR DEFAULT NULL,
  p_project_id INT     DEFAULT NULL
)
RETURNS TABLE (
  id               INT,
  report_type_name VARCHAR,
  sort_order       INT,
  is_active        SMALLINT,
  states           VARCHAR[],
  created_at       TIMESTAMPTZ,
  updated_at       TIMESTAMPTZ
) AS $$
DECLARE
  v_state VARCHAR := p_state;
BEGIN
  IF p_project_id IS NOT NULL THEN
    SELECT p.state INTO v_state FROM project p WHERE p.project_id = p_project_id;
    -- A project with no state set gets no report types rather than all of them.
    IF v_state IS NULL THEN RETURN; END IF;
  END IF;

  RETURN QUERY
  SELECT
    t.id, t.report_type_name, t.sort_order, t.is_active,
    COALESCE(
      (SELECT ARRAY_AGG(s.state_name ORDER BY s.state_name)
       FROM documentation_report_type_state s WHERE s.report_type_id = t.id),
      ARRAY[]::VARCHAR[]
    ),
    t.created_at, t.updated_at
  FROM documentation_report_type t
  WHERE t.is_active = 1
    AND (v_state IS NULL OR EXISTS (
      SELECT 1 FROM documentation_report_type_state s
      WHERE s.report_type_id = t.id AND LOWER(s.state_name) = LOWER(TRIM(v_state))
    ))
  ORDER BY t.sort_order, t.report_type_name;
END;
$$ LANGUAGE plpgsql;
