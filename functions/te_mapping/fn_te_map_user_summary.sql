-- Function: fn_te_map_user_summary  |  Domain: te_mapping
-- One row per technical user with how many institutions (schools) are
-- assigned to them in user_institution_map, plus how many of those have a
-- master lat/lon and how many are location-verified.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_user_summary(
  p_project_id     INT DEFAULT NULL,
  p_district_id    INT DEFAULT NULL,
  p_block_id       INT DEFAULT NULL,
  p_rm_id          INT DEFAULT NULL,
  p_designation_id INT DEFAULT NULL,
  p_user_id        INT DEFAULT NULL
)
RETURNS TABLE(
  user_id              INT,
  full_name            VARCHAR,
  emp_code             VARCHAR,
  mobile_number        VARCHAR,
  designation_id       INT,
  designation_name     VARCHAR,
  rm_user_id           INT,
  rm_full_name         VARCHAR,
  total_institutions   INT,
  with_location        INT,
  verified             INT,
  project_count        INT,
  district_count       INT,
  projects             TEXT,
  districts            TEXT,
  last_assigned_at     TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.user_id,
    u.full_name,
    u.emp_code,
    u.mobile_number,
    ui.designation_id,
    dsg.designation                                                   AS designation_name,
    -- a user is normally under one RM; take the most recent if mappings disagree
    (ARRAY_AGG(m.rm_user_id   ORDER BY m.created_at DESC))[1]         AS rm_user_id,
    (ARRAY_AGG(rm.full_name   ORDER BY m.created_at DESC))[1]         AS rm_full_name,
    COUNT(DISTINCT m.institution_id)::INT                             AS total_institutions,
    COUNT(DISTINCT m.institution_id) FILTER (
      WHERE i.latitude IS NOT NULL AND i.longitude IS NOT NULL)::INT  AS with_location,
    COUNT(DISTINCT m.institution_id) FILTER (
      WHERE i.is_verified = 1)::INT                                   AS verified,
    COUNT(DISTINCT m.project_id)::INT                                 AS project_count,
    COUNT(DISTINCT COALESCE(m.district_id, i.district_id))::INT       AS district_count,
    STRING_AGG(DISTINCT p.project_name,  ', ')                        AS projects,
    STRING_AGG(DISTINCT d.district_name, ', ')                        AS districts,
    MAX(m.created_at)                                                 AS last_assigned_at
  FROM  user_institution_map  m
  JOIN      user_tbl         u   ON u.user_id          = m.user_id
  JOIN      institution      i   ON i.institute_id     = m.institution_id AND i.is_active = 1
  LEFT JOIN user_information ui  ON ui.user_id         = m.user_id
  LEFT JOIN designation      dsg ON dsg.designation_id = ui.designation_id
  LEFT JOIN user_tbl         rm  ON rm.user_id         = m.rm_user_id
  LEFT JOIN project          p   ON p.project_id       = m.project_id
  LEFT JOIN district         d   ON d.district_id      = COALESCE(m.district_id, i.district_id)
  WHERE m.active = 1
    AND (p_project_id     IS NULL OR m.project_id      = p_project_id)
    AND (p_district_id    IS NULL OR COALESCE(m.district_id, i.district_id) = p_district_id)
    AND (p_block_id       IS NULL OR COALESCE(m.block_id, i.block_id) = p_block_id)
    AND (p_rm_id          IS NULL OR m.rm_user_id      = p_rm_id)
    AND (p_designation_id IS NULL OR ui.designation_id = p_designation_id)
    AND (p_user_id        IS NULL OR m.user_id         = p_user_id)
  GROUP BY u.user_id, u.full_name, u.emp_code, u.mobile_number,
           ui.designation_id, dsg.designation
  -- by position: the output names clash with the RETURNS TABLE variables
  ORDER BY 9 DESC, 2;
END;
$$ LANGUAGE plpgsql;
