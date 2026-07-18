-- DDL 035: Add force_logout_at column for remote session termination
SET search_path TO myactivity;

ALTER TABLE user_tbl
  ADD COLUMN IF NOT EXISTS force_logout_at TIMESTAMPTZ DEFAULT NULL;

COMMENT ON COLUMN user_tbl.force_logout_at IS
  'Set by Superuser to invalidate all tokens issued before this timestamp (remote force-logout)';
