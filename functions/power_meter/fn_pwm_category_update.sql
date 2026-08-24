-- Function: fn_pwm_category_update  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_category_update(p_id INT, p_name VARCHAR, p_sort_order INT)
RETURNS SETOF power_meter_category AS $$ BEGIN
RETURN QUERY UPDATE power_meter_category
SET category_name = COALESCE(p_name, category_name), sort_order = COALESCE(p_sort_order, sort_order)
WHERE category_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
