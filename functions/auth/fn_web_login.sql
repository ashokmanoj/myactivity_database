-- ============================================================================
-- Function: fn_web_login
-- Description: Finds an active user for web login by email and company_id.
--              Joins user_information, user_tbl, company, and roles to return
--              all necessary authentication and session data.
-- Parameters: p_email      VARCHAR - user email address
--             p_company_id INT     - company identifier
-- Returns: User record with credentials, profile, company, and role info
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_web_login(p_email VARCHAR, p_company_id INT)
RETURNS TABLE(
    user_info_id  INT,
    user_id       INT,
    password      VARCHAR,
    company_id    INT,
    company_name  VARCHAR,
    emp_code      VARCHAR,
    full_name     VARCHAR,
    mobile_number VARCHAR,
    email         VARCHAR,
    role_id       INT,
    role_name     VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ui.user_info_id, 
        ui.user_id, 
        ui.password, 
        ui.company_id,
        c.company_name,
        u.emp_code, 
        u.full_name, 
        u.mobile_number, 
        u.email,
        r.role_id,
        r.role_name
    FROM user_information ui
    JOIN user_tbl u ON u.user_id = ui.user_id
    JOIN company c ON ui.company_id = c.company_id
    LEFT JOIN roles r ON ui.role_id = r.role_id
    WHERE LOWER(u.email) = LOWER(p_email)
      AND ui.company_id = p_company_id
      AND u.is_active = 1
      AND ui.is_active = 1;
END;
$$ LANGUAGE plpgsql;
