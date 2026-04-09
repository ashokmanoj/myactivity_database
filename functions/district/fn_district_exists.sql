-- Function: fn_district_exists  |  Domain: district
CREATE OR REPLACE FUNCTION fn_district_exists(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(SELECT 1 FROM district WHERE district_id = p_id AND is_active = 1);
END;
$$ LANGUAGE plpgsql;