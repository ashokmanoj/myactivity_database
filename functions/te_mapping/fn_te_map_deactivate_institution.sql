-- Function: fn_te_map_deactivate_institution  |  Domain: te_mapping
-- Deactivates ALL active mappings for a given institution.
-- Returns count of rows deactivated.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_deactivate_institution(p_institution_id INT)
RETURNS INT AS $$
DECLARE
  v_count INT;
BEGIN
  UPDATE user_institution_map
  SET    active = 0, updated_at = NOW()
  WHERE  institution_id = p_institution_id AND active = 1;

  GET DIAGNOSTICS v_count = ROW_COUNT;
  RETURN v_count;
END;
$$ LANGUAGE plpgsql;
