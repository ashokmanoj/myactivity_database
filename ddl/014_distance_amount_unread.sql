-- ============================================================================
-- DDL 014: amount cascade columns + message read tracking
-- ============================================================================
SET search_path TO myactivity;

-- Each approval role stores the amount they set; cascades downward
ALTER TABLE distance_tracking
  ADD COLUMN IF NOT EXISTS verifier_amount NUMERIC(10,2),
  ADD COLUMN IF NOT EXISTS rm_amount       NUMERIC(10,2);

-- Track whether a forwarded message has been read by the recipient role
ALTER TABLE distance_messages
  ADD COLUMN IF NOT EXISTS is_read SMALLINT NOT NULL DEFAULT 0;

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.14', '014_distance_amount_unread.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
