-- Function: fn_documentation_report_type_get_by_id  |  Domain: documentation
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_report_type_get_by_id(p_id INT)
RETURNS TABLE (
  id               INT,
  report_type_name VARCHAR,
  sort_order       INT,
  is_active        SMALLINT,
  states           VARCHAR[],
  created_at       TIMESTAMPTZ,
  updated_at       TIMESTAMPTZ
) AS $$
BEGIN
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
  WHERE t.id = p_id;
END;
$$ LANGUAGE plpgsql;
