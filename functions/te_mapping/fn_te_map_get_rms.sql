-- Function: fn_te_map_get_rms  |  Domain: te_mapping
-- Returns users with Regional Manager or Regional Manager Head role.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_get_rms()
RETURNS TABLE(user_id INT, full_name VARCHAR, emp_code VARCHAR) AS $$
BEGIN
  RETURN QUERY
  SELECT u.user_id, u.full_name, u.emp_code
  FROM   user_tbl         u
  JOIN   user_information ui ON ui.user_id  = u.user_id
  JOIN   roles            r  ON r.role_id   = ui.role_id
  WHERE  r.role_name IN ('Regional Manager', 'Regional Manager Head')
    AND  u.is_active = 1
  ORDER BY u.full_name;
END;
$$ LANGUAGE plpgsql;
