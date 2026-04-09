-- ============================================================================
-- DDL 008: web_login (web portal authentication, separate from mobile user_login)
--
-- Two login modes:
--   • RM (individual)  → username = personal name (e.g. 'srikanth.r'), user_id linked
--   • Non-RM (shared)  → username = role code (e.g. 'HR', 'ACCOUNTS'), user_id NULL
-- ============================================================================
SET search_path TO public;

CREATE TABLE IF NOT EXISTS web_login (
    web_login_id  SERIAL PRIMARY KEY,
    username      VARCHAR(100) NOT NULL,                -- login name: 'srikanth.r' or 'HR'
    password      VARCHAR(255) NOT NULL,                -- bcrypt hashed
    user_type_id  INT          NOT NULL REFERENCES user_type(user_type_id),
    user_id       INT          REFERENCES user_tbl(user_id),  -- NULL for shared logins
    company_id    INT          REFERENCES company(company_id),
    last_login_at TIMESTAMPTZ,
    is_active     SMALLINT     NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_web_login_username_company UNIQUE (username, company_id)
);
CREATE INDEX IF NOT EXISTS idx_web_login_username  ON web_login(username);
CREATE INDEX IF NOT EXISTS idx_web_login_user_type ON web_login(user_type_id);
CREATE INDEX IF NOT EXISTS idx_web_login_active    ON web_login(is_active);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','008_web_login.sql') ON CONFLICT DO NOTHING;