-- DDL 017: add institution_name column to locations
SET search_path TO myactivity;

ALTER TABLE locations
    ADD COLUMN IF NOT EXISTS institution_name VARCHAR(200);

INSERT INTO schema_versions(version, migration_file)
VALUES ('v1.0.17', '017_location_add_inst_name.sql')
ON CONFLICT DO NOTHING;
