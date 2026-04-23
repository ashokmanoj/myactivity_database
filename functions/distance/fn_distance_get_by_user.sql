SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_get_by_user(p_user_id INT)
RETURNS TABLE (
    id                        INT,
    vehicle_type              VARCHAR,
    state                     VARCHAR,
    district                  VARCHAR,
    start_selfie_pic          VARCHAR,
    end_selfie_pic            VARCHAR,
    start_distance_timestamp  BIGINT,
    end_distance_timestamp    BIGINT,
    total_distance            INT,
    rate_per_km               NUMERIC,
    required_amount           NUMERIC,
    uuid                      VARCHAR,
    is_active                 BOOLEAN
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        dt.id, dt.vehicle_type, dt.state, dt.district,
        dt.start_selfie_pic, dt.end_selfie_pic,
        dt.start_distance_timestamp, dt.end_distance_timestamp,
        dt.total_distance, dt.rate_per_km, dt.required_amount,
        dt.uuid,
        (dt.end_odo_reading IS NULL)::BOOLEAN AS is_active
    FROM distance_tracking dt
    WHERE dt.user_id = p_user_id
    ORDER BY dt.id DESC;
END;
$$ LANGUAGE plpgsql;
