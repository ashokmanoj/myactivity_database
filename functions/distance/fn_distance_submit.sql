SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_submit(
    p_trip_id        INT,
    p_submitted_by   INT
)
RETURNS TABLE(trip_id INT, message TEXT)
AS $$
BEGIN
    UPDATE distance_tracking SET
        is_submitted   = 1,
        submitted_at   = NOW(),
        payment_status = 'Pending Payment',
        updated_at     = NOW()
    WHERE id = p_trip_id
      AND rm_status = 'Approved'
      AND is_submitted = 0;

    IF NOT FOUND THEN
        RETURN QUERY SELECT p_trip_id, 'NOT_ELIGIBLE'::TEXT;
        RETURN;
    END IF;

    RETURN QUERY SELECT p_trip_id, 'SUBMITTED'::TEXT;
END;
$$ LANGUAGE plpgsql;
