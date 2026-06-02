-- Function: fn_te_map_get_executives  |  Domain: te_mapping
-- Returns active users for the Technical Executive dropdown.
-- Filters by designation first, then optionally by project/district/block.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_get_executives(
  p_project_id     INT DEFAULT NULL,
  p_district_id    INT DEFAULT NULL,
  p_block_id       INT DEFAULT NULL,
  p_designation_id INT DEFAULT NULL
)
RETURNS TABLE(user_id INT, full_name VARCHAR, emp_code VARCHAR, designation_name VARCHAR) AS $$
BEGIN
  RETURN QUERY
  SELECT u.user_id, u.full_name, u.emp_code,
         dsg.designation AS designation_name
  FROM   user_tbl         u
  LEFT JOIN user_information ui  ON ui.user_id         = u.user_id
  LEFT JOIN designation      dsg ON dsg.designation_id = ui.designation_id
  WHERE  u.is_active = 1
    AND (p_designation_id IS NULL OR ui.designation_id = p_designation_id)
  ORDER BY u.full_name;
END;
$$ LANGUAGE plpgsql;
