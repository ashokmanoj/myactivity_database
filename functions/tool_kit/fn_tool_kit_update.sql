-- Function: fn_tool_kit_update  |  Domain: tool_kit
-- Partial update — NULL params leave that column unchanged.
CREATE OR REPLACE FUNCTION fn_tool_kit_update(
  p_id           INT,
  p_image_name   VARCHAR,
  p_fullpath_url VARCHAR,
  p_is_active    SMALLINT
)
RETURNS SETOF tool_kit_images AS $$
BEGIN
  RETURN QUERY
  UPDATE tool_kit_images SET
    image_name   = COALESCE(p_image_name, image_name),
    fullpath_url = COALESCE(p_fullpath_url, fullpath_url),
    is_active    = COALESCE(p_is_active, is_active),
    updated_at   = NOW()
  WHERE tool_kit_image_id = p_id
  RETURNING *;
END;
$$ LANGUAGE plpgsql;
