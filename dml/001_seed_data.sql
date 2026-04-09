-- ============================================================================
-- DML 001: Initial seed data
-- Run AFTER all DDL migrations are applied.
-- Safe to re-run — uses ON CONFLICT DO NOTHING.
-- ============================================================================
SET search_path TO myactivity;

-- ── Company ──────────────────────────────────────────────────────────────────
INSERT INTO company (company_name, email, website, is_active, created_at, updated_at)
VALUES ('MyActivity', 'admin@myactivity.in', 'https://myactivity.in', 1, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- ── Project ──────────────────────────────────────────────────────────────────
INSERT INTO project (project_name, project_code, is_active, created_at, updated_at)
VALUES ('MyActivity Project', 'MA-001', 1, NOW(), NOW())
ON CONFLICT (project_code) DO NOTHING;

-- ── Designations ─────────────────────────────────────────────────────────────
INSERT INTO designation (designation, project_id, is_active, created_at, updated_at)
SELECT d.designation, p.project_id, 1, NOW(), NOW()
FROM (VALUES
  ('Field Officer'),
  ('Block Coordinator'),
  ('District Manager'),
  ('Project Manager'),
  ('Data Entry Operator')
) AS d(designation)
CROSS JOIN project p
WHERE p.project_code = 'MA-001'
ON CONFLICT (designation) DO NOTHING;

-- ── Demo User (password: Pass@123) ───────────────────────────────────────────
-- Note: password hash is bcrypt of 'Pass@123' with 10 rounds
INSERT INTO user_tbl (emp_code, full_name, date_of_birth, gender, mobile_number, email, nationality, is_active, created_at, updated_at)
VALUES ('EMP-001', 'John Doe', '1990-01-01', 'Male', '9999999999', 'john@myactivity.in', 'Indian', 1, NOW(), NOW())
ON CONFLICT (emp_code) DO NOTHING;

-- user_information (linked to user + company, with password)
-- password hash is bcrypt of 'Pass@123' with 10 rounds
INSERT INTO user_information (user_id, company_id, password, is_active, created_at, updated_at)
SELECT u.user_id, c.company_id,
       '$2a$10$Z2MEZi4YXR9txLp7aja1NOWFP8T17zbvyllq8kcfIgLSBWEsKRwNi',
       1, NOW(), NOW()
FROM user_tbl u, company c
WHERE u.emp_code = 'EMP-001' AND c.company_name = 'MyActivity'
ON CONFLICT (user_id) DO NOTHING;
