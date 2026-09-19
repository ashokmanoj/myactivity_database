-- DDL 071: Deliver surveys through the existing Task Assignment feature
-- instead of a separate "school survey" flow. A manager assigns a task with
-- Category = Implementation, Sub-category = Survey (already exists), Project
-- and Executive as usual — no new fields on the task form. `is_survey` flags
-- which sub-categories should make the mobile app render the dynamic survey
-- form (GET /survey/questions?projectId=...) instead of a normal task-
-- completion screen. `survey_submission.task_id` links the resulting
-- submission back to the task so it can be auto-marked Completed.
SET search_path TO myactivity;

ALTER TABLE task_sub_category
  ADD COLUMN IF NOT EXISTS is_survey SMALLINT NOT NULL DEFAULT 0;

UPDATE task_sub_category s
SET is_survey = 1
FROM task_category c
WHERE s.category_id = c.category_id
  AND c.category_name = 'Implementation'
  AND s.sub_category_name = 'Survey'
  AND s.is_survey = 0;

ALTER TABLE survey_submission
  ADD COLUMN IF NOT EXISTS task_id INT REFERENCES task_list(task_id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_survey_submission_task ON survey_submission(task_id);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','071_survey_task_integration.sql') ON CONFLICT DO NOTHING;
