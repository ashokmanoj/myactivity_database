-- Function: fn_pwm_duration_create  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_duration_create(p_label VARCHAR, p_sort_order INT)
RETURNS SETOF power_meter_receipt_duration AS $$ BEGIN
RETURN QUERY INSERT INTO power_meter_receipt_duration (duration_label, sort_order, is_active, created_at)
VALUES (p_label, COALESCE(p_sort_order, 0), 1, NOW()) RETURNING *;
END; $$ LANGUAGE plpgsql;
