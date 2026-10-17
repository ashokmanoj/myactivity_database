-- ============================================================================
-- DDL 086: task_activity_images — multiple photos per task_activity row,
-- same shape as expense_images (043_expense_images.sql).
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS task_activity_images (
    id               SERIAL        PRIMARY KEY,
    task_activity_id INT           NOT NULL REFERENCES task_activity(id) ON DELETE CASCADE,
    image_path       VARCHAR(500)  NOT NULL,
    sort_order       INT           NOT NULL DEFAULT 0,
    is_active        SMALLINT      NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Backfills is_active/updated_at for when this file already ran once before
-- those columns were added to the CREATE TABLE above.
ALTER TABLE task_activity_images ADD COLUMN IF NOT EXISTS is_active  SMALLINT    NOT NULL DEFAULT 1;
ALTER TABLE task_activity_images ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW();

-- Re-adds the FK to task_activity if it's missing — it drops along with
-- task_activity whenever that table gets dropped/recreated (e.g. during
-- dev-time schema changes), since CREATE TABLE IF NOT EXISTS above is a
-- no-op against the already-existing task_activity_images table.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conrelid = 'myactivity.task_activity_images'::regclass
      AND confrelid = 'myactivity.task_activity'::regclass
      AND contype = 'f'
  ) THEN
    ALTER TABLE task_activity_images
      ADD CONSTRAINT task_activity_images_task_activity_id_fkey
      FOREIGN KEY (task_activity_id) REFERENCES task_activity(id) ON DELETE CASCADE;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_task_activity_images_task_activity ON task_activity_images(task_activity_id);
