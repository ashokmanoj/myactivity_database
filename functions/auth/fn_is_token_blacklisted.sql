-- ============================================================================
-- Function: fn_is_token_blacklisted
-- Description: Checks whether a given JWT token has been blacklisted.
-- Parameters: p_token TEXT - the JWT token string to check
-- Returns: BOOLEAN - TRUE if the token is blacklisted, FALSE otherwise
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_is_token_blacklisted(p_token TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS(SELECT 1 FROM token_blacklist WHERE token = p_token);
END;
$$ LANGUAGE plpgsql;