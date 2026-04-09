-- Function: fn_block_exists  |  Domain: block
CREATE OR REPLACE FUNCTION fn_block_exists(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(SELECT 1 FROM block WHERE block_id = p_id AND is_active = 1);
END;
$$ LANGUAGE plpgsql;