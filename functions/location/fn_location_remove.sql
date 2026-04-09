-- Function: fn_location_remove  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_remove(p_id INT)
RETURNS VOID AS $$
BEGIN
  UPDATE location_photos SET is_active = 0, updated_at = NOW() WHERE location_id = p_id;
  UPDATE locations SET is_active = 0, updated_at = NOW() WHERE location_id = p_id;
END;
$$ LANGUAGE plpgsql;