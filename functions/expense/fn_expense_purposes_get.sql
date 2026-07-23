CREATE OR REPLACE FUNCTION fn_expense_purposes_get(
  p_company_id INT     DEFAULT NULL,
  p_applies_to VARCHAR DEFAULT NULL   -- 'expense' | 'advance' | NULL = all
)
RETURNS TABLE(
  purpose_id INT,
  name       VARCHAR,
  applies_to VARCHAR,
  is_active  BOOLEAN,
  company_id INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT p.purpose_id, p.name, p.applies_to, p.is_active, p.company_id
  FROM myactivity.expense_purpose_tbl p
  WHERE p.is_active = true
    AND (p_applies_to IS NULL OR p.applies_to IN (p_applies_to, 'both'))
    AND (p.company_id IS NULL OR p.company_id = p_company_id)
  ORDER BY p.company_id NULLS FIRST, p.purpose_id;
END;
$$ LANGUAGE plpgsql;
