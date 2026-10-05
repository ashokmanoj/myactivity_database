SET search_path TO myactivity;

-- p_action: 'Approved' | 'Rejected'
-- p_role:   'verifier' | 'rm' | 'ta' | 'accounts'
--
-- Amount cascades forward one stage at a time, same pattern as
-- fn_distance_approval_update: whatever a stage decides (p_amount, or the
-- previous stage's amount if this stage didn't change it) becomes the next
-- stage's starting amount, pre-seeding that stage's own column immediately
-- — not just a frontend default — so TA's figure is always "RM's amount
-- unless RM changed it," and so on back to the original submitted amount.
CREATE OR REPLACE FUNCTION fn_expense_approve(
  p_expense_id  INT,
  p_role        VARCHAR,
  p_action      VARCHAR,
  p_amount      NUMERIC,
  p_approver_id INT,
  p_comment     TEXT
)
RETURNS VOID AS $$
DECLARE
  v_current RECORD;
  v_amt     NUMERIC(12,2);
BEGIN
  SELECT e.amount, e.verifier_amount, e.rm_amount, e.ta_amount
  INTO v_current
  FROM myactivity.expense_tbl e WHERE e.expense_id = p_expense_id;

  IF p_role = 'verifier' THEN
    v_amt := COALESCE(p_amount, v_current.amount);
    UPDATE myactivity.expense_tbl SET
      verifier_status  = p_action,
      verifier_amount  = v_amt,
      rm_amount        = v_amt,
      verifier_id      = p_approver_id,
      verifier_comment = p_comment,
      verifier_at      = NOW(),
      updated_at       = NOW()
    WHERE expense_id = p_expense_id;

  ELSIF p_role = 'rm' THEN
    v_amt := COALESCE(p_amount, v_current.rm_amount, v_current.verifier_amount, v_current.amount);
    UPDATE myactivity.expense_tbl SET
      rm_status  = p_action,
      rm_amount  = v_amt,
      ta_amount  = v_amt,
      rm_id      = p_approver_id,
      rm_comment = p_comment,
      rm_at      = NOW(),
      updated_at = NOW()
    WHERE expense_id = p_expense_id;

  ELSIF p_role = 'ta' THEN
    v_amt := COALESCE(p_amount, v_current.ta_amount, v_current.rm_amount, v_current.verifier_amount, v_current.amount);
    UPDATE myactivity.expense_tbl SET
      ta_status  = p_action,
      ta_amount  = v_amt,
      ta_id      = p_approver_id,
      ta_comment = p_comment,
      ta_at      = NOW(),
      updated_at = NOW()
    WHERE expense_id = p_expense_id;

  ELSIF p_role = 'accounts' THEN
    v_amt := COALESCE(p_amount, v_current.ta_amount, v_current.rm_amount, v_current.verifier_amount, v_current.amount);
    UPDATE myactivity.expense_tbl SET
      accounts_status  = p_action,
      accounts_amount  = v_amt,
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
