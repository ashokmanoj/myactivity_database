-- DDL 038: App version config — controls minimum supported version per platform
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS app_version_config (
  id              SERIAL       PRIMARY KEY,
  platform        VARCHAR(10)  NOT NULL,           -- 'android' | 'ios'
  min_version     VARCHAR(20)  NOT NULL DEFAULT '1.0.0',
  latest_version  VARCHAR(20)  NOT NULL DEFAULT '1.0.0',
  store_url       VARCHAR(500),                    -- Play Store / App Store URL
  update_message  TEXT,                            -- custom message shown to user
  is_force_update BOOLEAN      NOT NULL DEFAULT true,
  updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  CONSTRAINT app_version_config_platform_unique UNIQUE(platform)
);

-- Seed one row per platform
INSERT INTO app_version_config (platform, min_version, latest_version)
VALUES
  ('android', '1.0.0', '1.0.0'),
  ('ios',     '1.0.0', '1.0.0')
ON CONFLICT (platform) DO NOTHING;
