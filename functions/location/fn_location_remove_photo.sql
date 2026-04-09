-- Function: fn_location_remove_photo  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_remove_photo(p_photo_id INT)
RETURNS SETOF location_photos AS $$
BEGIN
  RETURN QUERY UPDATE location_photos SET is_active = 0, updated_at = NOW() WHERE location_photo_id = p_photo_id RETURNING *;
END;
$$ LANGUAGE plpgsql;