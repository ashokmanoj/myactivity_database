SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_leave_get_all(
    p_company_id INT,
    p_user_id    INT     DEFAULT NULL,  -- NULL = all users (manager view)
    p_status     VARCHAR DEFAULT NULL,  -- 'pending' | 'approved' | 'rejected'
    p_from       DATE    DEFAULT NULL,
    p_to         DATE    DEFAULT NULL
)
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
    WHERE lr.company_id = p_company_id
      AND (p_user_id IS NULL OR lr.user_id   = p_user_id)
      AND (p_status  IS NULL OR lr.status    = p_status)
      AND (p_from    IS NULL OR lr.leave_date >= p_from)
      AND (p_to      IS NULL OR lr.leave_date <= p_to)
    ORDER BY
        CASE lr.status WHEN 'pending' THEN 0 ELSE 1 END,
        lr.created_at DESC;
END;
$$ LANGUAGE plpgsql;
