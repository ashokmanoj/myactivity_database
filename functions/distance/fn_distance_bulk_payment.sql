SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_bulk_payment(
    p_trip_ids INT[],
    p_paid_by  INT
)
RETURNS TABLE(trip_id INT, payment_at TIMESTAMPTZ, message TEXT)
AS $$
DECLARE
    v_id INT;
BEGIN
    FOREACH v_id IN ARRAY p_trip_ids LOOP
        BEGIN
            RETURN QUERY SELECT * FROM fn_distance_payment(v_id, p_paid_by, NULL);
        EXCEPTION WHEN OTHERS THEN
            RETURN QUERY SELECT v_id, NOW()::TIMESTAMPTZ, ('ERROR: ' || SQLERRM)::TEXT;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
