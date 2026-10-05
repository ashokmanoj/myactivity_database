-- Seed data that used to live in ddl/033_add_superuser_role.sql (that file
-- had no schema in it at all — just this role row — so it's archived rather
-- than kept as an empty husk; see database/ddl/archive/README.md).
SET search_path TO myactivity;

INSERT INTO roles (role_id, role_name, description) VALUES
(12, 'Superuser', 'Full access to all pages and all approval actions across the system')
ON CONFLICT (role_name) DO UPDATE SET
    description = EXCLUDED.description,
    is_active   = 1;

-- Advance sequence past the new max
SELECT setval('roles_role_id_seq', 12, true);
