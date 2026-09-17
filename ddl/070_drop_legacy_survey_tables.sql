-- DDL 070: Drop the old fixed-shape survey tables now that every project's
-- survey uses the dynamic survey_question/survey_submission/survey_answer
-- system instead (see 067-069). User confirmed the 12 existing submissions
-- in these tables don't need to be preserved or migrated.
SET search_path TO myactivity;

DROP TABLE IF EXISTS survey_images;
DROP TABLE IF EXISTS survey_classroom_equipment;
DROP TABLE IF EXISTS survey_mobile_networks;
DROP TABLE IF EXISTS survey_teacher_counts;
DROP TABLE IF EXISTS survey_student_sections;
DROP TABLE IF EXISTS survey_student_details;
DROP TABLE IF EXISTS survey_submissions;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','070_drop_legacy_survey_tables.sql') ON CONFLICT DO NOTHING;
