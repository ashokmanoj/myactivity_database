-- Function: fn_te_map_create  |  Domain: te_mapping
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_create(
  p_project_id     INT,
  p_district_id    INT,
  p_block_id       INT,
  p_institution_id INT,
  p_user_id        INT,
  p_rm_user_id     INT DEFAULT NULL
)
RETURNS SETOF user_institution_map AS $$
BEGIN
  RETURN QUERY
  INSERT INTO user_institution_map
    (project_id, district_id, block_id, institution_id, user_id, rm_user_id, active, created_at, updated_at)
  VALUES
    (p_project_id, p_district_id, p_block_id, p_institution_id, p_user_id, p_rm_user_id, 1, NOW(), NOW())
  RETURNING *;
END;
$$ LANGUAGE plpgsql;
