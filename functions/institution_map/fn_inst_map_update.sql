-- Function: fn_inst_map_update  |  Domain: institution_map
CREATE OR REPLACE FUNCTION fn_inst_map_update(p_id INT, p_project_id INT, p_institute_id INT)
RETURNS SETOF instituation_project_map AS $$
BEGIN
  RETURN QUERY UPDATE instituation_project_map SET project_id = COALESCE(p_project_id, project_id),
  institute_id = COALESCE(p_institute_id, institute_id), updated_at = NOW()
  WHERE institute_project_map_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;