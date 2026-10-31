-- ============================================================================
-- DDL 092: Keep assign_task_list.status in step with the task's activities.
-- Until now status was written once ('Pending') at assignment and never
-- touched again; only fn_task_get_all/fn_task_get_by_id derived the real
-- progress on the fly. This trigger stores it: whenever a task_activity is
-- inserted, updated or deleted, the task's status becomes the status_name of
-- its most recent active activity (same "latest by created_at" rule those two
-- functions use), or 'Pending' when it has none left.
-- Covers every write path (create, update, mobile bulk sync) in one place.
-- Idempotent — safe for run-all-migrations.js to re-run every time.
-- ============================================================================
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_status_sync(p_task_id INT)
RETURNS VOID AS $$
BEGIN
    UPDATE assign_task_list t
    SET status     = COALESCE((
            SELECT ast.status_name
            FROM task_activity ta
            JOIN activity_status ast ON ast.id = ta.status_id
            WHERE ta.task_id = p_task_id AND ta.is_active = 1
            ORDER BY ta.created_at DESC, ta.id DESC
            LIMIT 1
        ), 'Pending'),
        updated_at = NOW()
    WHERE t.task_id = p_task_id
      -- past 3 months the task is auto-completed and frozen (DDL 093)
      AND t.created_at >= NOW() - INTERVAL '3 months';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trg_task_activity_sync_task_status()
RETURNS TRIGGER AS $$
BEGIN
    -- An UPDATE that moves an activity to another task refreshes both tasks.
    IF TG_OP = 'INSERT' THEN
        PERFORM fn_task_status_sync(NEW.task_id);
    ELSIF TG_OP = 'DELETE' THEN
        PERFORM fn_task_status_sync(OLD.task_id);
    ELSE
        PERFORM fn_task_status_sync(NEW.task_id);
        IF OLD.task_id IS DISTINCT FROM NEW.task_id THEN
            PERFORM fn_task_status_sync(OLD.task_id);
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_task_activity_task_status ON task_activity;
CREATE TRIGGER trg_task_activity_task_status
AFTER INSERT OR UPDATE OF task_id, status_id, is_active OR DELETE ON task_activity
FOR EACH ROW EXECUTE PROCEDURE trg_task_activity_sync_task_status();

-- Backfill: bring every task that already has activity up to date.
SELECT fn_task_status_sync(task_id)
FROM (SELECT DISTINCT task_id FROM task_activity WHERE task_id IS NOT NULL) x;
