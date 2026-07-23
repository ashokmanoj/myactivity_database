-- 036_expense_tables.sql
-- Expense submissions from mobile + per-bill chat messages
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS myactivity.expense_tbl (
  expense_id        SERIAL PRIMARY KEY,
  user_id           INT          NOT NULL,
  company_id        INT          NOT NULL,
  project_id        INT,
  type              VARCHAR(20)  NOT NULL DEFAULT 'expense',   -- expense | advance
  purpose           VARCHAR(200),
  has_bill          BOOLEAN      NOT NULL DEFAULT false,
  amount            NUMERIC(12,2) NOT NULL DEFAULT 0,
  bill_date         DATE,
  remarks           TEXT,
  bill_image_path   VARCHAR(500),

  -- Verifier stage
  verifier_status   VARCHAR(20)  NOT NULL DEFAULT 'Pending',
  verifier_amount   NUMERIC(12,2),
  verifier_id       INT,
  verifier_comment  TEXT,
  verifier_at       TIMESTAMPTZ,

  -- Regional Manager stage
  rm_status         VARCHAR(20)  NOT NULL DEFAULT 'Pending',
  rm_amount         NUMERIC(12,2),
  rm_id             INT,
  rm_comment        TEXT,
  rm_at             TIMESTAMPTZ,

  -- TA Committee stage
  ta_status         VARCHAR(20)  NOT NULL DEFAULT 'Pending',
  ta_amount         NUMERIC(12,2),
  ta_id             INT,
  ta_comment        TEXT,
  ta_at             TIMESTAMPTZ,

  -- Accounts stage
  accounts_status   VARCHAR(20)  NOT NULL DEFAULT 'Pending',
  accounts_amount   NUMERIC(12,2),
  accounts_id       INT,
  accounts_comment  TEXT,
  accounts_at       TIMESTAMPTZ,

  payment_status    VARCHAR(20)  NOT NULL DEFAULT 'Pending',   -- Pending | Paid
  overall_status    VARCHAR(20)  NOT NULL DEFAULT 'Pending',   -- Pending | Approved | Rejected | Forwarded

  created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS myactivity.expense_messages (
  message_id        SERIAL PRIMARY KEY,
  expense_id        INT          NOT NULL REFERENCES myactivity.expense_tbl(expense_id) ON DELETE CASCADE,
  sender_user_id    INT,
  sender_name       VARCHAR(200),
  sender_role       VARCHAR(50),
  to_role           VARCHAR(50),
  message           TEXT         NOT NULL DEFAULT '',
  attachment_path   VARCHAR(500),
  created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_expense_user      ON myactivity.expense_tbl(user_id);
CREATE INDEX IF NOT EXISTS idx_expense_company   ON myactivity.expense_tbl(company_id);
CREATE INDEX IF NOT EXISTS idx_expense_status    ON myactivity.expense_tbl(overall_status);
CREATE INDEX IF NOT EXISTS idx_expense_msg_exp   ON myactivity.expense_messages(expense_id);
