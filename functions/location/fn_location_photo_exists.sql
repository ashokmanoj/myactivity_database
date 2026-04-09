-- Function: fn_location_photo_exists  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_photo_exists(p_photo_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(SELECT 1 FROM location_photos WHERE location_photo_id = p_photo_id AND is_active = 1);
END;
$$ LANGUAGE plpgsql;