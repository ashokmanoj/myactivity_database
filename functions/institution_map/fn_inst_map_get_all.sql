-- Function: fn_inst_map_get_all  |  Domain: institution_map
CREATE OR REPLACE FUNCTION fn_inst_map_get_all(p_project_id INT DEFAULT NULL, p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS TABLE(institute_project_map_id INT, project_id INT, institute_id INT, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  project_name VARCHAR, project_code VARCHAR, institution_name VARCHAR, institute_code VARCHAR) AS $$
BEGIN
  RETURN QUERY SELECT m.institute_project_map_id, m.project_id, m.institute_id, m.is_active, m.created_at, m.updated_at,
    p.project_name, p.project_code, i.institution_name, i.institute_code
  FROM institution_project_map m
  JOIN project p ON p.project_id = m.project_id
  JOIN institution i ON i.institute_id = m.institute_id
  WHERE m.is_active = 1
    AND (p_project_id IS NULL OR m.project_id = p_project_id)
    AND (p_from IS NULL OR m.created_at >= p_from)
    AND (p_to IS NULL OR m.created_at <= p_to);
END;
$$ LANGUAGE plpgsql;