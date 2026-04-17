-- Function: fn_institution_sync  |  Domain: institution
CREATE OR REPLACE FUNCTION fn_institution_sync(p_name VARCHAR, p_code VARCHAR, p_project_id INT, p_district_id INT, p_block_id INT, p_address VARCHAR, p_pincode INT, p_lat NUMERIC, p_lon NUMERIC)
RETURNS SETOF institution AS $$
BEGIN
  RETURN QUERY INSERT INTO institution (institution_name, institute_code, project_id, district_id, block_id, address, pincode, latitude, longitude, is_active, created_at, updated_at)
  VALUES (p_name, p_code, p_project_id, p_district_id, p_block_id, p_address, p_pincode, p_lat, p_lon, 1, NOW(), NOW())
  ON CONFLICT (institute_code) DO UPDATE SET institution_name = EXCLUDED.institution_name, district_id = EXCLUDED.district_id,
  block_id = EXCLUDED.block_id, address = EXCLUDED.address, pincode = EXCLUDED.pincode, latitude = EXCLUDED.latitude, longitude = EXCLUDED.longitude, updated_at = NOW()
  RETURNING *;
END;
$$ LANGUAGE plpgsql;