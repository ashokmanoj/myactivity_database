-- Function: fn_user_exists  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_exists(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(SELECT 1 FROM user_tbl WHERE user_id = p_id AND is_active = 1);
END;
$$ LANGUAGE plpgsql;