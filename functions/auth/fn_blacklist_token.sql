-- ============================================================================
-- Function: fn_blacklist_token
-- Description: Inserts a JWT token into the token_blacklist table so it
--              can no longer be used for authentication.
-- Parameters: p_token   TEXT   - the JWT token string
--             p_user_id INT    - the user who owned the token
--             p_exp     BIGINT - Unix epoch expiry timestamp
-- Returns: VOID
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_blacklist_token(p_token TEXT, p_user_id INT, p_exp BIGINT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO token_blacklist (token, user_id, expires_at)
    VALUES (p_token, p_user_id, TO_TIMESTAMP(p_exp));
END;
$$ LANGUAGE plpgsql;