-- ============================================================================
-- DDL 007: Create roles table and link to user_information
-- ============================================================================
SET search_path TO myactivity;

-- 1. Create roles table
CREATE TABLE IF NOT EXISTS roles (
    role_id     SERIAL PRIMARY KEY,
    role_name   VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active   SMALLINT NOT NULL DEFAULT 1,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Base role rows moved to database/seed/007_roles_table.sql — DDL files are
-- schema-only now (see database/seed/README.md).

-- 3. Add role_id to user_information (drop old role column if exists)
ALTER TABLE user_information
DROP COLUMN IF EXISTS role;

ALTER TABLE user_information
ADD COLUMN IF NOT EXISTS role_id INT REFERENCES roles(role_id) ON DELETE SET NULL;

-- 4. Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_info_role_id ON user_information(role_id);
