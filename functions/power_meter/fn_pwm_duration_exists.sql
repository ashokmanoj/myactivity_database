-- Function: fn_pwm_duration_exists  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_duration_exists(p_id INT)
RETURNS BOOLEAN AS $$ BEGIN
RETURN EXISTS(SELECT 1 FROM power_meter_receipt_duration WHERE duration_id = p_id AND is_active = 1);
END; $$ LANGUAGE plpgsql;
