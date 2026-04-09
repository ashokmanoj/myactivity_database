-- ============================================================================
-- DDL 007: user_type (role types for web login)
-- ============================================================================
SET search_path TO public;

CREATE TABLE IF NOT EXISTS user_type (
    user_type_id  SERIAL PRIMARY KEY,
    type_name     VARCHAR(50)  NOT NULL UNIQUE,     -- 'Operations Manager'
    type_code     VARCHAR(30)  NOT NULL UNIQUE,     -- 'OPS_MGR'
    level         INT          NOT NULL DEFAULT 1,  -- hierarchy: higher = more access
    is_active     SMALLINT     NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_user_type_code   ON user_type(type_code);
CREATE INDEX IF NOT EXISTS idx_user_type_active ON user_type(is_active);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','007_user_type.sql') ON CONFLICT DO NOTHIN