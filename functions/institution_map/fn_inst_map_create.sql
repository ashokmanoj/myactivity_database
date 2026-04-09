-- Function: fn_inst_map_create  |  Domain: institution_map
CREATE OR REPLACE FUNCTION fn_inst_map_create(p_project_id INT, p_institute_id INT)
RETURNS SETOF instituation_project_map AS $$
BEGIN
  RETURN QUERY INSERT INTO instituation_project_map (project_id, institute_id, is_active, created_at, updated_at)
  VALUES (p_project_id, p_institute_id, 1, NOW(), NOW()) RETURNING *;
END;
$$ LANGUAGE plpgsql;