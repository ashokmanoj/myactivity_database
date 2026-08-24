-- Function: fn_pwm_category_get_all  |  Domain: power_meter
-- Admin CRUD listing (all rows, not just active) — distinct from fn_pwm_get_categories
-- which mobile dropdowns use and must keep returning only active rows.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_category_get_all()
RETURNS TABLE(category_id INT, category_name VARCHAR, sort_order INT, is_active SMALLINT) AS $$
BEGIN
  RETURN QUERY
  SELECT c.category_id, c.category_name, c.sort_order, c.is_active
  FROM power_meter_category c
  ORDER BY c.sort_order ASC;
END;
$$ LANGUAGE plpgsql;
