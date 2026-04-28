SET search_path TO myactivity;

DROP FUNCTION IF EXISTS fn_distance_approval_update(INT, INT, VARCHAR, VARCHAR, TEXT, NUMERIC);
DROP FUNCTION IF EXISTS fn_distance_approval_update(INT, INT, VARCHAR, VARCHAR, TEXT, NUMERIC(10,2));

CREATE OR REPLACE FUNCTION fn_distance_approval_update(
    p_trip_id     INT,
    p_approver_id INT,
    p_role        VARCHAR,   -- 'verifier' | 'rm' | 'ta'
    p_action      VARCHAR,   -- 'Approved' | 'Rejected'
    p_comment     TEXT       DEFAULT NULL,
    p_amount      NUMERIC    DEFAULT NULL  -- amount this role approves (₹)
)
RETURNS TABLE(trip_id INT, approved_amount NUMERIC, message TEXT)
AS $$
DECLARE
    v_current RECORD;
    v_amt     NUMERIC(10,2);
BEGIN
    -- Table-alias to avoid ambiguity with RETURNS TABLE output column names
    SELECT dt.required_amount, dt.verifier_amount, dt.rm_amount, dt.approved_amount AS prev_approved
    INTO v_current
    FROM distance_tracking dt WHERE dt.id = p_trip_id;

    IF LOWER(p_role) = 'verifier' THEN
        v_amt := COALESCE(p_amount, v_current.required_amount);
        UPDATE distance_tracking SET
            verifier_status  = p_action,
            verifier_by      = p_approver_id,
            verifier_comment = p_comment,
            verifier_at      = NOW(),
            verifier_amount  = v_amt,
            rm_amount        = v_amt,
            approved_amount  = v_amt,
            updated_at       = NOW()
        WHERE id = p_trip_id;
        RETURN QUERY SELECT p_trip_id, v_amt, ('verifier ' || p_action)::TEXT;

    ELSIF LOWER(p_role) = 'rm' THEN
        v_amt := COALESCE(p_amount, v_current.rm_amount, v_current.verifier_amount, v_current.required_amount);
        UPDATE distance_tracking SET
            rm_status       = p_action,
            rm_by           = p_approver_id,
            rm_comment      = p_comment,
            rm_at           = NOW(),
            rm_amount       = v_amt,
            approved_amount = v_amt,
            updated_at      = NOW()
        WHERE id = p_trip_id;
        RETURN QUERY SELECT p_trip_id, v_amt, ('rm ' || p_action)::TEXT;

    ELSIF LOWER(p_role) = 'ta' THEN
        v_amt := COALESCE(p_amount, v_current.rm_amount, v_current.verifier_amount, v_current.required_amount);
        UPDATE distance_tracking SET
            ta_status       = p_action,
            ta_by           = p_approver_id,
            ta_comment      = p_comment,
            ta_at           = NOW(),
            approved_amount = v_amt,
            updated_at      = NOW()
        WHERE id = p_trip_id;
        RETURN QUERY SELECT p_trip_id, v_amt, ('ta ' || p_action)::TEXT;

    END IF;
END;
$$ LANGUAGE plpgsql;
