-- Function: fn_user_sync  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_sync(p_emp_code VARCHAR, p_name VARCHAR, p_dob DATE, p_gender VARCHAR, p_mobile VARCHAR, p_email VARCHAR, p_nationality VARCHAR)
RETURNS SETOF user_tbl AS $$
BEGIN
  RETURN QUERY INSERT INTO user_tbl (emp_code, full_name, date_of_birth, gender, mobile_number, email, nationality, is_active, created_at, updated_at)
  VALUES (p_emp_code, p_name, p_dob, p_gender, p_mobile, p_email, p_nationality, 1, NOW(), NOW())
  ON CONFLICT (emp_code) DO UPDATE SET full_name = EXCLUDED.full_name, date_of_birth = EXCLUDED.date_of_birth,
  gender = EXCLUDED.gender, mobile_number = EXCLUDED.mobile_number, email = EXCLUDED.email,
  nationality = EXCLUDED.nationality, updated_at = NOW() RETURNING *;
END;
$$ LANGUAGE plpgsql;