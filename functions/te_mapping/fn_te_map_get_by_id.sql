-- Function: fn_te_map_get_by_id  |  Domain: te_mapping
-- Single-mapping counterpart to fn_te_map_get_all — same joins, filtered to one map_id.
-- Used to return the full mapping after create/remove instead of the bare mapping row.
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_get_by_id(p_id INT)
RETURNS TABLE(
  map_id           INT,
  project_id       INT,  project_name     VARCHAR,
  district_id      INT,  district_name    VARCHAR,
  block_id         INT,  block_name       VARCHAR,
  institution_id   INT,  institution_name VARCHAR,  institute_code  VARCHAR,
  user_id          INT,  full_name        VARCHAR,  emp_code        VARCHAR,
  designation_id   INT,  designation_name VARCHAR,
  rm_user_id       INT,  rm_full_name     VARCHAR,  rm_emp_code     VARCHAR,
  active           SMALLINT,
  created_at       TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    m.map_id,
    m.project_id,     p.project_name,
    m.district_id,    d.district_name,
    m.block_id,       b.block_name,
    m.institution_id, i.institution_name,  i.institute_code,
    m.user_id,        u.full_name,         u.emp_code,
    ui.designation_id, dsg.designation      AS designation_name,
    m.rm_user_id,     rm.full_name         AS rm_full_name,
                      rm.emp_code          AS rm_emp_code,
    m.active,
    m.created_at
  FROM  user_institution_map  m
  LEFT JOIN project          p   ON p.project_id       = m.project_id
  LEFT JOIN district         d   ON d.district_id      = m.district_id
  LEFT JOIN block            b   ON b.block_id         = m.block_id
  LEFT JOIN institution      i   ON i.institute_id     = m.institution_id
  LEFT JOIN user_tbl         u   ON u.user_id          = m.user_id
  LEFT JOIN user_information ui  ON ui.user_id         = m.user_id
  LEFT JOIN designation      dsg ON dsg.designation_id = ui.designation_id
  LEFT JOIN user_tbl         rm  ON rm.user_id         = m.rm_user_id
  WHERE m.map_id = p_id;
END;
$$ LANGUAGE plpgsql;
