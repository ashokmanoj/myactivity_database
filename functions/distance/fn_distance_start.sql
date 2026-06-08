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

    -- Auto-lookup RM: 1st try user_institution_map, 2nd try reporting_rm name match
    IF p_rm_user_id IS NULL THEN
        SELECT uim.rm_user_id INTO p_rm_user_id
        FROM user_institution_map uim
        WHERE uim.user_id = p_user_id AND uim.active = 1 AND uim.rm_user_id IS NOT NULL
        LIMIT 1;
    END IF;
    IF p_rm_user_id IS NULL THEN
        SELECT u.user_id INTO p_rm_user_id
        FROM user_tbl u
        JOIN user_information ui ON ui.user_id = p_user_id
        WHERE u.full_name = ui.reporting_rm AND u.is_active = 1
        LIMIT 1;
    END IF;

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
