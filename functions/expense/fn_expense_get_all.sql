SET search_path TO myactivity;

DROP FUNCTION IF EXISTS fn_expense_get_all(INT);

CREATE OR REPLACE FUNCTION fn_expense_get_all(p_company_id INT DEFAULT NULL)
RETURNS TABLE(
  expense_id       INT,
  user_id          INT,
  company_id       INT,
  project_id       INT,
  type             VARCHAR,
  purpose          VARCHAR,
  has_bill         BOOLEAN,
  amount           NUMERIC,
  bill_date        TEXT,
  expense_date     TEXT,
  payment_method   VARCHAR,
  remarks          TEXT,
  bill_image_path  VARCHAR,
  verifier_status  VARCHAR, verifier_amount NUMERIC, verifier_comment TEXT, verifier_at TIMESTAMPTZ,
  rm_status        VARCHAR, rm_amount       NUMERIC, rm_comment       TEXT, rm_at       TIMESTAMPTZ,
  ta_status        VARCHAR, ta_amount       NUMERIC, ta_comment       TEXT, ta_at       TIMESTAMPTZ,
  accounts_status  VARCHAR, accounts_amount NUMERIC, accounts_comment TEXT, accounts_at TIMESTAMPTZ,
  payment_status   VARCHAR,
  overall_status   VARCHAR,
  created_at       TIMESTAMPTZ,
  full_name        TEXT,
  emp_code         VARCHAR,
  mobile_number    VARCHAR,
  project_name     VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.expense_id, e.user_id, e.company_id, e.project_id,
    e.type::VARCHAR, e.purpose::VARCHAR, e.has_bill,
    e.amount,
    TO_CHAR(e.bill_date,    'YYYY-MM-DD'),
    TO_CHAR(e.expense_date, 'YYYY-MM-DD'),
    e.payment_method::VARCHAR,
    e.remarks, e.bill_image_path::VARCHAR,
    e.verifier_status::VARCHAR, e.verifier_amount, e.verifier_comment, e.verifier_at,
    e.rm_status::VARCHAR,       e.rm_amount,       e.rm_comment,       e.rm_at,
    e.ta_status::VARCHAR,       e.ta_amount,       e.ta_comment,       e.ta_at,
    e.accounts_status::VARCHAR, e.accounts_amount, e.accounts_comment, e.accounts_at,
    e.payment_status::VARCHAR, e.overall_status::VARCHAR, e.created_at,
    COALESCE(u.full_name, 'User #' || e.user_id::text),
    u.emp_code::VARCHAR, u.mobile_number::VARCHAR,
    p.project_name::VARCHAR
  FROM myactivity.expense_tbl e
  LEFT JOIN myactivity.user_tbl u ON u.user_id = e.user_id
  LEFT JOIN myactivity.project p ON p.project_id = e.project_id
  WHERE (p_company_id IS NULL OR e.company_id = p_company_id)
  ORDER BY e.created_at DESC;
END;
$$ LANGUAGE plpgsql;
