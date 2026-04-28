SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_mark_read(
    p_trip_id INT,
    p_role    VARCHAR
)
RETURNS VOID AS $$
BEGIN
    UPDATE distance_messages
    SET is_read = 1
    WHERE trip_id  = p_trip_id
      AND LOWER(to_role) = LOWER(p_role)
      AND is_read = 0;
END;
$$ LANGUAGE plpgsql;
