-- Function: fn_tool_kit_exists  |  Domain: tool_kit
CREATE OR REPLACE FUNCTION fn_tool_kit_exists(p_id INT)
RETURNS BOOLEAN AS $$
DECLARE v_exists BOOLEAN;
BEGIN
  SELECT EXISTS (SELECT 1 FROM tool_kit_images WHERE tool_kit_image_id = p_id) INTO v_exists;
  RETURN v_exists;
END;
$$ LANGUAGE plpgsql;
