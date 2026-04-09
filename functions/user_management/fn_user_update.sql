-- Function: fn_user_update  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_update(p_id INT, p_emp_code VARCHAR, p_name VARCHAR, p_dob DATE, p_gender VARCHAR, p_mobile VARCHAR, p_email VARCHAR, p_nationality VARCHAR)
RETURNS SETOF user_tbl AS $$
BEGIN
  RETURN QUERY UPDATE user_tbl SET emp_code = COALESCE(p_emp_code, emp_code), full_name = COALESCE(p_name, full_name),
  date_of_birth = COALESCE(p_dob, date_of_birth), gender = COALESCE(p_gender, gender),
  mobile_number = COALESCE(p_mobile, mobile_number), email = COALESCE(p_email, email),
  nationality = COALESCE(p_nationality, nationality), updated_at = NOW()
  WHERE user_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;