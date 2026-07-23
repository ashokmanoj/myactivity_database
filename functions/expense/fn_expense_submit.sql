SET search_path TO myactivity;

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
  INSERT INTO myactivity.expense_tbl(
    user_id, company_id, project_id, type, purpose,
    has_bill, amount, bill_date, remarks, bill_image_path
  )
  VALUES (
    p_user_id, p_company_id, p_project_id,
    COALESCE(p_type, 'expense'),
    p_purpose, COALESCE(p_has_bill, false),
    COALESCE(p_amount, 0), p_bill_date, p_remarks, p_bill_image_path
  )
  RETURNING expense_tbl.expense_id;
END;
$$ LANGUAGE plpgsql;
