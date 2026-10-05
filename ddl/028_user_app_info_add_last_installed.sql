-- ============================================================================
-- DDL 028: Add last_installed_at column to track when app version last changed
-- ============================================================================
SET search_path TO myactivity;

ALTER TABLE user_app_info
  ADD COLUMN IF NOT EXISTS last_installed_at TIMESTAMPTZ DEFAULT NULL;

-- Back-fill: treat created_at as the first install date for existing rows
UPDATE user_app_info
SET    last_installed_at = created_at
WHERE  last_installed_at IS NULL;
