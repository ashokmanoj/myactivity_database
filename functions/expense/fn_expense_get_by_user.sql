SET search_path TO myactivity;

DROP FUNCTION IF EXISTS fn_expense_get_by_user(INT);

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
  images           JSON,
  state_type       VARCHAR,
  district_type    VARCHAR,
  food_sub_type    VARCHAR,
  driver_name      VARCHAR,
  driver_number    VARCHAR,
  vehicle_number   VARCHAR,
  docket_number    VARCHAR,
  mode_of_dispatch VARCHAR,
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
    COALESCE(
      (SELECT json_agg(json_build_object(
          'image_path',     img.image_path,
          'image_type',     img.image_type,
          'photo_lat',      img.photo_lat,
          'photo_lng',      img.photo_lng,
          'photo_location', img.photo_location
        ) ORDER BY img.sort_order)
       FROM myactivity.expense_images img WHERE img.expense_id = e.expense_id),
      '[]'::json
    ),
    e.state_type, e.district_type, e.food_sub_type,
    e.driver_name, e.driver_number, e.vehicle_number, e.docket_number, e.mode_of_dispatch,
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
