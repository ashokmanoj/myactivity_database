-- Function: fn_user_remove  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_remove(p_id INT)
RETURNS SETOF user_tbl AS $$
BEGIN
  RETURN QUERY UPDATE user_tbl SET is_active = 0, updated_at = NOW() WHERE user_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;