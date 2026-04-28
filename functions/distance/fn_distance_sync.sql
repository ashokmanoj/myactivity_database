SET search_path TO myactivity;

-- Drop all known old signatures before recreating
DROP FUNCTION IF EXISTS fn_distance_sync(INT, VARCHAR, INT, VARCHAR, BIGINT, INT, VARCHAR, BIGINT, INT, INT, INT, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_sync(INT, VARCHAR, INT, VARCHAR, BIGINT, VARCHAR, BIGINT, INT, INT, INT, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_sync(INT, VARCHAR, VARCHAR, BIGINT, VARCHAR, BIGINT, INT, INT, INT, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_sync(INT, VARCHAR, VARCHAR, BIGINT, VARCHAR, BIGINT, INT, INT, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_sync(INT, VARCHAR, VARCHAR, BIGINT, VARCHAR, BIGINT, INT, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_sync(INT, VARCHAR, INT, BIGINT, INT, BIGINT, INT, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_sync(INT, VARCHAR, INT, BIGINT, INT, BIGINT, INT, VARCHAR);  -- all-default variant

CREATE OR REPLACE FUNCTION fn_distance_sync(
    p_user_id                   INT,
    p_vehicle_type              VARCHAR     DEFAULT NULL,
    p_start_image_id            INT         DEFAULT NULL,  -- FK → distance_images.id
    p_start_distance_timestamp  BIGINT      DEFAULT NULL,  -- required for new start, optional for end
    p_end_image_id              INT         DEFAULT NULL,
    p_end_distance_timestamp    BIGINT      DEFAULT NULL,
    p_rm_user_id                INT         DEFAULT NULL,
    p_uuid                      VARCHAR     DEFAULT NULL
)
RETURNS TABLE(trip_id INT, total_distance INT, required_amount NUMERIC, message TEXT)
AS $$
DECLARE
    v_id              INT;
    v_state           VARCHAR;
    v_district        VARCHAR;
    v_rate            NUMERIC(5,2);
    v_total_distance  INT;
    v_total_time      INT;
    v_required_amount NUMERIC(10,2);
    v_start_ts        BIGINT;
BEGIN
    -- Auto-fetch state and district from user_information
    SELECT
        COALESCE(curr_state, perm_state),
        district_of_posting
    INTO v_state, v_district
    FROM user_information
    WHERE user_id = p_user_id AND is_active = 1
    LIMIT 1;

    v_rate := CASE
        WHEN LOWER(COALESCE(v_state, '')) = 'assam'   THEN 3.00
        WHEN LOWER(COALESCE(v_state, '')) = 'tripura' THEN 3.50
        ELSE 3.00
    END;

    -- Check UUID idempotency
    IF p_uuid IS NOT NULL THEN
        SELECT dt.id INTO v_id FROM distance_tracking dt WHERE dt.uuid = p_uuid;
    END IF;

    -- End trip: UUID matched an existing record and end data provided
    IF v_id IS NOT NULL AND p_end_distance_timestamp IS NOT NULL THEN

        -- Haversine GPS distance (metres)
        SELECT COALESCE(
            SUM(
                6371000 * 2 * ASIN(SQRT(
                    POWER(SIN(RADIANS((b_lat - a_lat) / 2.0)), 2) +
                    COS(RADIANS(a_lat)) * COS(RADIANS(b_lat)) *
                    POWER(SIN(RADIANS((b_lon - a_lon) / 2.0)), 2)
                ))
            )::INT,
            0
        )
        INTO v_total_distance
        FROM (
            SELECT
                latitude::FLOAT                                          AS a_lat,
                longitude::FLOAT                                         AS a_lon,
                LEAD(latitude::FLOAT)  OVER (ORDER BY timestamp)        AS b_lat,
                LEAD(longitude::FLOAT) OVER (ORDER BY timestamp)        AS b_lon
            FROM gps_location
            WHERE gps_location.trip_id = v_id
        ) seg
        WHERE b_lat IS NOT NULL;

        SELECT dt.start_distance_timestamp INTO v_start_ts
        FROM distance_tracking dt WHERE dt.id = v_id;

        v_total_time      := ((p_end_distance_timestamp - v_start_ts) / 1000)::INT;
        v_required_amount := (COALESCE(v_total_distance, 0) / 1000.0) * v_rate;

        UPDATE distance_tracking SET
            end_image_id             = p_end_image_id,
            end_distance_timestamp   = p_end_distance_timestamp,
            total_distance           = v_total_distance,
            total_time               = v_total_time,
            required_amount          = v_required_amount,
            approved_amount          = v_required_amount,
            payment_status           = 'Processing'
        WHERE id = v_id;

        RETURN QUERY SELECT v_id, v_total_distance, v_required_amount, 'ENDED'::TEXT;
        RETURN;
    END IF;

    -- Already started (idempotent)
    IF v_id IS NOT NULL THEN
        RETURN QUERY SELECT v_id, NULL::INT, NULL::NUMERIC, 'EXISTS'::TEXT;
        RETURN;
    END IF;

    -- Start trip: insert new record
    INSERT INTO distance_tracking (
        user_id, rm_user_id, vehicle_type, state, district,
        start_image_id, start_distance_timestamp,
        rate_per_km, uuid
    ) VALUES (
        p_user_id, p_rm_user_id, p_vehicle_type, v_state, v_district,
        p_start_image_id, p_start_distance_timestamp,
        v_rate, p_uuid
    )
    RETURNING id INTO v_id;

    RETURN QUERY SELECT v_id, NULL::INT, NULL::NUMERIC, 'STARTED'::TEXT;
END;
$$ LANGUAGE plpgsql;
