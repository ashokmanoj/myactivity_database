-- Function: fn_location_add_photo  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_add_photo(p_location_id INT, p_filename VARCHAR, p_url VARCHAR)
RETURNS SETOF location_photos AS $$
BEGIN
  RETURN QUERY INSERT INTO location_photos (location_id, photo_filename, fullpath_url, is_active, created_at, updated_at)
  VALUES (p_location_id, p_filename, p_url, 1, NOW(), NOW()) RETURNING *;
END;
$$ LANGUAGE plpgsql;