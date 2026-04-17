-- Function: fn_inst_map_remove  |  Domain: institution_map
CREATE OR REPLACE FUNCTION fn_inst_map_remove(p_id INT)
RETURNS SETOF institution_project_map AS $$
BEGIN
  RETURN QUERY UPDATE institution_project_map SET is_active = 0, updated_at = NOW() WHERE institute_project_map_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;