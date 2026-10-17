-- ============================================================================
-- DDL 082: Rename task_list → assign_task_list
-- ============================================================================
-- Positioned early in run-all-migrations.js's SQL_FILES array — right before
-- 023_task_tables.sql, not at its own file-number position — so the rename
-- lands before 023/024/071 and the fn_task_* functions, which now all refer
-- to assign_task_list directly.
--
-- Guarded both ways so it's safe on every run:
--   - Existing DB (table still named task_list): renames it, once.
--   - Fresh DB (task_list never existed — 023 creates assign_task_list
--     directly): both EXISTS checks are false, so this is a no-op.
--   - Any later re-run on an already-renamed DB: task_list no longer exists,
--     so this stays a no-op forever after.
SET search_path TO myactivity;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'myactivity' AND table_name = 'task_list'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'myactivity' AND table_name = 'assign_task_list'
  ) THEN
    ALTER TABLE task_list RENAME TO assign_task_list;
  END IF;
END $$;
