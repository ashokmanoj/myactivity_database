-- ============================================================================
-- DDL 093: Auto-complete stale tasks. Any assigned task that is still not
-- 'Completed' 3 months after it was assigned (created_at) is set to
-- 'Completed'. fn_task_status_sync (DDL 092) leaves tasks past that 3-month
-- mark alone, so a late activity can't reopen one. Called periodically by the
-- backend (src/jobs/taskAutoClose.js) and once here for what is already overdue.
-- Idempotent — safe for run-all-migrations.js to re-run every time.
-- ============================================================================
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_auto_close()
RETURNS INT AS $$
DECLARE
    v_count INT;
BEGIN
    UPDATE assign_task_list
    SET status     = 'Completed',
        updated_at = NOW()
    WHERE status <> 'Completed'
      AND created_at < NOW() - INTERVAL '3 months';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

SELECT fn_task_auto_close();
