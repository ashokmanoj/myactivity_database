-- DDL 078: In-database file storage. Every uploaded file (expense bills,
-- distance selfies, survey photos, user KYC documents, power-meter/PM
-- photos, location photos, APK releases) moves from the backend's uploads/
-- folder into this table, keyed by the same (category, filename) pair the
-- disk folder structure already used — so none of the many *_path columns
-- across the app need to change, only how the backend reads/writes the
-- bytes behind them (see myactivity_backend/src/utils/blobStore.js).
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS file_blob (
  blob_id      BIGSERIAL PRIMARY KEY,
  category     VARCHAR(50)  NOT NULL,
  filename     VARCHAR(255) NOT NULL,
  sha256       CHAR(64)     NOT NULL,
  content_type VARCHAR(100) NOT NULL,
  byte_size    BIGINT       NOT NULL,
  data         BYTEA        NOT NULL,
  created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_file_blob_category_filename
  ON file_blob(category, filename);

-- Images/APKs are already compressed — skip TOAST's own compression attempt
-- and allow substring() to read just the requested byte range efficiently
-- (used for chunked/Range responses instead of loading a whole blob at once).
ALTER TABLE file_blob ALTER COLUMN data SET STORAGE EXTERNAL;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','078_file_blob.sql') ON CONFLICT DO NOTHING;
