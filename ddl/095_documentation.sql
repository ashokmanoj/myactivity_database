-- ============================================================================
-- DDL 095: documentation — a field executive's documentation report for an
-- institution (Timetable, Tool kit, School Visit Report, ...), with the HM's
-- signed letter plus any number of extra images / PDFs / MP4 videos.
--
-- Report types are state-wise (not every state uses every type), so they
-- live in their own master table with a state mapping table beside it:
--   documentation_report_type        — the type names
--   documentation_report_type_state  — which states each type applies to,
--                                      matched against project.state (a full
--                                      state name, e.g. "Assam" — see DDL 063)
-- Seed list in database/seed/095_documentation.sql.
--
-- Files live in DigitalOcean Spaces; only the resulting URLs are stored here
-- (upload first via POST /api/v1/uploads/presigned-urls).
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS documentation_report_type (
    id               SERIAL        PRIMARY KEY,
    report_type_name VARCHAR(150)  NOT NULL UNIQUE,
    sort_order       INT           NOT NULL DEFAULT 0,
    is_active        SMALLINT      NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS documentation_report_type_state (
    id             SERIAL        PRIMARY KEY,
    report_type_id INT           NOT NULL REFERENCES documentation_report_type(id) ON DELETE CASCADE,
    state_name     VARCHAR(100)  NOT NULL,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_documentation_report_type_state UNIQUE (report_type_id, state_name)
);
CREATE INDEX IF NOT EXISTS idx_doc_report_type_state_name ON documentation_report_type_state (LOWER(state_name));

-- project_name / institution_name / report_type_name are snapshotted at
-- submit time (same as locations.institution_name, DDL 017) so a report
-- still reads correctly after a master record is renamed.
CREATE TABLE IF NOT EXISTS documentation (
    id               SERIAL        PRIMARY KEY,
    uuid             VARCHAR(100)  UNIQUE, -- client-generated, for offline-sync dedup
    user_id          INT           REFERENCES user_tbl(user_id),
    project_id       INT           NOT NULL REFERENCES project(project_id),
    project_name     VARCHAR(100),
    institute_id     INT           NOT NULL REFERENCES institution(institute_id),
    institution_name VARCHAR(150),
    report_type_id   INT           NOT NULL REFERENCES documentation_report_type(id),
    report_type_name VARCHAR(150),
    report_date      DATE          NOT NULL DEFAULT CURRENT_DATE,
    remarks          TEXT,
    hm_letter_image  VARCHAR(1000),
    attach_feedback  VARCHAR(1000),
    is_active        SMALLINT      NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Backfills attach_feedback for when this file already ran once before that
-- column was added to the CREATE TABLE above.
ALTER TABLE documentation ADD COLUMN IF NOT EXISTS attach_feedback VARCHAR(1000);

CREATE INDEX IF NOT EXISTS idx_documentation_user       ON documentation(user_id);
CREATE INDEX IF NOT EXISTS idx_documentation_project     ON documentation(project_id);
CREATE INDEX IF NOT EXISTS idx_documentation_institute   ON documentation(institute_id);
CREATE INDEX IF NOT EXISTS idx_documentation_report_type ON documentation(report_type_id);
CREATE INDEX IF NOT EXISTS idx_documentation_report_date ON documentation(report_date);
CREATE INDEX IF NOT EXISTS idx_documentation_active      ON documentation(is_active);

-- Additional attachments — one row per file, same image_name/fullpath_url
-- shape as tool_kit_images (DDL 090), plus file_type to tell them apart.
CREATE TABLE IF NOT EXISTS documentation_files (
    id               SERIAL        PRIMARY KEY,
    documentation_id INT           NOT NULL REFERENCES documentation(id) ON DELETE CASCADE,
    file_type        VARCHAR(10)   NOT NULL CHECK (file_type IN ('image', 'pdf', 'video')),
    file_name        VARCHAR(255),
    fullpath_url     VARCHAR(1000) NOT NULL,
    sort_order       INT           NOT NULL DEFAULT 0,
    is_active        SMALLINT      NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_documentation_files_doc ON documentation_files(documentation_id);
