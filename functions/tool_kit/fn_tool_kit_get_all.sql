-- Function: fn_tool_kit_get_all  |  Domain: tool_kit
-- p_user_id = NULL returns every executive's tool kit photos (web admin view).
CREATE OR REPLACE FUNCTION fn_tool_kit_get_all(p_user_id INT DEFAULT NULL)
RETURNS TABLE (
  tool_kit_image_id INT,
  user_id           INT,
  uuid              VARCHAR,
  image_name        VARCHAR,
  fullpath_url      VARCHAR,
  is_active         SMALLINT,
  created_at        TIMESTAMPTZ,
  updated_at        TIMESTAMPTZ,
  full_name         VARCHAR,
  emp_code          VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    t.tool_kit_image_id, t.user_id, t.uuid, t.image_name, t.fullpath_url,
    t.is_active, t.created_at, t.updated_at,
    u.full_name, u.emp_code
  FROM tool_kit_images t
  JOIN user_tbl u ON u.user_id = t.user_id
  WHERE (p_user_id IS NULL OR t.user_id = p_user_id)
    AND t.is_active = 1
  ORDER BY t.created_at DESC;
END;
$$ LANGUAGE plpgsql;
