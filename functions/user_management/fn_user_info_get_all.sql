-- Function: fn_user_info_get_all  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_info_get_all()
RETURNS TABLE(user_info_id INT, user_id INT, company_id INT, last_login_at TIMESTAMPTZ, title VARCHAR,
  photo_available BOOLEAN, photo_path VARCHAR, payroll_group VARCHAR, emergency_phone VARCHAR,
  father_name VARCHAR, mother_name VARCHAR, spouse_name VARCHAR, aadhar_number VARCHAR, pan_number VARCHAR,
  perm_address VARCHAR, perm_city VARCHAR, perm_state VARCHAR, perm_country VARCHAR, perm_pincode VARCHAR,
  curr_address VARCHAR, curr_city VARCHAR, curr_state VARCHAR, curr_country VARCHAR, curr_pincode VARCHAR,
  same_as_permanent BOOLEAN, bank_name VARCHAR, branch_name VARCHAR, account_number VARCHAR, ifsc_code VARCHAR, bank_document VARCHAR,
  reporting_rm VARCHAR, executive_name VARCHAR, district_of_posting VARCHAR, block_of_posting VARCHAR,
  experience_status VARCHAR, department VARCHAR, designation_id INT, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  emp_code VARCHAR, full_name VARCHAR, date_of_birth DATE, gender VARCHAR, mobile_number VARCHAR, email VARCHAR, nationality VARCHAR,
  company_name VARCHAR, designation VARCHAR) AS $$
BEGIN
  RETURN QUERY
  SELECT ui.user_info_id, ui.user_id, ui.company_id, ui.last_login_at, ui.title,
    ui.photo_available, ui.photo_path, ui.payroll_group, ui.emergency_phone,
    ui.father_name, ui.mother_name, ui.spouse_name, ui.aadhar_number, ui.pan_number,
    ui.perm_address, ui.perm_city, ui.perm_state, ui.perm_country, ui.perm_pincode,
    ui.curr_address, ui.curr_city, ui.curr_state, ui.curr_country, ui.curr_pincode,
    ui.same_as_permanent, ui.bank_name, ui.branch_name, ui.account_number, ui.ifsc_code, ui.bank_document,
    ui.reporting_rm, ui.executive_name, ui.district_of_posting, ui.block_of_posting,
    ui.experience_status, ui.department, ui.designation_id, ui.is_active, ui.created_at, ui.updated_at,
    u.emp_code, u.full_name, u.date_of_birth, u.gender, u.mobile_number, u.email, u.nationality,
    c.company_name, d.designation
  FROM user_information ui
  JOIN user_tbl u ON u.user_id = ui.user_id
  LEFT JOIN company c ON c.company_id = ui.company_id
  LEFT JOIN designation d ON d.designation_id = ui.designation_id
  WHERE ui.is_active = 1
  ORDER BY ui.created_at DESC;
END;
$$ LANGUAGE plpgsql;