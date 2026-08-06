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
  p_bill_image_path VARCHAR,
  -- new purpose-specific fields (all optional / nullable)
  p_expense_date    DATE    DEFAULT NULL,
  p_state_type      VARCHAR DEFAULT NULL,  -- Food: 'Within State' | 'Other State'
  p_food_sub_type   VARCHAR DEFAULT NULL,  -- Food: Breakfast | Lunch | Dinner | Snacks
  p_hotel_name      VARCHAR DEFAULT NULL,  -- Stay: hotel / lodge name
  p_stay_location   VARCHAR DEFAULT NULL,  -- Stay: GPS address
  p_stay_lat        NUMERIC DEFAULT NULL,
  p_stay_lng        NUMERIC DEFAULT NULL,
  p_stay_days            INT     DEFAULT NULL,  -- Stay: number of nights
  p_payment_method       VARCHAR DEFAULT 'Cash', -- Cash | Online | UPI | Card
  p_receptionist_name    VARCHAR DEFAULT NULL,  -- Stay: receptionist name
  p_receptionist_phone   VARCHAR DEFAULT NULL,  -- Stay: receptionist phone
  p_checkout_date        DATE    DEFAULT NULL   -- Stay: check-out date (date-range alternative to stay_days)
)
RETURNS TABLE(expense_id INT) AS $$
BEGIN
  RETURN QUERY
  INSERT INTO myactivity.expense_tbl(
    user_id, company_id, project_id, type, purpose,
    has_bill, amount, bill_date, remarks, bill_image_path,
    expense_date, state_type, food_sub_type,
    hotel_name, stay_location, stay_lat, stay_lng, stay_days,
    payment_method, receptionist_name, receptionist_phone, checkout_date
  )
  VALUES (
    p_user_id, p_company_id, p_project_id,
    COALESCE(p_type, 'expense'),
    p_purpose, COALESCE(p_has_bill, false),
    COALESCE(p_amount, 0), p_bill_date, p_remarks, p_bill_image_path,
    p_expense_date, p_state_type, p_food_sub_type,
    p_hotel_name, p_stay_location, p_stay_lat, p_stay_lng, p_stay_days,
    COALESCE(p_payment_method, 'Cash'), p_receptionist_name, p_receptionist_phone, p_checkout_date
  )
  RETURNING expense_tbl.expense_id;
END;
$$ LANGUAGE plpgsql;
