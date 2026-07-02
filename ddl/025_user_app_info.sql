-- ============================================================================
-- DDL 025: Track mobile app version and user activity per user/company
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS user_app_info (
    id           SERIAL PRIMARY KEY,
    user_id      INT NOT NULL,
    company_id   INT NOT NULL,
    platform     VARCHAR(20)  DEFAULT NULL,   -- 'android' | 'ios'
    app_version  VARCHAR(20)  DEFAULT NULL,   -- e.g. '1.0.0'
    device_id    VARCHAR(255) DEFAULT NULL,
    os_version   VARCHAR(50)  DEFAULT NULL,           -- e.g. 'Android 14', 'iOS 17.4'
    last_seen_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_user_app_info_user_company UNIQUE (user_id, company_id)
);

CREATE INDEX IF NOT EXISTS idx_user_app_info_company ON user_app_info (company_id);
CREATE INDEX IF NOT EXISTS idx_user_app_info_last_seen ON user_app_info (last_seen_at DESC);

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.25', '025_user_app_info.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
