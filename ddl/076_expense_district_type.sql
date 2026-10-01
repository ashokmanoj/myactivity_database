-- DDL 076: Add district_type to expense_tbl — Food expenses can now record
-- whether the meal was taken 'Inside District' or 'Outside District', same
-- shape as the existing state_type field (Within State / Other State) but at
-- the district level. Sized VARCHAR(50), not VARCHAR(20), on purpose — see
-- 075_expense_widen_varchar20_fields.sql for why a short enum-style column
-- still needs headroom against whatever exact wording a client sends.
SET search_path TO myactivity;

ALTER TABLE expense_tbl
  ADD COLUMN IF NOT EXISTS district_type VARCHAR(50);  -- 'Inside District' | 'Outside District'

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','076_expense_district_type.sql') ON CONFLICT DO NOTHING;
