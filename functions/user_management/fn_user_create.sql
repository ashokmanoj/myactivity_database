-- Function: fn_user_create  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_create(p_emp_code VARCHAR, p_name VARCHAR, p_dob DATE, p_gender VARCHAR, p_mobile VARCHAR, p_email VARCHAR, p_nationality VARCHAR)
RETURNS SETOF user_tbl AS $$
BEGIN
  RETURN QUERY INSERT INTO user_tbl (emp_code, full_name, date_of_birth, gender, mobile_number, email, nationality, is_active, created_at, updated_at)
  VALUES (p_emp_code, p_name, p_dob, p_gender, p_mobile, p_email, p_nationality, 1, NOW(), NOW()) RETURNING *;
END;
$$ LANGUAGE plpgsql;