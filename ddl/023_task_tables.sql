-- ============================================================================
-- DDL 023: Task Category, Sub-Category, and Task List Tables
-- ============================================================================
SET search_path TO myactivity;

-- ── Task Category ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS task_category (
    category_id   SERIAL       PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    is_active     SMALLINT     NOT NULL DEFAULT 1,
    sort_order    INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- ── Task Sub-Category ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS task_sub_category (
    sub_category_id   SERIAL       PRIMARY KEY,
    category_id       INT          NOT NULL REFERENCES task_category(category_id) ON DELETE CASCADE,
    sub_category_name VARCHAR(200) NOT NULL,
    is_active         SMALLINT     NOT NULL DEFAULT 1,
    sort_order        INT          NOT NULL DEFAULT 0,
    created_at        TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    UNIQUE (category_id, sub_category_name)
);

-- ── Task List ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS task_list (
    task_id         SERIAL       PRIMARY KEY,
    project_id      INT,
    category_id     INT          REFERENCES task_category(category_id),
    sub_category_id INT          REFERENCES task_sub_category(sub_category_id),
    designation     VARCHAR(100),
    district        VARCHAR(100),
    block           VARCHAR(100),
    priority        VARCHAR(20)  NOT NULL DEFAULT 'Medium',  -- High | Medium | Low
    executive_id    INT,
    institution_id  INT,
    start_date      DATE,
    end_date        DATE,
    interval_type   VARCHAR(20),                            -- Week | 15 Days | Month | Custom
    interval_days   INT,
    remarks         TEXT,
    status          VARCHAR(20)  NOT NULL DEFAULT 'Pending', -- Pending | In Progress | Completed
    created_by      INT,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_task_category_id     ON task_list(category_id);
CREATE INDEX IF NOT EXISTS idx_task_sub_category_id ON task_list(sub_category_id);
CREATE INDEX IF NOT EXISTS idx_task_project_id      ON task_list(project_id);
CREATE INDEX IF NOT EXISTS idx_task_executive_id    ON task_list(executive_id);
CREATE INDEX IF NOT EXISTS idx_task_status          ON task_list(status);
CREATE INDEX IF NOT EXISTS idx_task_created_at      ON task_list(created_at);

-- Category/sub-category seed rows moved to database/seed/023_task_tables.sql
-- — DDL files are schema-only now (see database/seed/README.md).
