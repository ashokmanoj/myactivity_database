-- ============================================================================
-- DDL 006: token_blacklist (for JWT logout / revocation)
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS token_blacklist (
    id          SERIAL PRIMARY KEY,
    token       TEXT         NOT NULL,
    user_id     INT          NOT NULL REFERENCES user_tbl(user_id),
    expires_at  TIMESTAMPTZ  NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_blacklist_token ON token_blacklist(token);
CREATE INDEX IF NOT EXISTS idx_blacklist_expires ON token_blacklist(expires_at);
