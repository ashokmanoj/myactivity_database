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

-- 2. Insert the 9 roles
INSERT INTO roles (role_id, role_name, description) VALUES
(1, 'Regional Manager Head', 'Full access to all operational features'),
(2, 'Regional Manager', 'Regional oversight and management access'),
(3, 'Office Executive', 'Office-level administrative access'),
(4, 'Procurement', 'Procurement and purchasing access'),
(5, 'Store Executive', 'Inventory and store management access'),
(6, 'Quality/Training', 'Quality control and training management'),
(7, 'HR', 'Human Resources management access'),
(8, 'Accounts', 'Financial and accounting access'),
(9, 'TA Team', 'Technical Assistant team access'),
(10, 'Field Executive', 'Field executive access')
ON CONFLICT (role_name) DO UPDATE SET
    description = EXCLUDED.description,
    is_active = EXCLUDED.is_active;

-- Reset sequence
SELECT setval('roles_role_id_seq', 9, true);

-- 3. Add role_id to user_information (drop old role column if exists)
ALTER TABLE user_information
DROP COLUMN IF EXISTS role;

ALTER TABLE user_information
ADD COLUMN IF NOT EXISTS role_id INT REFERENCES roles(role_id) ON DELETE SET NULL;

-- 4. Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_info_role_id ON user_information(role_id);

-- 5. Migration tracking
INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.7', '007_roles_table.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
