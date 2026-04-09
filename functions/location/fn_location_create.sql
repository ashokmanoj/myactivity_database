-- Function: fn_location_create  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_create(p_user_id INT, p_name VARCHAR, p_type VARCHAR, p_lat NUMERIC, p_lon NUMERIC, p_address VARCHAR, p_pincode VARCHAR, p_desc VARCHAR, p_inst_id INT)
RETURNS SETOF locations AS $$
BEGIN
  RETURN QUERY INSERT INTO locations (user_id, location_name, location_type, lat, lon, geo_address, geo_pincode, description, institution_id, is_active, created_at, updated_at)
  VALUES (p_user_id, p_name, p_type, p_lat, p_lon, p_address, p_pincode, p_desc, p_inst_id, 1, NOW(), NOW()) RETURNING *;
END;
$$ LANGUAGE plpgsql;