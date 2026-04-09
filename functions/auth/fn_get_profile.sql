-- ============================================================================
-- Function: fn_get_profile
-- Description: Retrieves the full user profile for authentication context.
--              Joins user_information, user_tbl, and company tables.
-- Parameters: p_user_id INT - the user identifier
-- Returns: User profile record including company name
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_get_profile(p_user_id INT)
RETURNS TABLE(
    user_info_id  INT,
    user_id       INT,
    company_id    INT,
    last_login_at TIMESTAMPTZ,
    is_active     SMALLINT,
    emp_code      VARCHAR,
    full_name     VARCHAR,
    mobile_number VARCHAR,
    email         VARCHAR,
    company_name  VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT ui.user_info_id, ui.user_id, ui.company_id, ui.last_login_at, ui.is_active,
           u.emp_code, u.full_name, u.mobile_number, u.email, c.company_name
    FROM user_information ui
    JOIN user_tbl u ON u.user_id = ui.user_id
    LEFT JOIN company c ON c.company_id = ui.company_id
    WHERE ui.user_id = p_user_id
      AND ui.is_active = 1;
END;
$$ LANGUAGE plpgsql;