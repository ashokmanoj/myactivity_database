-- DDL 059: Mobile Access User quick-create — adds a project link and a
-- "state of posting" field (mirrors the existing district_of_posting) so the
-- lightweight Mobile Access User form (project/name/mobile/email/state/district/rm)
-- has somewhere to persist project and state, alongside the existing
-- district_of_posting/reporting_rm columns it already reuses.
SET search_path TO myactivity;

ALTER TABLE user_information
  ADD COLUMN IF NOT EXISTS project_id INT REFERENCES project(project_id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS state_of_posting VARCHAR(100);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','059_mobile_access_user.sql') ON CONFLICT DO NOTHING;
