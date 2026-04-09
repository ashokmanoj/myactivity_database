-- Function: fn_location_update  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_update(p_id INT, p_name VARCHAR, p_type VARCHAR, p_lat NUMERIC, p_lon NUMERIC, p_address VARCHAR, p_pincode VARCHAR, p_desc VARCHAR, p_inst_id INT)
RETURNS SETOF locations AS $$
BEGIN
  RETURN QUERY UPDATE locations SET location_name = COALESCE(p_name, location_name), location_type = COALESCE(p_type, location_type),
  lat = COALESCE(p_lat, lat), lon = COALESCE(p_lon, lon), geo_address = COALESCE(p_address, geo_address),
  geo_pincode = COALESCE(p_pincode, geo_pincode), description = COALESCE(p_desc, description),
  institution_id = COALESCE(p_inst_id, institution_id), updated_at = NOW()
  WHERE location_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;