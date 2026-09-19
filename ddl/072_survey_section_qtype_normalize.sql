-- DDL 072: Normalize survey_question.section and .q_type from free text into
-- proper ID-referenced lookup tables — same category_id/sub_category_id
-- pattern already used by task_category/task_sub_category. survey_question
-- now stores section_id/q_type_id; API responses join back the display name
-- alongside the id (same convention fn_task_get_all uses for category_name).
SET search_path TO myactivity;

-- Fixed, small set of answer types — global, not project-scoped.
CREATE TABLE IF NOT EXISTS survey_question_type (
    type_id    SERIAL      PRIMARY KEY,
    type_name  VARCHAR(20) NOT NULL UNIQUE,
    sort_order INT         NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
INSERT INTO survey_question_type (type_name, sort_order) VALUES
    ('text',    1),
    ('number',  2),
    ('boolean', 3),
    ('select',  4),
    ('photo',   5),
    ('decimal',    6)
ON CONFLICT (type_name) DO NOTHING;

-- Sections are per-project (each project's paper form has its own headings).
CREATE TABLE IF NOT EXISTS survey_section (
    section_id   SERIAL        PRIMARY KEY,
    project_id   INT           NOT NULL REFERENCES project(project_id) ON DELETE CASCADE,
    section_name VARCHAR(150)  NOT NULL,
    sort_order   INT           NOT NULL DEFAULT 0,
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    UNIQUE (project_id, section_name)
);

ALTER TABLE survey_question ADD COLUMN IF NOT EXISTS section_id INT REFERENCES survey_section(section_id);
ALTER TABLE survey_question ADD COLUMN IF NOT EXISTS q_type_id  INT REFERENCES survey_question_type(type_id);

-- One-time backfill from the old free-text columns, guarded so a re-run
-- (columns already dropped) is a clean no-op instead of erroring.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'myactivity' AND table_name = 'survey_question' AND column_name = 'section'
  ) THEN
    INSERT INTO survey_section (project_id, section_name, sort_order)
    SELECT project_id, section, MIN(sort_order)
    FROM survey_question
    WHERE section IS NOT NULL
    GROUP BY project_id, section
    ON CONFLICT (project_id, section_name) DO NOTHING;

    UPDATE survey_question sq
    SET section_id = ss.section_id
    FROM survey_section ss
    WHERE ss.project_id = sq.project_id AND ss.section_name = sq.section AND sq.section_id IS NULL;

    UPDATE survey_question sq
    SET q_type_id = qt.type_id
    FROM survey_question_type qt
    WHERE qt.type_name = sq.q_type AND sq.q_type_id IS NULL;

    ALTER TABLE survey_question DROP COLUMN section;
    ALTER TABLE survey_question DROP COLUMN q_type;
  END IF;
END $$;

-- Any row still without a type (shouldn't happen) defaults to 'text'.
UPDATE survey_question sq
SET q_type_id = (SELECT type_id FROM survey_question_type WHERE type_name = 'text')
WHERE q_type_id IS NULL;

ALTER TABLE survey_question ALTER COLUMN q_type_id SET NOT NULL;

CREATE INDEX IF NOT EXISTS idx_survey_question_section ON survey_question(section_id);
CREATE INDEX IF NOT EXISTS idx_survey_question_qtype   ON survey_question(q_type_id);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','072_survey_section_qtype_normalize.sql') ON CONFLICT DO NOTHING;
