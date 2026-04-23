SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_messages_get(p_trip_id INT)
RETURNS TABLE (
    id              BIGINT,
    trip_id         INT,
    sender_user_id  INT,
    sender_name     VARCHAR,
    sender_role     VARCHAR,
    to_role         VARCHAR,
    message         TEXT,
    message_type    VARCHAR,
    created_at      TIMESTAMPTZ
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        dm.id,
        dm.trip_id,
        dm.sender_user_id,
        u.full_name   AS sender_name,
        dm.sender_role,
        dm.to_role,
        dm.message,
        dm.message_type,
        dm.created_at
    FROM distance_messages dm
    LEFT JOIN user_tbl u ON dm.sender_user_id = u.user_id
    WHERE dm.trip_id = p_trip_id
    ORDER BY dm.created_at ASC;
END;
$$ LANGUAGE plpgsql;
