-- ============================================================================
-- Function: fn_register_login
-- Description: Sets (or resets) the password on user_information for a user
--              and associates them with a company. Used during initial
--              registration or password setup.
-- Parameters: p_user_id          INT     - the user identifier
--             p_hashed_password  VARCHAR - bcrypt-hashed password
--             p_company_id       INT     - company identifier
-- Returns: The updated user_id and company_id
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_register_login(p_user_id INT, p_hashed_password VARCHAR, p_company_id INT)
RETURNS TABLE(user_id INT, company_id INT) AS $$
BEGIN
    RETURN QUERY
    UPDATE user_information
    SET password   = p_hashed_password,
        company_id = p_company_id,
        updated_at = NOW()
    WHERE user_information.user_id = p_user_id
    RETURNING user_information.user_id, user_information.company_id;
END;
$$ LANGUAGE plpgsql;