-- Function: fn_user_info_get_by_user_id  |  Domain: user_management
CREATE OR REPLACE FUNCTION fn_user_info_get_by_user_id(p_user_id INT)
RETURNS TABLE(
  user_info_id INT, user_id INT, company_id INT, title VARCHAR,
  marital_status VARCHAR, photo_available BOOLEAN, photo_path VARCHAR, payroll_group VARCHAR, emergency_phone VARCHAR,
  father_name VARCHAR, mother_name VARCHAR, spouse_name VARCHAR, aadhar_number VARCHAR, aadhar_document VARCHAR, 
  pan_number VARCHAR, pan_document VARCHAR,
  perm_address VARCHAR, perm_block VARCHAR, perm_district VARCHAR, perm_city VARCHAR, perm_state VARCHAR, perm_country VARCHAR, perm_pincode VARCHAR,
  curr_address VARCHAR, curr_block VARCHAR, curr_district VARCHAR, curr_city VARCHAR, curr_state VARCHAR, curr_country VARCHAR, curr_pincode VARCHAR,
  same_as_permanent BOOLEAN, bank_name VARCHAR, branch_name VARCHAR, account_number VARCHAR, ifsc_code VARCHAR, bank_document VARCHAR,
  reporting_rm VARCHAR, executive_name VARCHAR, district_of_posting VARCHAR, block_of_posting VARCHAR,
  experience_status VARCHAR, department VARCHAR, designation_id INT, date_of_joining DATE, date_of_exit DATE,
  qualification VARCHAR, college_name VARCHAR, year_of_passout VARCHAR, total_experience VARCHAR, 
  last_company_name VARCHAR, last_date_of_leaving DATE,
  is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  emp_code VARCHAR, full_name VARCHAR, date_of_birth DATE, gender VARCHAR, mobile_number VARCHAR, email VARCHAR, nationality VARCHAR,
  company_name VARCHAR, designation VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT ui.user_info_id, ui.user_id, ui.company_id, ui.title,
    ui.marital_status, ui.photo_available, ui.photo_path, ui.payroll_group, ui.emergency_phone,
    ui.father_name, ui.mother_name, ui.spouse_name, ui.aadhar_number, ui.aadhar_document,
    ui.pan_number, ui.pan_document,
    ui.perm_address, ui.perm_block, ui.perm_district, ui.perm_city, ui.perm_state, ui.perm_country, ui.perm_pincode,
    ui.curr_address, ui.curr_block, ui.curr_district, ui.curr_city, ui.curr_state, ui.curr_country, ui.curr_pincode,
    ui.same_as_permanent, ui.bank_name, ui.branch_name, ui.account_number, ui.ifsc_code, ui.bank_document,
    ui.reporting_rm, ui.executive_name, ui.district_of_posting, ui.block_of_posting,
    ui.experience_status, ui.department, ui.designation_id, ui.date_of_joining, ui.date_of_exit,
    ui.qualification, ui.college_name, ui.year_of_passout, ui.total_experience,
    ui.last_company_name, ui.last_date_of_leaving,
    ui.is_active, ui.created_at, ui.updated_at,
    u.emp_code, u.full_name, u.date_of_birth, u.gender, u.mobile_number, u.email, u.nationality,
    c.company_name, d.designation
  FROM user_information ui
  JOIN user_tbl u ON u.user_id = ui.user_id
  LEFT JOIN company c ON c.company_id = ui.company_id
  LEFT JOIN designation d ON d.designation_id = ui.designation_id
  WHERE ui.user_id = p_user_id AND ui.is_active = 1;
END;
$$ LANGUAGE plpgsql;