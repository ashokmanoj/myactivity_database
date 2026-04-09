-- Function: fn_institution_get_all  |  Domain: institution
CREATE OR REPLACE FUNCTION fn_institution_get_all(p_project_id INT DEFAULT NULL, p_district_id INT DEFAULT NULL, p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS TABLE(institute_id INT, institution_name VARCHAR, institute_code VARCHAR, project_id INT, district_id INT, block_id INT,
  address VARCHAR, pincode INT, latitude NUMERIC, longitude NUMERIC, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  project_name VARCHAR, project_code VARCHAR, district_name VARCHAR, block_name VARCHAR) AS $$
BEGIN
  RETURN QUERY SELECT i.institute_id, i.institution_name, i.institute_code, i.project_id, i.district_id, i.block_id,
    i.address, i.pincode, i.latitude, i.longitude, i.is_active, i.created_at, i.updated_at,
    p.project_name, p.project_code, d.district_name, b.block_name
  FROM instituation i
  LEFT JOIN project p ON p.project_id = i.project_id
  LEFT JOIN district d ON d.district_id = i.district_id
  LEFT JOIN block b ON b.block_id = i.block_id
  WHERE i.is_active = 1
    AND (p_project_id IS NULL OR i.project_id = p_project_id)
    AND (p_district_id IS NULL OR i.district_id = p_district_id)
    AND (p_from IS NULL OR i.created_at >= p_from)
    AND (p_to IS NULL OR i.created_at <= p_to);
END;
$$ LANGUAGE plpgsql;