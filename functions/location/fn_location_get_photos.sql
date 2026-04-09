-- Function: fn_location_get_photos  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_get_photos(p_location_ids INT[])
RETURNS SETOF location_photos AS $$
BEGIN
  RETURN QUERY SELECT * FROM location_photos WHERE location_id = ANY(p_location_ids) AND is_active = 1;
END;
$$ LANGUAGE plpgsql;