-- Function: fn_user_get_by_emp_code  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_get_by_emp_code(p_emp_code VARCHAR)
RETURNS SETOF user_tbl AS $$
BEGIN
  RETURN QUERY SELECT * FROM user_tbl WHERE emp_code = p_emp_code AND is_active = 1;
END;
$$ LANGUAGE plpgsql;