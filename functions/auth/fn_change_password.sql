-- ============================================================================
-- Function: fn_get_login_for_password
-- Description: Finds a user record for password change by mobile number
--              and company. Returns the current hashed password so the
--              caller can verify the old password before updating.
-- Parameters: p_mobile     VARCHAR - user mobile number
--             p_company_id INT     - company identifier
-- Returns: user_info_id and current password hash
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_get_login_for_password(p_mobile VARCHAR, p_company_id INT)
RETURNS TABLE(user_info_id INT, password VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT ui.user_info_id, ui.password
    FROM user_information ui
    JOIN user_tbl u ON u.user_id = ui.user_id
    WHERE u.mobile_number = p_mobile
      AND ui.company_id = p_company_id
      AND ui.is_active = 1;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- Function: fn_update_password
-- Description: Updates the password on user_information for a given user.
-- Parameters: p_user_info_id    INT     - the user_information record to update
--             p_hashed_password VARCHAR - the new bcrypt-hashed password
-- Returns: VOID
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_update_password(p_user_info_id INT, p_hashed_password VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE user_information
    SET password   = p_hashed_password,
        updated_at = NOW()
    WHERE user_info_id = p_user_info_id;
END;
$$ LANGUAGE plpgsql;