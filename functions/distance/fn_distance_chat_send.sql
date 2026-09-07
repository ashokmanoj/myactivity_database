SET search_path TO myactivity;

-- Free-form two-way chat message — unlike fn_distance_forward, this does NOT
-- change the trip's routing (to_role is optional/nullable: NULL means "visible
-- to the whole thread" rather than directed at one role's approval queue).
-- p_mentioned_user_id is resolved by the caller (distance.controller.js) by
-- matching an "@ExecutiveName" mention in the message text against the trip's
-- own executive — it's what lets that message show up in the executive's
-- personal mention inbox (fn_distance_mentions_get).
CREATE OR REPLACE FUNCTION fn_distance_chat_send(
    p_trip_id           INT,
    p_sender_user_id    INT,
    p_sender_role       VARCHAR,
    p_to_role           VARCHAR,
    p_message           TEXT,
    p_mentioned_user_id INT
)
RETURNS TABLE(message_id BIGINT)
AS $$
DECLARE
    v_id BIGINT;
BEGIN
    INSERT INTO distance_messages
        (trip_id, sender_user_id, sender_role, to_role, message, message_type, mentioned_user_id)
    VALUES
        (p_trip_id, p_sender_user_id, p_sender_role, p_to_role, p_message, 'chat', p_mentioned_user_id)
    RETURNING id INTO v_id;

    RETURN QUERY SELECT v_id;
END;
$$ LANGUAGE plpgsql;
