SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_sync(
    p_user_id                   INT,
    p_vehicle_type              VARCHAR,
    p_start_selfie_pic          VARCHAR,
    p_start_distance_timestamp  BIGINT,
    p_end_selfie_pic            VARCHAR  DEFAULT NULL,
    p_end_distance_timestamp    BIGINT   DEFAULT NULL,
    p_total_distance            INT      DEFAULT NULL,
    p_total_time                INT      DEFAULT NULL,
    p_rm_user_id                INT      DEFAULT NULL,
    p_uuid                      VARCHAR  DEFAULT NULL
)
RETURNS TABLE(trip_id INT, required_amount NUMERIC, message TEXT)
AS $$
DECLARE
    v_id              INT;
    v_state           VARCHAR;
    v_district        VARCHAR;
    v_rate            NUMERIC(5,2);
    v_required_amount NUMERIC(10,2);
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
        SELECT id INTO v_id FROM distance_tracking WHERE uuid = p_uuid;
    END IF;

    -- End trip: UUID matched an existing record and end data provided
    IF v_id IS NOT NULL AND p_end_distance_timestamp IS NOT NULL THEN
        v_required_amount := COALESCE(p_total_distance, 0) * v_rate;

        UPDATE distance_tracking SET
            end_selfie_pic           = p_end_selfie_pic,
            end_distance_timestamp   = p_end_distance_timestamp,
            total_distance           = COALESCE(p_total_distance, total_distance),
            total_time               = COALESCE(p_total_time, total_time),
            required_amount          = v_required_amount,
            approved_amount          = v_required_amount,
            payment_status           = 'Processing'
        WHERE id = v_id;

        RETURN QUERY SELECT v_id, v_required_amount, 'ENDED'::TEXT;
        RETURN;
    END IF;

    -- Trip already exists (start was already recorded)
    IF v_id IS NOT NULL THEN
        RETURN QUERY SELECT v_id, NULL::NUMERIC, 'EXISTS'::TEXT;
        RETURN;
    END IF;

    -- Start trip: insert new record
    INSERT INTO distance_tracking (
        user_id, rm_user_id, vehicle_type, state, district,
        start_selfie_pic, start_distance_timestamp,
        rate_per_km, uuid
    ) VALUES (
        p_user_id, p_rm_user_id, p_vehicle_type, v_state, v_district,
        p_start_selfie_pic, p_start_distance_timestamp,
        v_rate, p_uuid
    )
    RETURNING id INTO v_id;

    RETURN QUERY SELECT v_id, NULL::NUMERIC, 'STARTED'::TEXT;
END;
$$ LANGUAGE plpgsql;
