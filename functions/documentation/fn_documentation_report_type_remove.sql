-- Function: fn_documentation_report_type_remove  |  Domain: documentation
-- Soft delete — existing documentation rows keep pointing at it.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_report_type_remove(p_id INT)
RETURNS VOID AS $$
BEGIN
  UPDATE documentation_report_type SET is_active = 0, updated_at = NOW()
  WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;
