-- Function: fn_tool_kit_remove  |  Domain: tool_kit
-- Soft delete, matching locations/location_photos convention.
CREATE OR REPLACE FUNCTION fn_tool_kit_remove(p_id INT)
RETURNS VOID AS $$
BEGIN
  UPDATE tool_kit_images SET is_active = 0, updated_at = NOW()
  WHERE tool_kit_image_id = p_id;
END;
$$ LANGUAGE plpgsql;
