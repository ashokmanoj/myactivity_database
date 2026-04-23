SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_start(
    p_user_id                   INT,
    p_vehicle_type              VARCHAR,
    p_start_odo_reading         INT,
    p_start_selfie_pic          VARCHAR,
    p_start_distance_timestamp  BIGINT,
    p_state                     VARCHAR  DEFAULT NULL,
    p_district                  VARCHAR  DEFAULT NULL,
    p_rm_user_id                INT      DEFAULT NULL,
    p_uuid                      VARCHAR  DEFAULT NULL
)
RETURNS TABLE(trip_id INT, message TEXT)
AS $$
DECLARE
    v_id         INT;
    v_rate       NUMERIC(5,2);
BEGIN
    IF p_uuid IS NOT NULL THEN
        SELECT id INTO v_id FROM distance_tracking WHERE uuid = p_uuid;
        IF FOUND THEN
            RETURN QUERY SELECT v_id, 'EXISTS'::TEXT;
            RETURN;
        END IF;
    END IF;

    v_rate := CASE
        WHEN LOWER(p_state) = 'assam'   THEN 3.00
        WHEN LOWER(p_state) = 'tripura' THEN 3.50
        ELSE 3.00
    END;

    INSERT INTO distance_tracking (
        user_id, rm_user_id, vehicle_type, state, district,
        start_odo_reading, start_selfie_pic, start_distance_timestamp,
        rate_per_km, uuid
    ) VALUES (
        p_user_id, p_rm_user_id, p_vehicle_type, p_state, p_district,
        p_start_odo_reading, p_start_selfie_pic, p_start_distance_timestamp,
        v_rate, p_uuid
    )
    RETURNING id INTO v_id;

    RETURN QUERY SELECT v_id, 'CREATED'::TEXT;
END;
$$ LANGUAGE plpgsql;
