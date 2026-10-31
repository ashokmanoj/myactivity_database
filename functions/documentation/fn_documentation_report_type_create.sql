-- Function: fn_documentation_report_type_create  |  Domain: documentation
-- Creates a report type and the states it applies to. Returns the new id.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_report_type_create(
  p_report_type_name VARCHAR,
  p_sort_order       INT       DEFAULT NULL,
  p_states           VARCHAR[] DEFAULT NULL
)
RETURNS INT AS $$
DECLARE
  v_id INT;
BEGIN
  INSERT INTO documentation_report_type (report_type_name, sort_order)
  VALUES (TRIM(p_report_type_name), COALESCE(p_sort_order, 0))
  RETURNING documentation_report_type.id INTO v_id;

  INSERT INTO documentation_report_type_state (report_type_id, state_name)
  SELECT DISTINCT v_id, TRIM(s) FROM UNNEST(COALESCE(p_states, ARRAY[]::VARCHAR[])) AS s
  WHERE TRIM(s) <> ''
  ON CONFLICT ON CONSTRAINT uq_documentation_report_type_state DO NOTHING;

  RETURN v_id;
END;
$$ LANGUAGE plpgsql;
