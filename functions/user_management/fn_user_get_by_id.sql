-- Function: fn_user_get_by_id  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_get_by_id(p_id INT)
RETURNS TABLE(user_id INT, emp_code VARCHAR, full_name VARCHAR, date_of_birth DATE, gender VARCHAR,
  mobile_number VARCHAR, email VARCHAR, nationality VARCHAR, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  user_info_id INT, designation_id INT, department VARCHAR, company_id INT, perm_address VARCHAR, curr_address VARCHAR) AS $$
BEGIN
  RETURN QUERY
  SELECT u.user_id, u.emp_code, u.full_name, u.date_of_birth, u.gender,
         u.mobile_number, u.email, u.nationality, u.is_active, u.created_at, u.updated_at,
         ui.user_info_id, ui.designation_id, ui.department, ui.company_id, ui.perm_address, ui.curr_address
  FROM user_tbl u LEFT JOIN user_information ui ON ui.user_id = u.user_id
  WHERE u.user_id = p_id AND u.is_active = 1;
END;
$$ LANGUAGE plpgsql;