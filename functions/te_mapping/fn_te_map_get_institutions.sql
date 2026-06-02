-- Function: fn_te_map_get_institutions  |  Domain: te_mapping
-- Institutions dropdown filtered by project / district / block.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_get_institutions(
  p_project_id  INT DEFAULT NULL,
  p_district_id INT DEFAULT NULL,
  p_block_id    INT DEFAULT NULL
)
RETURNS TABLE(institute_id INT, institution_name VARCHAR, institute_code VARCHAR) AS $$
BEGIN
  RETURN QUERY
  SELECT i.institute_id, i.institution_name, i.institute_code
  FROM   institution i
  WHERE  i.is_active = 1
    AND (p_project_id  IS NULL OR i.project_id  = p_project_id)
    AND (p_district_id IS NULL OR i.district_id = p_district_id)
    AND (p_block_id    IS NULL OR i.block_id    = p_block_id)
  ORDER BY i.institution_name;
END;
$$ LANGUAGE plpgsql;
