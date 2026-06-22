-- Function: fn_pwm_get_receipt_durations  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_get_receipt_durations()
RETURNS TABLE(
    duration_id    INT,
    duration_label VARCHAR,
    sort_order     INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT d.duration_id, d.duration_label, d.sort_order
    FROM power_meter_receipt_duration d
    WHERE d.is_active = 1
    ORDER BY d.sort_order ASC;
END;
$$ LANGUAGE plpgsql;
