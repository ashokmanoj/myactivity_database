-- ============================================================================
-- DDL 015: Preventive Maintenance Tables
-- Tables: pm_question, preventive_maintenance, pm_answer
-- ============================================================================
SET search_path TO myactivity;

-- ---------------------------------------------------------------------------
-- 1. pm_question  – master list of inspection questions
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pm_question (
    question_id  SERIAL       PRIMARY KEY,
    q_id         VARCHAR(50)  NOT NULL UNIQUE,
    question     TEXT         NOT NULL,
    q_type       VARCHAR(20)  NOT NULL DEFAULT 'yesNo',
    sort_order   INT          NOT NULL DEFAULT 0,
    is_active    BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pmq_is_active   ON pm_question(is_active);
CREATE INDEX IF NOT EXISTS idx_pmq_sort_order  ON pm_question(sort_order);

-- ---------------------------------------------------------------------------
-- 2. preventive_maintenance  – one record per inspection session
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS preventive_maintenance (
    pm_id           SERIAL        PRIMARY KEY,
    uuid            VARCHAR(100)  UNIQUE,
    project_id      INT           REFERENCES project(project_id)        ON DELETE SET NULL,
    institution_id  INT           REFERENCES institution(institute_id)   ON DELETE SET NULL,
    user_id         INT           REFERENCES user_tbl(user_id)          ON DELETE SET NULL,
    status          VARCHAR(20)   NOT NULL DEFAULT 'pending',
    total_questions INT           NOT NULL DEFAULT 0,
    answered_count  INT           NOT NULL DEFAULT 0,
    started_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    submitted_at    TIMESTAMPTZ,
    gps_lat         NUMERIC(10,7),
    gps_lng         NUMERIC(10,7),
    is_synced       SMALLINT      NOT NULL DEFAULT 0,
    created_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pm_project_id     ON preventive_maintenance(project_id);
CREATE INDEX IF NOT EXISTS idx_pm_institution_id ON preventive_maintenance(institution_id);
CREATE INDEX IF NOT EXISTS idx_pm_user_id        ON preventive_maintenance(user_id);
CREATE INDEX IF NOT EXISTS idx_pm_status         ON preventive_maintenance(status);

-- ---------------------------------------------------------------------------
-- 3. pm_answer  – individual question answers for a session
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pm_answer (
    answer_id    SERIAL        PRIMARY KEY,
    pm_id        INT           NOT NULL REFERENCES preventive_maintenance(pm_id) ON DELETE CASCADE,
    question_id  INT           NOT NULL REFERENCES pm_question(question_id),
    q_id         VARCHAR(50)   NOT NULL,
    answer       VARCHAR(20),          -- 'YES' | 'NO' | 'N/A' or free text
    photo_path   VARCHAR(500),
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    UNIQUE (pm_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_pma_pm_id       ON pm_answer(pm_id);
CREATE INDEX IF NOT EXISTS idx_pma_question_id ON pm_answer(question_id);

-- ---------------------------------------------------------------------------
-- Schema version record
-- ---------------------------------------------------------------------------
INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.15', '015_pm_tables.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
