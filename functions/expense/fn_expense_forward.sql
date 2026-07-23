SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_expense_forward(
  p_expense_id      INT,
  p_from_role       VARCHAR,
  p_to_role         VARCHAR,
  p_sender_user_id  INT,
  p_sender_name     VARCHAR,
  p_message         TEXT
)
RETURNS VOID AS $$
BEGIN
  -- Mark current stage as Forwarded
  IF p_from_role = 'verifier' THEN
    UPDATE myactivity.expense_tbl SET verifier_status = 'Forwarded', updated_at = NOW()
    WHERE expense_id = p_expense_id;
  ELSIF p_from_role = 'rm' THEN
    UPDATE myactivity.expense_tbl SET rm_status = 'Forwarded', updated_at = NOW()
    WHERE expense_id = p_expense_id;
  ELSIF p_from_role = 'ta' THEN
    UPDATE myactivity.expense_tbl SET ta_status = 'Forwarded', updated_at = NOW()
    WHERE expense_id = p_expense_id;
  END IF;

  INSERT INTO myactivity.expense_messages(
    expense_id, sender_user_id, sender_name, sender_role, to_role, message
  ) VALUES (
    p_expense_id, p_sender_user_id, p_sender_name, p_from_role, p_to_role, p_message
  );
END;
$$ LANGUAGE plpgsql;
