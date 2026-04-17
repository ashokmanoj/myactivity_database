-- Function: fn_inst_map_sync  |  Domain: institution_map
CREATE OR REPLACE FUNCTION fn_inst_map_sync(p_project_id INT, p_institute_id INT)
RETURNS SETOF institution_project_map AS $$
BEGIN
  RETURN QUERY INSERT INTO institution_project_map (project_id, institute_id, is_active, created_at, updated_at)
  VALUES (p_project_id, p_institute_id, 1, NOW(), NOW())
  ON CONFLICT ON CONSTRAINT uq_inst_proj_map DO UPDATE SET updated_at = NOW() RETURNING *;
END;
$$ LANGUAGE plpgsql;