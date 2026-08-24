-- Function: fn_pwm_category_create  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_category_create(p_name VARCHAR, p_sort_order INT)
RETURNS SETOF power_meter_category AS $$ BEGIN
RETURN QUERY INSERT INTO power_meter_category (category_name, sort_order, is_active, created_at)
VALUES (p_name, COALESCE(p_sort_order, 0), 1, NOW()) RETURNING *;
END; $$ LANGUAGE plpgsql;
