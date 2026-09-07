SET search_path TO myactivity;

-- All chat messages that @mention a given field executive, with just enough
-- trip context to show a card per trip — powers the Field Executive's own
-- restricted "mentions" inbox page.
CREATE OR REPLACE FUNCTION fn_distance_mentions_get(p_user_id INT)
RETURNS TABLE (
    message_id                BIGINT,
    trip_id                   INT,
    sender_user_id            INT,
    sender_name               VARCHAR,
    sender_role                VARCHAR,
    message                   TEXT,
    created_at                TIMESTAMPTZ,
    start_distance_timestamp  BIGINT,
    vehicle_type               VARCHAR,
    state                     VARCHAR,
    district                  VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        dm.id,
        dm.trip_id,
        dm.sender_user_id,
        u.full_name  AS sender_name,
        dm.sender_role,
        dm.message,
        dm.created_at,
        dt.start_distance_timestamp,
        dt.vehicle_type,
        dt.state,
        dt.district
    FROM distance_messages dm
    JOIN distance_tracking dt ON dt.id = dm.trip_id
    LEFT JOIN user_tbl u ON u.user_id = dm.sender_user_id
    WHERE dm.mentioned_user_id = p_user_id
    ORDER BY dm.created_at DESC;
END;
$$ LANGUAGE plpgsql;
