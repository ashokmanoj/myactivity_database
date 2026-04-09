-- ============================================================================
-- Function: fn_update_last_login
-- Description: Updates the last_login_at timestamp on user_information
--              to the current time.
-- Parameters: p_user_info_id INT - the user_information record to update
-- Returns: VOID
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_update_last_login(p_user_info_id INT)
RETURNS VOID AS $$
BEGIN
    UPDATE user_information
    SET last_login_at = NOW()
    WHERE user_info_id = p_user_info_id;
END;
$$ LANGUAGE plpgsql;