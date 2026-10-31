-- Function: fn_documentation_report_type_allowed  |  Domain: documentation
-- TRUE when the report type is active and mapped to the project's state —
-- guards create/update against a type that isn't offered in that state.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_report_type_allowed(
  p_report_type_id INT,
  p_project_id     INT
)
RETURNS BOOLEAN AS $$
DECLARE v_allowed BOOLEAN;
BEGIN
  SELECT EXISTS (
    SELECT 1
    FROM documentation_report_type t
    JOIN documentation_report_type_state s ON s.report_type_id = t.id
    JOIN project p ON LOWER(TRIM(p.state)) = LOWER(s.state_name)
    WHERE t.id = p_report_type_id
      AND t.is_active = 1
      AND p.project_id = p_project_id
  ) INTO v_allowed;
  RETURN v_allowed;
END;
$$ LANGUAGE plpgsql;
