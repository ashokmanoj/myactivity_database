-- ============================================================================
-- DDL 084: visit_details — one record per institution visit (mobile "New Task
-- Activity" / START VISIT flow): a start photo+timestamp taken on arrival,
-- an end photo+timestamp taken on leaving.
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS visit_details (
    id                SERIAL        PRIMARY KEY,
    uuid              VARCHAR(100)  UNIQUE,
    project_id        INT           REFERENCES project(project_id)       ON DELETE SET NULL,
    institution_id    INT           REFERENCES institution(institute_id) ON DELETE SET NULL,
    user_id           INT           REFERENCES user_tbl(user_id)         ON DELETE SET NULL,
    visit_start_image VARCHAR(500),
    visit_start_at    TIMESTAMPTZ,
    visit_end_image   VARCHAR(500),
    visit_end_at      TIMESTAMPTZ,
    is_active         SMALLINT      NOT NULL DEFAULT 1,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Renames the original `active BOOLEAN` column (from this file's first
-- version) to `is_active SMALLINT` — matching the is_active convention used
-- everywhere else (task_activity, user_tbl, task_category, ...) — without
-- losing the real visit rows already recorded under the old name/type.
-- Guarded both ways: only fires when `active` exists and `is_active`
-- doesn't, so it's a no-op on a fresh DB (which creates is_active directly
-- above) and on any later re-run (active no longer exists after the first).
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'myactivity' AND table_name = 'visit_details' AND column_name = 'active'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'myactivity' AND table_name = 'visit_details' AND column_name = 'is_active'
  ) THEN
    ALTER TABLE visit_details RENAME COLUMN active TO is_active;
    -- The old BOOLEAN DEFAULT TRUE can't auto-cast to smallint — drop it
    -- before the type change, then set the new int default back.
    ALTER TABLE visit_details ALTER COLUMN is_active DROP DEFAULT;
    ALTER TABLE visit_details ALTER COLUMN is_active TYPE SMALLINT USING (is_active::int);
    ALTER TABLE visit_details ALTER COLUMN is_active SET DEFAULT 1;
  END IF;
END $$;

-- Backfills is_active for when this file already ran once before that
-- column was added to the CREATE TABLE above (and the rename block didn't
-- apply either, e.g. a DB that never had `active` at all).
ALTER TABLE visit_details ADD COLUMN IF NOT EXISTS is_active SMALLINT NOT NULL DEFAULT 1;

CREATE INDEX IF NOT EXISTS idx_visit_details_uuid           ON visit_details(uuid);
CREATE INDEX IF NOT EXISTS idx_visit_details_project_id     ON visit_details(project_id);
CREATE INDEX IF NOT EXISTS idx_visit_details_institution_id ON visit_details(institution_id);
CREATE INDEX IF NOT EXISTS idx_visit_details_user_id        ON visit_details(user_id);
