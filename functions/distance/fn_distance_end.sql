SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_end(
    p_id                        INT,
    p_end_odo_reading           INT,
    p_end_selfie_pic            VARCHAR,
    p_end_distance_timestamp    BIGINT,
    p_total_distance            INT,
    p_total_time                INT      DEFAULT NULL,
    p_uuid                      VARCHAR  DEFAULT NULL
)
RETURNS TABLE(trip_id INT, total_distance INT, required_amount NUMERIC, message TEXT)
AS $$
DECLARE
    v_id     INT;
    v_rate   NUMERIC(5,2);
    v_amount NUMERIC(10,2);
BEGIN
    IF p_id IS NULL OR p_id = 0 THEN
        SELECT id INTO v_id FROM distance_tracking WHERE uuid = p_uuid;
    ELSE
        v_id := p_id;
    END IF;

    SELECT rate_per_km INTO v_rate FROM distance_tracking WHERE id = v_id;
    v_amount := COALESCE(p_total_distance, 0) * COALESCE(v_rate, 3.00);

    UPDATE distance_tracking SET
        end_odo_reading        = COALESCE(NULLIF(p_end_odo_reading, 0),      end_odo_reading),
        end_selfie_pic         = COALESCE(NULLIF(p_end_selfie_pic, ''),      end_selfie_pic),
        end_distance_timestamp = COALESCE(NULLIF(p_end_distance_timestamp,0),end_distance_timestamp),
        total_distance         = COALESCE(NULLIF(p_total_distance, 0),       total_distance),
        total_time             = COALESCE(p_total_time,                      total_time),
        required_amount        = v_amount,
        approved_amount        = v_amount,
        updated_at             = NOW()
    WHERE id = v_id;

    RETURN QUERY SELECT v_id, p_total_distance, v_amount, 'UPDATED'::TEXT;
END;
$$ LANGUAGE plpgsql;
