-- ============================================================================
-- DML 003: Seed demo Verifier user
-- Credentials: email = verifier@myactivity.in / password = Pass@123
-- Password is bcrypt hash of 'Pass@123' (10 rounds).
-- Run fn_register_login via API to replace with encrypted password if needed.
-- ============================================================================
SET search_path TO myactivity;

-- 1. Create the base user record
INSERT INTO user_tbl (
    emp_code, full_name, date_of_birth, gender,
    mobile_number, email, nationality, is_active, created_at, updated_at
)
VALUES (
    'VER-001', 'Verifier User', '1990-01-01', 'Male',
    '9000000011', 'verifier@myactivity.in', 'Indian', 1, NOW(), NOW()
)
ON CONFLICT (emp_code) DO NOTHING;

-- 2. Create user_information with role_id = 11 (Verifier)
INSERT INTO user_information (
    user_id, company_id, role_id, is_active, created_at, updated_at,
    password
)
SELECT
    u.user_id,
    c.company_id,
    11,   -- Verifier role
    1,
    NOW(),
    NOW(),
    -- bcrypt hash of 'Pass@123' (10 rounds) — update via API after first login
    '$2a$10$Z2MEZi4YXR9txLp7aja1NOWFP8T17zbvyllq8kcfIgLSBWEsKRwNi'
FROM user_tbl u
CROSS JOIN company c
WHERE u.emp_code = 'VER-001'
  AND c.company_name = 'MyActivity'
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.13', '003_seed_verifier_user.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
