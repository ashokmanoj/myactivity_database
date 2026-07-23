-- DDL 037: Expense Purpose lookup table
SET search_path TO myactivity;

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

-- Seed system-wide default purposes
INSERT INTO expense_purpose_tbl (name, applies_to) VALUES
  ('Food',   'both'),
  ('Stay',   'both'),
  ('Hotel',  'both'),
  ('Bus',    'both'),
  ('Auto',   'both'),
  ('TA',     'both'),
  ('Others', 'both')
ON CONFLICT DO NOTHING;
