-- Function: fn_documentation_report_type_update  |  Domain: documentation
-- Partial update — NULL params leave that column unchanged. A non-NULL
-- p_states replaces the type's whole state list (send [] to clear it).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_report_type_update(
  p_id               INT,
  p_report_type_name VARCHAR   DEFAULT NULL,
  p_sort_order       INT       DEFAULT NULL,
  p_states           VARCHAR[] DEFAULT NULL,
  p_is_active        SMALLINT  DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  UPDATE documentation_report_type SET
    report_type_name = COALESCE(TRIM(p_report_type_name), report_type_name),
    sort_order       = COALESCE(p_sort_order, sort_order),
    is_active        = COALESCE(p_is_active, is_active),
    updated_at       = NOW()
  WHERE id = p_id;

  IF p_states IS NOT NULL THEN
    DELETE FROM documentation_report_type_state WHERE report_type_id = p_id;
    INSERT INTO documentation_report_type_state (report_type_id, state_name)
    SELECT DISTINCT p_id, TRIM(s) FROM UNNEST(p_states) AS s
    WHERE TRIM(s) <> ''
    ON CONFLICT ON CONSTRAINT uq_documentation_report_type_state DO NOTHING;
  END IF;
END;
$$ LANGUAGE plpgsql;
