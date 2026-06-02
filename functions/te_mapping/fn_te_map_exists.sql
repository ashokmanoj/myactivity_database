-- Function: fn_te_map_exists  |  Domain: te_mapping
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_exists(p_map_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_institution_map
    WHERE  map_id = p_map_id AND active = 1
  );
END;
$$ LANGUAGE plpgsql;
