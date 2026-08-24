-- Function: fn_pwm_category_remove  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_category_remove(p_id INT)
RETURNS SETOF power_meter_category AS $$ BEGIN
RETURN QUERY UPDATE power_meter_category SET is_active = 0 WHERE category_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
