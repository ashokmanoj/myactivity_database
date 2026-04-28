SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_payment(
    p_trip_id INT,
    p_paid_by INT,
    p_amount  NUMERIC DEFAULT NULL
)
RETURNS TABLE(trip_id INT, payment_at TIMESTAMPTZ, message TEXT)
AS $$
DECLARE
    v_now TIMESTAMPTZ := NOW();
BEGIN
    UPDATE distance_tracking SET
        payment_status  = 'Paid',
        payment_by      = p_paid_by,
        payment_at      = v_now,
        approved_amount = COALESCE(p_amount, approved_amount),
        updated_at      = v_now
    WHERE id = p_trip_id
      AND payment_status <> 'Paid';   -- prevent double payment

    IF NOT FOUND THEN
        RETURN QUERY SELECT p_trip_id, v_now, 'ALREADY_PAID'::TEXT;
        RETURN;
    END IF;

    RETURN QUERY SELECT p_trip_id, v_now, 'PAID'::TEXT;
END;
$$ LANGUAGE plpgsql;
