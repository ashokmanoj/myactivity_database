SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_leave_create(
    p_user_id    INT,
    p_company_id INT,
    p_leave_type VARCHAR DEFAULT 'leave',
    p_leave_date DATE    DEFAULT CURRENT_DATE,
    p_reason     TEXT    DEFAULT NULL
)
RETURNS SETOF leave_requests AS $$
BEGIN
    -- Block duplicate: user already has a pending/approved leave on this date
    IF EXISTS (
        SELECT 1 FROM leave_requests
        WHERE user_id   = p_user_id
          AND leave_date = p_leave_date
          AND status    IN ('pending', 'approved')
    ) THEN
        RAISE EXCEPTION 'A leave request already exists for this date';
    END IF;

    IF p_leave_type NOT IN ('leave', 'local_holiday') THEN
        RAISE EXCEPTION 'leave_type must be leave or local_holiday';
    END IF;

    RETURN QUERY
    INSERT INTO leave_requests (user_id, company_id, leave_type, leave_date, reason)
    VALUES (p_user_id, p_company_id, p_leave_type, p_leave_date, p_reason)
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
