-- Function: fn_user_get_all  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_get_all(p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS TABLE(user_id INT, emp_code VARCHAR, full_name VARCHAR, date_of_birth DATE, gender VARCHAR,
  mobile_number VARCHAR, email VARCHAR, nationality VARCHAR, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  user_info_id INT, designation_id INT, department VARCHAR, company_id INT) AS $$
BEGIN
  RETURN QUERY
  SELECT u.user_id, u.emp_code, u.full_name, u.date_of_birth, u.gender,
         u.mobile_number, u.email, u.nationality, u.is_active, u.created_at, u.updated_at,
         ui.user_info_id, ui.designation_id, ui.department, ui.company_id
  FROM user_tbl u LEFT JOIN user_information ui ON ui.user_id = u.user_id
  WHERE u.is_active = 1
    AND (p_from IS NULL OR u.created_at >= p_from)
    AND (p_to IS NULL OR u.created_at <= p_to);
END;
$$ LANGUAGE plpgsql;