SET search_path TO myactivity;

-- Single-request counterpart to fn_leave_get_all — same joins, filtered to one id.
-- Used to return the full leave request after create/review/remove instead of the
-- bare leave_requests row.
CREATE OR REPLACE FUNCTION fn_leave_get_by_id(p_id INT)
RETURNS TABLE(
    id              INT,
    user_id         INT,
    full_name       VARCHAR,
    emp_code        VARCHAR,
    mobile_number   VARCHAR,
    role_name       VARCHAR,
    company_id      INT,
    leave_type      VARCHAR,
    leave_date      DATE,
    reason          TEXT,
    status          VARCHAR,
    reviewed_by     INT,
    reviewer_name   VARCHAR,
    review_remarks  TEXT,
    reviewed_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        lr.id,
        lr.user_id,
        u.full_name,
        u.emp_code,
        u.mobile_number,
        r.role_name,
        lr.company_id,
        lr.leave_type,
        lr.leave_date,
        lr.reason,
        lr.status,
        lr.reviewed_by,
        rev.full_name   AS reviewer_name,
        lr.review_remarks,
        lr.reviewed_at,
        lr.created_at
    FROM leave_requests lr
    JOIN  user_tbl u         ON u.user_id    = lr.user_id
    LEFT JOIN user_information ui ON ui.user_id = lr.user_id
    LEFT JOIN roles r         ON r.role_id   = ui.role_id
    LEFT JOIN user_tbl rev    ON rev.user_id  = lr.reviewed_by
    WHERE lr.id = p_id;
END;
$$ LANGUAGE plpgsql;
