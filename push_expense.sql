-- ============================================================================
-- EXPENSE DEPLOYMENT SCRIPT — run this once to deploy the full expense feature
-- Safe to re-run (IF NOT EXISTS / CREATE OR REPLACE / ON CONFLICT DO NOTHING)
-- ============================================================================

SET search_path TO myactivity;

-- ============================================================================
-- 1. EXPENSE TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS expense_tbl (
  expense_id        SERIAL PRIMARY KEY,
  user_id           INT           NOT NULL,
  company_id        INT           NOT NULL,
  project_id        INT,
  type              VARCHAR(20)   NOT NULL DEFAULT 'expense',
  purpose           VARCHAR(200),
  has_bill          BOOLEAN       NOT NULL DEFAULT false,
  amount            NUMERIC(12,2) NOT NULL DEFAULT 0,
  bill_date         DATE,
  remarks           TEXT,
  bill_image_path   VARCHAR(500),
  verifier_status   VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  verifier_amount   NUMERIC(12,2),
  verifier_id       INT,
  verifier_comment  TEXT,
  verifier_at       TIMESTAMPTZ,
  rm_status         VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  rm_amount         NUMERIC(12,2),
  rm_id             INT,
  rm_comment        TEXT,
  rm_at             TIMESTAMPTZ,
  ta_status         VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  ta_amount         NUMERIC(12,2),
  ta_id             INT,
  ta_comment        TEXT,
  ta_at             TIMESTAMPTZ,
  accounts_status   VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  accounts_amount   NUMERIC(12,2),
  accounts_id       INT,
  accounts_comment  TEXT,
  accounts_at       TIMESTAMPTZ,
  payment_status    VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  overall_status    VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS expense_messages (
  message_id        SERIAL PRIMARY KEY,
  expense_id        INT           NOT NULL REFERENCES expense_tbl(expense_id) ON DELETE CASCADE,
  sender_user_id    INT,
  sender_name       VARCHAR(200),
  sender_role       VARCHAR(50),
  to_role           VARCHAR(50),
  message           TEXT          NOT NULL DEFAULT '',
  attachment_path   VARCHAR(500),
  created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS expense_purpose_tbl (
  purpose_id  SERIAL       PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  applies_to  VARCHAR(10)  NOT NULL DEFAULT 'both',  -- 'expense' | 'advance' | 'both'
  is_active   BOOLEAN      NOT NULL DEFAULT true,
  company_id  INT,                                   -- NULL = system-wide
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_expense_purpose_name
  ON expense_purpose_tbl(LOWER(name), COALESCE(company_id, 0));

-- ============================================================================
-- 2. INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_expense_user    ON expense_tbl(user_id);
CREATE INDEX IF NOT EXISTS idx_expense_company ON expense_tbl(company_id);
CREATE INDEX IF NOT EXISTS idx_expense_status  ON expense_tbl(overall_status);
CREATE INDEX IF NOT EXISTS idx_expense_msg_exp ON expense_messages(expense_id);

-- ============================================================================
-- 3. SEED — default purposes
-- ============================================================================

INSERT INTO expense_purpose_tbl (name, applies_to) VALUES
  ('Food',   'both'),
  ('Stay',   'both'),
  ('Hotel',  'both'),
  ('Bus',    'both'),
  ('Auto',   'both'),
  ('TA',     'both'),
  ('Others', 'both')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 4. FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_expense_submit(
  p_user_id         INT,
  p_company_id      INT,
  p_project_id      INT,
  p_type            VARCHAR,
  p_purpose         VARCHAR,
  p_has_bill        BOOLEAN,
  p_amount          NUMERIC,
  p_bill_date       DATE,
  p_remarks         TEXT,
  p_bill_image_path VARCHAR
)
RETURNS TABLE(expense_id INT) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO expense_tbl(
    user_id, company_id, project_id, type, purpose,
    has_bill, amount, bill_date, remarks, bill_image_path
  ) VALUES (
    p_user_id, p_company_id, p_project_id,
    COALESCE(p_type, 'expense'), p_purpose,
    COALESCE(p_has_bill, false), COALESCE(p_amount, 0),
    p_bill_date, p_remarks, p_bill_image_path
  )
  RETURNING expense_tbl.expense_id;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_expense_get_all(p_company_id INT DEFAULT NULL)
RETURNS TABLE(
  expense_id       INT,  user_id        INT,  company_id      INT,  project_id     INT,
  type             VARCHAR, purpose     VARCHAR, has_bill       BOOLEAN,
  amount           NUMERIC, bill_date   DATE,    remarks        TEXT,  bill_image_path VARCHAR,
  verifier_status  VARCHAR, verifier_amount NUMERIC, verifier_comment TEXT, verifier_at TIMESTAMPTZ,
  rm_status        VARCHAR, rm_amount       NUMERIC, rm_comment       TEXT, rm_at       TIMESTAMPTZ,
  ta_status        VARCHAR, ta_amount       NUMERIC, ta_comment       TEXT, ta_at       TIMESTAMPTZ,
  accounts_status  VARCHAR, accounts_amount NUMERIC, accounts_comment TEXT, accounts_at TIMESTAMPTZ,
  payment_status   VARCHAR, overall_status  VARCHAR, created_at       TIMESTAMPTZ,
  full_name        VARCHAR, emp_code        VARCHAR, mobile_number    VARCHAR, project_name VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.expense_id, e.user_id, e.company_id, e.project_id,
    e.type, e.purpose, e.has_bill,
    e.amount, e.bill_date, e.remarks, e.bill_image_path,
    e.verifier_status,  e.verifier_amount,  e.verifier_comment,  e.verifier_at,
    e.rm_status,        e.rm_amount,        e.rm_comment,        e.rm_at,
    e.ta_status,        e.ta_amount,        e.ta_comment,        e.ta_at,
    e.accounts_status,  e.accounts_amount,  e.accounts_comment,  e.accounts_at,
    e.payment_status, e.overall_status, e.created_at,
    u.full_name, u.emp_code, u.mobile_number,
    p.project_name
  FROM expense_tbl e
  JOIN user_tbl u ON u.user_id = e.user_id
  LEFT JOIN project p ON p.project_id = e.project_id
  WHERE (p_company_id IS NULL OR e.company_id = p_company_id)
  ORDER BY e.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_expense_get_by_user(p_user_id INT)
RETURNS TABLE(
  expense_id       INT,  user_id        INT,  company_id      INT,  project_id     INT,
  type             VARCHAR, purpose     VARCHAR, has_bill       BOOLEAN,
  amount           NUMERIC, bill_date   DATE,    remarks        TEXT,  bill_image_path VARCHAR,
  verifier_status  VARCHAR, verifier_amount NUMERIC, verifier_comment TEXT, verifier_at TIMESTAMPTZ,
  rm_status        VARCHAR, rm_amount       NUMERIC, rm_comment       TEXT, rm_at       TIMESTAMPTZ,
  ta_status        VARCHAR, ta_amount       NUMERIC, ta_comment       TEXT, ta_at       TIMESTAMPTZ,
  accounts_status  VARCHAR, accounts_amount NUMERIC, accounts_comment TEXT, accounts_at TIMESTAMPTZ,
  payment_status   VARCHAR, overall_status  VARCHAR, created_at       TIMESTAMPTZ,
  full_name        VARCHAR, emp_code        VARCHAR, mobile_number    VARCHAR, project_name VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.expense_id, e.user_id, e.company_id, e.project_id,
    e.type, e.purpose, e.has_bill,
    e.amount, e.bill_date, e.remarks, e.bill_image_path,
    e.verifier_status,  e.verifier_amount,  e.verifier_comment,  e.verifier_at,
    e.rm_status,        e.rm_amount,        e.rm_comment,        e.rm_at,
    e.ta_status,        e.ta_amount,        e.ta_comment,        e.ta_at,
    e.accounts_status,  e.accounts_amount,  e.accounts_comment,  e.accounts_at,
    e.payment_status, e.overall_status, e.created_at,
    u.full_name, u.emp_code, u.mobile_number,
    p.project_name
  FROM expense_tbl e
  JOIN user_tbl u ON u.user_id = e.user_id
  LEFT JOIN project p ON p.project_id = e.project_id
  WHERE e.user_id = p_user_id
  ORDER BY e.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_expense_approve(
  p_expense_id  INT,
  p_role        VARCHAR,
  p_action      VARCHAR,
  p_amount      NUMERIC,
  p_approver_id INT,
  p_comment     TEXT
)
RETURNS VOID AS $$
BEGIN
  IF p_role = 'verifier' THEN
    UPDATE expense_tbl SET
      verifier_status  = p_action,  verifier_amount  = p_amount,
      verifier_id      = p_approver_id, verifier_comment = p_comment,
      verifier_at      = NOW(), updated_at = NOW()
    WHERE expense_id = p_expense_id;
  ELSIF p_role = 'rm' THEN
    UPDATE expense_tbl SET
      rm_status  = p_action,  rm_amount  = p_amount,
      rm_id      = p_approver_id, rm_comment = p_comment,
      rm_at      = NOW(), updated_at = NOW()
    WHERE expense_id = p_expense_id;
  ELSIF p_role = 'ta' THEN
    UPDATE expense_tbl SET
      ta_status  = p_action,  ta_amount  = p_amount,
      ta_id      = p_approver_id, ta_comment = p_comment,
      ta_at      = NOW(), updated_at = NOW()
    WHERE expense_id = p_expense_id;
  ELSIF p_role = 'accounts' THEN
    UPDATE expense_tbl SET
      accounts_status  = p_action,  accounts_amount  = p_amount,
      accounts_id      = p_approver_id, accounts_comment = p_comment,
      accounts_at      = NOW(),
      payment_status   = CASE WHEN p_action = 'Approved' THEN 'Pending Payment' ELSE 'Pending' END,
      updated_at       = NOW()
    WHERE expense_id = p_expense_id;
  END IF;

  UPDATE expense_tbl SET
    overall_status = CASE
      WHEN p_action = 'Rejected'                           THEN 'Rejected'
      WHEN p_role = 'accounts' AND p_action = 'Approved'  THEN 'Approved'
      ELSE overall_status
    END
  WHERE expense_id = p_expense_id;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_expense_forward(
  p_expense_id     INT,
  p_from_role      VARCHAR,
  p_to_role        VARCHAR,
  p_sender_user_id INT,
  p_sender_name    VARCHAR,
  p_message        TEXT
)
RETURNS VOID AS $$
BEGIN
  IF p_from_role = 'verifier' THEN
    UPDATE expense_tbl SET verifier_status = 'Forwarded', updated_at = NOW()
    WHERE expense_id = p_expense_id;
  ELSIF p_from_role = 'rm' THEN
    UPDATE expense_tbl SET rm_status = 'Forwarded', updated_at = NOW()
    WHERE expense_id = p_expense_id;
  ELSIF p_from_role = 'ta' THEN
    UPDATE expense_tbl SET ta_status = 'Forwarded', updated_at = NOW()
    WHERE expense_id = p_expense_id;
  END IF;

  INSERT INTO expense_messages(expense_id, sender_user_id, sender_name, sender_role, to_role, message)
  VALUES (p_expense_id, p_sender_user_id, p_sender_name, p_from_role, p_to_role, p_message);
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_expense_messages_get(p_expense_id INT)
RETURNS TABLE(
  message_id      INT,
  expense_id      INT,
  sender_user_id  INT,
  sender_name     VARCHAR,
  sender_role     VARCHAR,
  to_role         VARCHAR,
  message         TEXT,
  attachment_path VARCHAR,
  created_at      TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT m.message_id, m.expense_id, m.sender_user_id,
         m.sender_name, m.sender_role, m.to_role,
         m.message, m.attachment_path, m.created_at
  FROM expense_messages m
  WHERE m.expense_id = p_expense_id
  ORDER BY m.created_at ASC;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_expense_message_create(
  p_expense_id      INT,
  p_sender_user_id  INT,
  p_sender_name     VARCHAR,
  p_sender_role     VARCHAR,
  p_to_role         VARCHAR,
  p_message         TEXT,
  p_attachment_path VARCHAR DEFAULT NULL
)
RETURNS TABLE(message_id INT) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO expense_messages(
    expense_id, sender_user_id, sender_name,
    sender_role, to_role, message, attachment_path
  ) VALUES (
    p_expense_id, p_sender_user_id, p_sender_name,
    p_sender_role, p_to_role, p_message, p_attachment_path
  )
  RETURNING expense_messages.message_id;
END;
$$ LANGUAGE plpgsql;

-- --------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_expense_purposes_get(
  p_company_id INT     DEFAULT NULL,
  p_applies_to VARCHAR DEFAULT NULL
)
RETURNS TABLE(
  purpose_id INT,
  name       VARCHAR,
  applies_to VARCHAR,
  is_active  BOOLEAN,
  company_id INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT p.purpose_id, p.name, p.applies_to, p.is_active, p.company_id
  FROM expense_purpose_tbl p
  WHERE p.is_active = true
    AND (p_applies_to IS NULL OR p.applies_to IN (p_applies_to, 'both'))
    AND (p.company_id IS NULL OR p.company_id = p_company_id)
  ORDER BY p.company_id NULLS FIRST, p.purpose_id;
END;
$$ LANGUAGE plpgsql;
