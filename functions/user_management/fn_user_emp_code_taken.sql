-- Function: fn_user_emp_code_taken  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_emp_code_taken(p_emp_code VARCHAR)
RETURNS TABLE(user_id INT) AS $$
BEGIN
  RETURN QUERY SELECT u.user_id FROM user_tbl u WHERE u.emp_code = p_emp_code;
END;
$$ LANGUAGE plpgsql;