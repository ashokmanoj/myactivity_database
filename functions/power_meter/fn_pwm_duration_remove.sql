-- Function: fn_pwm_duration_remove  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_duration_remove(p_id INT)
RETURNS SETOF power_meter_receipt_duration AS $$ BEGIN
RETURN QUERY UPDATE power_meter_receipt_duration SET is_active = 0 WHERE duration_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
