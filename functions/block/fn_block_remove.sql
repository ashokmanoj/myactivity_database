-- Function: fn_block_remove  |  Domain: block
CREATE OR REPLACE FUNCTION fn_block_remove(p_id INT)
RETURNS SETOF block AS $$
BEGIN
  RETURN QUERY UPDATE block SET is_active = 0, updated_at = NOW() WHERE block_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;