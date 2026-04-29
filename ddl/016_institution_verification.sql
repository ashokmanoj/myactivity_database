-- ============================================================================
-- DDL 016: Add verification columns to institution table
-- ============================================================================
SET search_path TO myactivity;

ALTER TABLE institution
    ADD COLUMN IF NOT EXISTS is_verified  SMALLINT     NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS verified_at  TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS verified_by  INT          REFERENCES user_tbl(user_id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_inst_verified ON institution(is_verified);

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.16', '016_institution_verification.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
