-- Function: fn_te_map_get_by_user  |  Domain: te_mapping
-- The institutions (schools) assigned to one technical user, with each
-- institution's master location and verification status.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_get_by_user(
  p_user_id     INT,
  p_project_id  INT DEFAULT NULL,
  p_district_id INT DEFAULT NULL,
  p_block_id    INT DEFAULT NULL
)
RETURNS TABLE(
  map_id           INT,
  institution_id   INT,  institution_name VARCHAR,  institute_code VARCHAR,
  project_id       INT,  project_name     VARCHAR,
  district_id      INT,  district_name    VARCHAR,
  block_id         INT,  block_name       VARCHAR,
  pincode          INT,
  address          VARCHAR,
  latitude         NUMERIC,
  longitude        NUMERIC,
  is_verified      SMALLINT,
  rm_user_id       INT,  rm_full_name     VARCHAR,
  assigned_at      TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.map_id,
    m.institution_id, i.institution_name, i.institute_code,
    m.project_id,     p.project_name,
    COALESCE(m.district_id, i.district_id), d.district_name,
    COALESCE(m.block_id, i.block_id), b.block_name,
    i.pincode,
    i.address,
    i.latitude,
    i.longitude,
    COALESCE(i.is_verified, 0)::SMALLINT,
    m.rm_user_id,     rm.full_name,
    m.created_at
  FROM  user_institution_map  m
  JOIN      institution i  ON i.institute_id = m.institution_id AND i.is_active = 1
  LEFT JOIN project     p  ON p.project_id   = m.project_id
  LEFT JOIN district    d  ON d.district_id  = COALESCE(m.district_id, i.district_id)
  LEFT JOIN block       b  ON b.block_id     = COALESCE(m.block_id, i.block_id)
  LEFT JOIN user_tbl    rm ON rm.user_id     = m.rm_user_id
  WHERE m.active  = 1
    AND m.user_id = p_user_id
    AND (p_project_id  IS NULL OR m.project_id  = p_project_id)
    AND (p_district_id IS NULL OR COALESCE(m.district_id, i.district_id) = p_district_id)
    AND (p_block_id    IS NULL OR COALESCE(m.block_id, i.block_id) = p_block_id)
  ORDER BY p.project_name NULLS LAST, d.district_name NULLS LAST, i.institution_name;
END;
$$ LANGUAGE plpgsql;
