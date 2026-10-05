-- Seed data for ddl/007_roles_table.sql
SET search_path TO myactivity;

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
