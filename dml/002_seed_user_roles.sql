-- ============================================================================
-- DML 002: Assign role_ids to existing users
-- ============================================================================
SET search_path TO myactivity;

-- Assign roles to existing users (customize user_ids as needed)
UPDATE user_information SET role_id = 1 WHERE user_id = 1; -- Operations Manager
UPDATE user_information SET role_id = 2 WHERE user_id = 2; -- Regional Manager

-- Note: Field Executive (role_id=10) is now the DEFAULT for new users
-- Any existing users without a role will also be set to Field Executive
UPDATE user_information SET role_id = 10 WHERE role_id IS NULL;

-- Migration tracking
INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.8', '002_seed_user_roles.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
