-- ============================================================================
-- DML 002: Seed user_type roles + web_login accounts
-- Run AFTER DDL 007 & 008.  Safe to re-run — uses ON CONFLICT DO NOTHING.
-- ============================================================================
SET search_path TO public;

-- ── User Types (from the role-permission matrix) ────────────────────────────
INSERT INTO user_type (type_name, type_code, level) VALUES
  ('Operations Manager',  'OPS_MGR',       5),
  ('Regional Manager',    'REG_MGR',       4),
  ('Office Executive',    'OFFICE_EXEC',   3),
  ('Procurement',         'PROCUREMENT',   3),
  ('Store Executive',     'STORE_EXEC',    2),
  ('Quality / Training',  'QUALITY',       3),
  ('HR',                  'HR',            4),
  ('Accounts',            'ACCOUNTS',      3),
  ('TA Team',             'TA_TEAM',       3)
ON CONFLICT (type_code) DO NOTHING;

-- ── Shared Web Logins (non-RM roles — one login per role) ───────────────────
-- password: Pass@123  →  bcrypt hash
-- username = type_code (e.g. 'HR', 'ACCOUNTS', 'TA_TEAM')

INSERT INTO web_login (username, password, user_type_id, user_id, company_id, is_active, created_at, updated_at)
SELECT
    ut.type_code,
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    ut.user_type_id,
    NULL,
    c.company_id,
    1, NOW(), NOW()
FROM user_type ut, company c
WHERE c.company_name = 'MyActivity'
  AND ut.type_code IN ('OPS_MGR','OFFICE_EXEC','PROCUREMENT','STORE_EXEC','QUALITY','HR','ACCOUNTS','TA_TEAM')
ON CONFLICT (username, company_id) DO NOTHING;

-- ── Demo RM Login (individual — linked to user EMP-001) ─────────────────────
-- username: john.doe  |  password: Pass@123

INSERT INTO web_login (username, password, user_type_id, user_id, company_id, is_active, created_at, updated_at)
SELECT
    'john.doe',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    ut.user_type_id,
    u.user_id,
    c.company_id,
    1, NOW(), NOW()
FROM user_tbl u, user_type ut, company c
WHERE u.emp_code     = 'EMP-001'
  AND ut.type_code   = 'REG_MGR'
  AND c.company_name = 'MyActivity'
ON CONFLICT (username, company_id) DO NOTHING;