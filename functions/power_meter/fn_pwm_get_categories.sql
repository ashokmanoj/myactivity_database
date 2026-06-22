-- Function: fn_pwm_get_categories  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_get_categories()
RETURNS TABLE(
    category_id   INT,
    category_name VARCHAR,
    sort_order    INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT c.category_id, c.category_name, c.sort_order
    FROM power_meter_category c
    WHERE c.is_active = 1
    ORDER BY c.sort_order ASC;
END;
$$ LANGUAGE plpgsql;
