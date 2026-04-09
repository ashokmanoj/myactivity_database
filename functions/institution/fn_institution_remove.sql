-- Function: fn_institution_remove  |  Domain: institution
CREATE OR REPLACE FUNCTION fn_institution_remove(p_id INT)
RETURNS SETOF instituation AS $$
BEGIN
  RETURN QUERY UPDATE instituation SET is_active = 0, updated_at = NOW() WHERE institute_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;