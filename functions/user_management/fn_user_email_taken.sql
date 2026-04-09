-- Function: fn_user_email_taken  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_email_taken(p_email VARCHAR)
RETURNS TABLE(user_id INT) AS $$
BEGIN
  RETURN QUERY SELECT u.user_id FROM user_tbl u WHERE u.email = p_email;
END;
$$ LANGUAGE plpgsql;