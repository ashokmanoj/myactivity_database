-- DDL 058: Daily phone/web activity log
-- Records one row per user per platform per calendar day so the App Version
-- Tracker can answer "how many people were active on date X" split by
-- Phone (mobile app, identified by the x-platform header) vs Web (admin
-- portal, no x-platform header) instead of a single last_seen_at that mixes
-- both sources together.
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS user_activity_log (
  id             SERIAL PRIMARY KEY,
  user_id        INT          NOT NULL,
  company_id     INT          NOT NULL,
  platform       VARCHAR(10)  NOT NULL,   -- 'phone' | 'web'
  activity_date  DATE         NOT NULL,
  first_seen_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  last_seen_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_user_activity_log UNIQUE (user_id, company_id, platform, activity_date)
);

CREATE INDEX IF NOT EXISTS idx_ual_date    ON user_activity_log (activity_date);
CREATE INDEX IF NOT EXISTS idx_ual_company ON user_activity_log (company_id, activity_date);
