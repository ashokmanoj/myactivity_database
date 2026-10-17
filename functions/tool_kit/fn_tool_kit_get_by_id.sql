-- Function: fn_tool_kit_get_by_id  |  Domain: tool_kit
CREATE OR REPLACE FUNCTION fn_tool_kit_get_by_id(p_id INT)
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
  WHERE t.tool_kit_image_id = p_id;
END;
$$ LANGUAGE plpgsql;
