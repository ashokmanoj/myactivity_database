SET search_path TO myactivity;

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
  INSERT INTO myactivity.expense_messages(
    expense_id, sender_user_id, sender_name,
    sender_role, to_role, message, attachment_path
  ) VALUES (
    p_expense_id, p_sender_user_id, p_sender_name,
    p_sender_role, p_to_role, p_message, p_attachment_path
  )
  RETURNING expense_messages.message_id;
END;
$$ LANGUAGE plpgsql;
