-- Function: fn_location_get_all  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_get_all(p_user_id INT DEFAULT NULL, p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS TABLE(location_id INT, user_id INT, location_name VARCHAR, location_type VARCHAR,
  lat NUMERIC, lon NUMERIC, geo_address VARCHAR, geo_pincode VARCHAR, description VARCHAR,
  institution_id INT, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  emp_code VARCHAR, full_name VARCHAR, mobile_number VARCHAR, institution_name VARCHAR, institute_code VARCHAR) AS $$
BEGIN
  RETURN QUERY
  SELECT l.location_id, l.user_id, l.location_name, l.location_type,
         l.lat, l.lon, l.geo_address, l.geo_pincode, l.description,
         l.institution_id, l.is_active, l.created_at, l.updated_at,
         u.emp_code, u.full_name, u.mobile_number, i.institution_name, i.institute_code
  FROM locations l
  JOIN user_tbl u ON u.user_id = l.user_id
  LEFT JOIN institution i ON i.institute_id = l.institution_id
  WHERE l.is_active = 1    AND (p_user_id IS NULL OR l.user_id = p_user_id)
    AND (p_from IS NULL OR l.created_at >= p_from)
    AND (p_to IS NULL OR l.created_at <= p_to);
END;
$$ LANGUAGE plpgsql;