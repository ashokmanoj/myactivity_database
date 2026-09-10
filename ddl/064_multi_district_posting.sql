-- DDL 064: District of Posting can now hold multiple districts for one user
-- (comma-separated, same convention as every other multi-value text field in
-- this app) — widened from VARCHAR(100) since a handful of district names
-- joined by commas can exceed 100 characters.
SET search_path TO myactivity;

ALTER TABLE user_information
  ALTER COLUMN district_of_posting TYPE VARCHAR(1000);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','064_multi_district_posting.sql') ON CONFLICT DO NOTHING;
