-- Function: fn_location_update  |  Domain: location
CREATE OR REPLACE FUNCTION fn_location_update(
  p_id           INT,
  p_name         VARCHAR,
  p_type         VARCHAR,
  p_lat          NUMERIC,
  p_lon          NUMERIC,
  p_address      VARCHAR,
  p_pincode      VARCHAR,
  p_desc         VARCHAR,
  p_inst_id      INT,
  p_inst_name    VARCHAR DEFAULT NULL,
  p_project_id   INT     DEFAULT NULL,
  p_project_name VARCHAR DEFAULT NULL
)
RETURNS SETOF locations AS $$
BEGIN
  RETURN QUERY
  UPDATE locations SET
    location_name    = COALESCE(p_name,     location_name),
    location_type    = COALESCE(p_type,     location_type),
    lat              = COALESCE(p_lat,      lat),
    lon              = COALESCE(p_lon,      lon),
    geo_address      = COALESCE(p_address,  geo_address),
    geo_pincode      = COALESCE(p_pincode,  geo_pincode),
    description      = COALESCE(p_desc,     description),
    institution_id   = COALESCE(p_inst_id,  institution_id),
    institution_name = COALESCE(p_inst_name,
                                (SELECT i.institution_name FROM institution i WHERE i.institute_id = p_inst_id),
                                institution_name),
    project_id       = COALESCE(p_project_id, project_id),
    project_name     = COALESCE(p_project_name,
                                (SELECT pr.project_name FROM project pr WHERE pr.project_id = p_project_id),
                                project_name),
    updated_at       = NOW()
  WHERE location_id = p_id
  RETURNING *;
END;
$$ LANGUAGE plpgsql;
