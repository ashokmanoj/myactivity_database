-- Function: fn_institution_update  |  Domain: institution
CREATE OR REPLACE FUNCTION fn_institution_update(p_id INT, p_name VARCHAR, p_code VARCHAR, p_project_id INT, p_district_id INT, p_block_id INT, p_address VARCHAR, p_pincode INT, p_lat NUMERIC, p_lon NUMERIC)
RETURNS SETOF instituation AS $$
BEGIN
  RETURN QUERY UPDATE instituation SET institution_name = COALESCE(p_name, institution_name), institute_code = COALESCE(p_code, institute_code),
  project_id = COALESCE(p_project_id, project_id), district_id = COALESCE(p_district_id, district_id), block_id = COALESCE(p_block_id, block_id),
  address = COALESCE(p_address, address), pincode = COALESCE(p_pincode, pincode), latitude = COALESCE(p_lat, latitude), longitude = COALESCE(p_lon, longitude),
  updated_at = NOW() WHERE institute_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;