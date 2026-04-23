SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_forward(
    p_trip_id         INT,
    p_sender_user_id  INT,
    p_sender_role     VARCHAR,
    p_to_role         VARCHAR,
    p_message         TEXT
)
RETURNS TABLE(message_id BIGINT, message TEXT)
AS $$
DECLARE
    v_id BIGINT;
BEGIN
    INSERT INTO distance_messages (trip_id, sender_user_id, sender_role, to_role, message, message_type)
    VALUES (p_trip_id, p_sender_user_id, p_sender_role, p_to_role, p_message, 'forward')
    RETURNING id INTO v_id;

    RETURN QUERY SELECT v_id, 'FORWARDED'::TEXT;
END;
$$ LANGUAGE plpgsql;
