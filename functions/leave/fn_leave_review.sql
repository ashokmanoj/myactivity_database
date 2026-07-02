SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_leave_review(
    p_leave_id    INT,
    p_reviewed_by INT,
    p_status      VARCHAR,         -- 'approved' | 'rejected'
    p_remarks     TEXT DEFAULT NULL
)
RETURNS SETOF leave_requests AS $$
DECLARE
    v_row leave_requests;
BEGIN
    IF p_status NOT IN ('approved', 'rejected') THEN
        RAISE EXCEPTION 'status must be approved or rejected';
    END IF;

    UPDATE leave_requests
    SET
        status         = p_status,
        reviewed_by    = p_reviewed_by,
        review_remarks = p_remarks,
        reviewed_at    = NOW(),
        updated_at     = NOW()
    WHERE id     = p_leave_id
      AND status = 'pending'
    RETURNING * INTO v_row;

    IF v_row IS NULL THEN
        RAISE EXCEPTION 'Leave request not found or already reviewed';
    END IF;

    RETURN NEXT v_row;
END;
$$ LANGUAGE plpgsql;
