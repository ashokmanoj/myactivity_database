-- ============================================================================
-- DDL 002: project, designation, company
-- ============================================================================
SET search_path TO public;

CREATE TABLE IF NOT EXISTS project (
    project_id   SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    domain       VARCHAR(200),
    project_code VARCHAR(50)  UNIQUE,
    logo_path    VARCHAR(500),
    start_date   DATE,
    end_date     DATE,
    is_active    SMALLINT     NOT NULL DEFAULT 1,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_project_active ON project(is_active);

CREATE TABLE IF NOT EXISTS designation (
    designation_id SERIAL PRIMARY KEY,
    designation    VARCHAR(200) NOT NULL UNIQUE,
    project_id     INT REFERENCES project(project_id) ON DELETE SET NULL,
    is_active      SMALLINT    NOT NULL DEFAULT 1,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS company (
    company_id   SERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL,
    email        VARCHAR(200),
    website      VARCHAR(500),
    address      VARCHAR(500),
    state        VARCHAR(100),
    country      VARCHAR(100),
    is_active    SMALLINT    NOT NULL DEFAULT 1,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_company_active ON company(is_active);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','002_projects_tables.sql') ON CONFLICT DO NOTHING;
