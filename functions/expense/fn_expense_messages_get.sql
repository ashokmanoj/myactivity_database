SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_expense_messages_get(p_expense_id INT)
RETURNS TABLE(
  message_id       INT,
  expense_id       INT,
  sender_user_id   INT,
  sender_name      VARCHAR,
  sender_role      VARCHAR,
  to_role          VARCHAR,
  message          TEXT,
  attachment_path  VARCHAR,
  created_at       TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT m.message_id, m.expense_id, m.sender_user_id,
    m.sender_name, m.sender_role, m.to_role,
    m.message, m.attachment_path, m.created_at
  FROM myactivity.expense_messages m
  WHERE m.expense_id = p_expense_id
  ORDER BY m.created_at ASC;
END;
$$ LANGUAGE plpgsql;
