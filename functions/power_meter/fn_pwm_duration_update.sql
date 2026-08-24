-- Function: fn_pwm_duration_update  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_duration_update(p_id INT, p_label VARCHAR, p_sort_order INT)
RETURNS SETOF power_meter_receipt_duration AS $$ BEGIN
RETURN QUERY UPDATE power_meter_receipt_duration
SET duration_label = COALESCE(p_label, duration_label), sort_order = COALESCE(p_sort_order, sort_order)
WHERE duration_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
