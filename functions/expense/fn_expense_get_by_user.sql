SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_expense_get_by_user(p_user_id INT)
RETURNS TABLE(
  expense_id       INT,
  user_id          INT,
  company_id       INT,
  project_id       INT,
  type             VARCHAR,
  purpose          VARCHAR,
  has_bill         BOOLEAN,
  amount           NUMERIC,
  bill_date        DATE,
  remarks          TEXT,
  bill_image_path  VARCHAR,
  verifier_status  VARCHAR, verifier_amount NUMERIC, verifier_comment TEXT, verifier_at TIMESTAMPTZ,
  rm_status        VARCHAR, rm_amount       NUMERIC, rm_comment       TEXT, rm_at       TIMESTAMPTZ,
  ta_status        VARCHAR, ta_amount       NUMERIC, ta_comment       TEXT, ta_at       TIMESTAMPTZ,
  accounts_status  VARCHAR, accounts_amount NUMERIC, accounts_comment TEXT, accounts_at TIMESTAMPTZ,
  payment_status   VARCHAR,
  overall_status   VARCHAR,
  created_at       TIMESTAMPTZ,
  full_name        VARCHAR,
  emp_code         VARCHAR,
  mobile_number    VARCHAR,
  project_name     VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    e.expense_id, e.user_id, e.company_id, e.project_id,
    e.type, e.purpose, e.has_bill,
    e.amount, e.bill_date, e.remarks, e.bill_image_path,
    e.verifier_status, e.verifier_amount, e.verifier_comment, e.verifier_at,
    e.rm_status,       e.rm_amount,       e.rm_comment,       e.rm_at,
    e.ta_status,       e.ta_amount,       e.ta_comment,       e.ta_at,
    e.accounts_status, e.accounts_amount, e.accounts_comment, e.accounts_at,
    e.payment_status, e.overall_status, e.created_at,
    u.full_name, u.emp_code, u.mobile_number,
    p.project_name
  FROM myactivity.expense_tbl e
  JOIN myactivity.user_tbl u ON u.user_id = e.user_id
  LEFT JOIN myactivity.project p ON p.project_id = e.project_id
  WHERE e.user_id = p_user_id
  ORDER BY e.created_at DESC;
END;
$$ LANGUAGE plpgsql;
