-- ============================================================================
-- Function: fn_login
-- Description: Finds a user for login by mobile number and company_id.
--              Joins user_information and user_tbl to return credentials
--              along with basic user details.
-- Parameters: p_mobile     VARCHAR - user mobile number
--             p_company_id INT     - company identifier
-- Returns: User record with credentials and profile info
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_login(p_mobile VARCHAR, p_company_id INT)
RETURNS TABLE(
    user_info_id  INT,
    user_id       INT,
    password      VARCHAR,
    company_id    INT,
    emp_code      VARCHAR,
    full_name     VARCHAR,
    mobile_number VARCHAR,
    email         VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT ui.user_info_id, ui.user_id, ui.password, ui.company_id,
           u.emp_code, u.full_name, u.mobile_number, u.email
    FROM user_information ui
    JOIN user_tbl u ON u.user_id = ui.user_id
    WHERE u.mobile_number = p_mobile
      AND ui.company_id = p_company_id
      AND ui.is_active = 1;
END;
$$ LANGUAGE plpgsql;