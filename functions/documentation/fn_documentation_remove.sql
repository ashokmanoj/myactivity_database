-- Function: fn_documentation_remove  |  Domain: documentation
-- Soft delete, matching tool_kit / locations convention.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_remove(p_id INT)
RETURNS VOID AS $$
BEGIN
  UPDATE documentation SET is_active = 0, updated_at = NOW()
  WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;
