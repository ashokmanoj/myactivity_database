-- Function: fn_pwm_duration_get_all  |  Domain: power_meter
-- Admin CRUD listing (all rows, not just active) — distinct from fn_pwm_get_receipt_durations
-- which mobile dropdowns use and must keep returning only active rows.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_duration_get_all()
RETURNS TABLE(duration_id INT, duration_label VARCHAR, sort_order INT, is_active SMALLINT) AS $$
BEGIN
  RETURN QUERY
  SELECT d.duration_id, d.duration_label, d.sort_order, d.is_active
  FROM power_meter_receipt_duration d
  ORDER BY d.sort_order ASC;
END;
$$ LANGUAGE plpgsql;
