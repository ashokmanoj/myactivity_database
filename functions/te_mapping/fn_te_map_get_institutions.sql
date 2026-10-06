-- Function: fn_te_map_get_institutions  |  Domain: te_mapping
-- Institutions dropdown filtered by project / district / block.
-- Returns district_id too (not just for filtering by it) so a caller that
-- didn't pass p_district_id — e.g. an RM narrowing institutions down to
-- their own several posting districts client-side, since this function
-- only accepts one district id at a time — can still filter the result set.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_get_institutions(
  p_project_id  INT DEFAULT NULL,
  p_district_id INT DEFAULT NULL,
  p_block_id    INT DEFAULT NULL
)
RETURNS TABLE(institute_id INT, institution_name VARCHAR, institute_code VARCHAR, district_id INT) AS $$
BEGIN
  RETURN QUERY
  SELECT i.institute_id, i.institution_name, i.institute_code, i.district_id
  FROM   institution i
  WHERE  i.is_active = 1
    AND (p_project_id  IS NULL OR i.project_id  = p_project_id)
    AND (p_district_id IS NULL OR i.district_id = p_district_id)
    AND (p_block_id    IS NULL OR i.block_id    = p_block_id)
  ORDER BY i.institution_name;
END;
$$ LANGUAGE plpgsql;
