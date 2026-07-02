SET search_path TO myactivity;

-- Returns TRUE if user has an approved leave on the given date.
-- Used by distance/attendance modules to flag absences.
CREATE OR REPLACE FUNCTION fn_leave_check(
    p_user_id  INT,
    p_date     DATE DEFAULT CURRENT_DATE
)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM leave_requests
        WHERE user_id   = p_user_id
          AND leave_date = p_date
          AND status    = 'approved'
    );
END;
$$ LANGUAGE plpgsql;
