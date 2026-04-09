-- Function: fn_inst_map_exists  |  Domain: institution_map
CREATE OR REPLACE FUNCTION fn_inst_map_exists(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(SELECT 1 FROM instituation_project_map WHERE institute_project_map_id = p_id AND is_active = 1);
END;
$$ LANGUAGE plpgsql;