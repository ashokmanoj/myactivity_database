-- ============================================================================
-- DDL 026: Add os_version column to user_app_info
-- ============================================================================
SET search_path TO myactivity;

ALTER TABLE user_app_info
    ADD COLUMN IF NOT EXISTS os_version VARCHAR(50) DEFAULT NULL;  -- e.g. 'Android 14', 'iOS 17.4'
