-- DDL 067: Project-scoped dynamic survey forms — replaces the fixed-column
-- survey_submissions/survey_student_details/survey_teacher_counts/
-- survey_mobile_networks/survey_classroom_equipment tables (which only ever
-- matched one project's exact form) with a generic question-bank + answer
-- model, so each project can have a completely different question set
-- without any schema change. The old tables are left in place, untouched —
-- they may hold real historical submissions and aren't worth risking.
SET search_path TO myactivity;

-- The question bank — one row per question, tagged to the project it
-- belongs to. `section`/`group_label` let the mobile app render the same
-- headings the paper forms use (e.g. section "D. Site Access..." with
-- sub-items grouped under group_label "65\" Integrated Touch e-Board...").
-- `repeat_group` marks a question as belonging to a repeatable block (e.g.
-- 'virtual_classroom') — the mobile app lets the user tap "Add another" to
-- answer the same group's questions again for a 2nd/3rd instance.
CREATE TABLE IF NOT EXISTS survey_question (
    question_id   SERIAL        PRIMARY KEY,
    project_id    INT           NOT NULL REFERENCES project(project_id) ON DELETE CASCADE,
    q_id          VARCHAR(60)   NOT NULL,
    section       VARCHAR(150),
    group_label   VARCHAR(200),
    repeat_group  VARCHAR(50),
    question      TEXT          NOT NULL,
    q_type        VARCHAR(20)   NOT NULL DEFAULT 'text', -- text | number | boolean | select | photo
    options       JSON,
    sort_order    INT           NOT NULL DEFAULT 0,
    is_active     SMALLINT      NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, q_id)
);
CREATE INDEX IF NOT EXISTS idx_survey_question_project ON survey_question(project_id);
CREATE INDEX IF NOT EXISTS idx_survey_question_active  ON survey_question(is_active);

-- One row per filled-out survey.
CREATE TABLE IF NOT EXISTS survey_submission (
    submission_id  SERIAL        PRIMARY KEY,
    project_id     INT           NOT NULL REFERENCES project(project_id) ON DELETE CASCADE,
    institution_id INT           REFERENCES institution(institute_id) ON DELETE SET NULL,
    school_name    VARCHAR(255), -- fallback display name if not matched to an institution row
    submitted_by   INT           REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_survey_submission_project ON survey_submission(project_id);
CREATE INDEX IF NOT EXISTS idx_survey_submission_inst    ON survey_submission(institution_id);

-- One row per answered question. `repeat_index` distinguishes the 1st vs
-- 2nd vs 3rd instance of a repeat_group question (e.g. Virtual Classroom
-- 1's "Display" status vs Virtual Classroom 2's) — always 1 for
-- non-repeating questions. `answer_value` holds text/number/boolean
-- ('true'/'false')/select value, or a photo's bare filename for q_type='photo'.
CREATE TABLE IF NOT EXISTS survey_answer (
    answer_id     BIGSERIAL     PRIMARY KEY,
    submission_id INT           NOT NULL REFERENCES survey_submission(submission_id) ON DELETE CASCADE,
    question_id   INT           NOT NULL REFERENCES survey_question(question_id),
    repeat_index  INT           NOT NULL DEFAULT 1,
    answer_value  TEXT,
    remarks       VARCHAR(500),
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_survey_answer_submission ON survey_answer(submission_id);
CREATE INDEX IF NOT EXISTS idx_survey_answer_question   ON survey_answer(question_id);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','067_survey_dynamic_forms.sql') ON CONFLICT DO NOTHING;
