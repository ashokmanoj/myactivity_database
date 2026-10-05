-- ============================================================================
-- DDL 012: Add Verifier role
-- ============================================================================
SET search_path TO myactivity;

INSERT INTO roles (role_id, role_name, description) VALUES
(11, 'Verifier', 'Verifies and approves field executive distance claims')
ON CONFLICT (role_name) DO UPDATE SET
    description = EXCLUDED.description,
    is_active   = 1;

-- Advance sequence past the new max
SELECT setval('roles_role_id_seq', 11, true);
