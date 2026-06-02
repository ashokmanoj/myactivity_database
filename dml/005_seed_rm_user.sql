-- ============================================================================
-- DML 005: Seed Regional Manager user
-- Credentials: email = rm@myactivity.in / password = RM@1234
-- Role: Regional Manager (role_id = 2)
-- ============================================================================
SET search_path TO myactivity;

-- 1. Create base user record
INSERT INTO user_tbl (
    emp_code, full_name, date_of_birth, gender,
    mobile_number, email, nationality, is_active, created_at, updated_at
)
VALUES (
    'RM-001', 'Regional Manager', '1990-01-01', 'Male',
    '9000000020', 'rm@myactivity.in', 'Indian', 1, NOW(), NOW()
)
ON CONFLICT (emp_code) DO NOTHING;

-- 2. Create user_information with Regional Manager role (role_id = 2)
INSERT INTO user_information (
    user_id, company_id, role_id, is_active, created_at, updated_at,
    password
)
SELECT
    u.user_id,
    c.company_id,
    2,     -- Regional Manager
    1,
    NOW(),
    NOW(),
    '$2a$10$J8DtSTx2BY3xhLzebHSdC.f38wR6wEqCKNyq3jBbGZCv1PvxLm2/u'  -- RM@1234
FROM user_tbl u
CROSS JOIN company c
WHERE u.emp_code  = 'RM-001'
  AND c.company_id = 2   -- company "AND"
ON CONFLICT (user_id) DO NOTHING;
