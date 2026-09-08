-- DDL 063: State-scope a project (each project belongs to exactly one state,
-- confirmed by the user) so Distance and other pages can filter the Project
-- dropdown down to only the projects for a selected state.
SET search_path TO myactivity;

ALTER TABLE project
  ADD COLUMN IF NOT EXISTS state VARCHAR(100);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','063_project_state.sql') ON CONFLICT DO NOTHING;
