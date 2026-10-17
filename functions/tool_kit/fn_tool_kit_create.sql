-- Function: fn_tool_kit_create  |  Domain: tool_kit
-- Idempotent on uuid (mobile offline-sync retry safe) — a NULL uuid never
-- conflicts with anything, so direct web submissions without one just insert.
CREATE OR REPLACE FUNCTION fn_tool_kit_create(
  p_user_id      INT,
  p_uuid         VARCHAR,
  p_image_name   VARCHAR,
  p_fullpath_url VARCHAR
)
RETURNS SETOF tool_kit_images AS $$
BEGIN
  RETURN QUERY
  INSERT INTO tool_kit_images (user_id, uuid, image_name, fullpath_url)
  VALUES (p_user_id, p_uuid, p_image_name, p_fullpath_url)
  ON CONFLICT (uuid) DO UPDATE SET
    image_name   = EXCLUDED.image_name,
    fullpath_url = EXCLUDED.fullpath_url,
    updated_at   = NOW()
  RETURNING *;
END;
$$ LANGUAGE plpgsql;
