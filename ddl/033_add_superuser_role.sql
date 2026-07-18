-- ============================================================================
-- DDL 033: Add Superuser role
-- ============================================================================
SET search_path TO myactivity;

INSERT INTO roles (role_id, role_name, description) VALUES
(12, 'Superuser', 'Full access to all pages and all approval actions across the system')
ON CONFLICT (role_name) DO UPDATE SET
    description = EXCLUDED.description,
    is_active   = 1;

-- Advance sequence past the new max
SELECT setval('roles_role_id_seq', 12, true);

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.33', '033_add_superuser_role.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
