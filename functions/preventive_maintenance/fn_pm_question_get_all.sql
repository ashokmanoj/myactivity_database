-- Function: fn_pm_question_get_all  |  Domain: preventive_maintenance
-- Returns all active PM questions ordered by sort_order.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_question_get_all()
RETURNS TABLE(
    question_id  INT,
    q_id         VARCHAR,
    question     TEXT,
    q_type       VARCHAR,
    sort_order   INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        q.question_id,
        q.q_id,
        q.question,
        q.q_type,
        q.sort_order
    FROM pm_question q
    WHERE q.is_active = TRUE
    ORDER BY q.sort_order ASC;
END;
$$ LANGUAGE plpgsql;
