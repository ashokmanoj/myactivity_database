SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_approval_update(
    p_trip_id        INT,
    p_approver_id    INT,
    p_role           VARCHAR,   -- 'verifier' | 'rm' | 'ta'
    p_action         VARCHAR,   -- 'Approved' | 'Rejected'
    p_comment        TEXT       DEFAULT NULL,
    p_deduction      NUMERIC    DEFAULT NULL
)
RETURNS TABLE(trip_id INT, message TEXT)
AS $$
DECLARE
    v_approved_amount NUMERIC(10,2);
BEGIN
    IF LOWER(p_role) = 'verifier' THEN
        UPDATE distance_tracking SET
            verifier_status    = p_action,
            verifier_by        = p_approver_id,
            verifier_comment   = p_comment,
            verifier_at        = NOW(),
            verifier_deduction = COALESCE(p_deduction, verifier_deduction),
            approved_amount    = COALESCE(required_amount, 0) - COALESCE(p_deduction, verifier_deduction, 0),
            updated_at         = NOW()
        WHERE id = p_trip_id;

    ELSIF LOWER(p_role) = 'rm' THEN
        UPDATE distance_tracking SET
            rm_status    = p_action,
            rm_by        = p_approver_id,
            rm_comment   = p_comment,
            rm_at        = NOW(),
            updated_at   = NOW()
        WHERE id = p_trip_id;

    ELSIF LOWER(p_role) = 'ta' THEN
        UPDATE distance_tracking SET
            ta_status    = p_action,
            ta_by        = p_approver_id,
            ta_comment   = p_comment,
            ta_at        = NOW(),
            updated_at   = NOW()
        WHERE id = p_trip_id;
    END IF;

    RETURN QUERY SELECT p_trip_id, (p_role || ' ' || p_action)::TEXT;
END;
$$ LANGUAGE plpgsql;
