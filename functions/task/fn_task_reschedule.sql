-- Function: fn_task_reschedule  |  Domain: task
-- Moves the given tasks to start on p_date (Task List "Assign Today" /
-- "Assign Tomorrow"). end_date is kept unless it would fall before the new
-- start, then it moves to p_date too. Completed tasks are left untouched.
-- Returns the ids that were actually rescheduled.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_reschedule(
    p_task_ids INT[],
    p_date     DATE
)
RETURNS TABLE(task_id INT) AS $$
BEGIN
    RETURN QUERY
    UPDATE assign_task_list t
    SET start_date = p_date,
        end_date   = GREATEST(COALESCE(t.end_date, p_date), p_date),
        updated_at = NOW()
    WHERE t.task_id = ANY(p_task_ids)
      AND t.status <> 'Completed'
    RETURNING t.task_id;
END;
$$ LANGUAGE plpgsql;
