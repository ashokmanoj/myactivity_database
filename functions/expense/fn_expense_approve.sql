SET search_path TO myactivity;

-- p_action: 'Approved' | 'Rejected'
-- p_role:   'verifier' | 'rm' | 'ta' | 'accounts'
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
    UPDATE myactivity.expense_tbl SET
      verifier_status  = p_action,
      verifier_amount  = p_amount,
      verifier_id      = p_approver_id,
      verifier_comment = p_comment,
      verifier_at      = NOW(),
      updated_at       = NOW()
    WHERE expense_id = p_expense_id;

  ELSIF p_role = 'rm' THEN
    UPDATE myactivity.expense_tbl SET
      rm_status  = p_action,
      rm_amount  = p_amount,
      rm_id      = p_approver_id,
      rm_comment = p_comment,
      rm_at      = NOW(),
      updated_at = NOW()
    WHERE expense_id = p_expense_id;

  ELSIF p_role = 'ta' THEN
    UPDATE myactivity.expense_tbl SET
      ta_status  = p_action,
      ta_amount  = p_amount,
      ta_id      = p_approver_id,
      ta_comment = p_comment,
      ta_at      = NOW(),
      updated_at = NOW()
    WHERE expense_id = p_expense_id;

  ELSIF p_role = 'accounts' THEN
    UPDATE myactivity.expense_tbl SET
      accounts_status  = p_action,
      accounts_amount  = p_amount,
      accounts_id      = p_approver_id,
      accounts_comment = p_comment,
      accounts_at      = NOW(),
      payment_status   = CASE WHEN p_action = 'Approved' THEN 'Pending Payment' ELSE 'Pending' END,
      updated_at       = NOW()
    WHERE expense_id = p_expense_id;
  END IF;

  -- Update overall_status: Rejected if any stage rejected, Approved if accounts approved
  UPDATE myactivity.expense_tbl SET
    overall_status = CASE
      WHEN p_action = 'Rejected'                   THEN 'Rejected'
      WHEN p_role   = 'accounts' AND p_action = 'Approved' THEN 'Approved'
      ELSE overall_status
    END
  WHERE expense_id = p_expense_id;
END;
$$ LANGUAGE plpgsql;
