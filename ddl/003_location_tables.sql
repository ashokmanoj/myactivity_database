-- ============================================================================
-- DDL 003: district, block, instituation, instituation_project_map
-- ============================================================================
SET search_path TO public;

CREATE TABLE IF NOT EXISTS district (
    district_id   SERIAL PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL UNIQUE,
    state_code    VARCHAR(10),
    is_active     SMALLINT    NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS block (
    block_id    SERIAL PRIMARY KEY,
    block_name  VARCHAR(100) NOT NULL,
    district_id INT          NOT NULL REFERENCES district(district_id),
    is_active   SMALLINT     NOT NULL DEFAULT 1,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_block_name_district_id UNIQUE (block_name, district_id)
);
CREATE INDEX IF NOT EXISTS idx_block_district ON block(district_id);

-- NOTE: table name intentionally matches original project spelling "instituation"
CREATE TABLE IF NOT EXISTS instituation (
    institute_id     SERIAL PRIMARY KEY,
    institution_name VARCHAR(150) NOT NULL,
    institute_code   VARCHAR(50)  NOT NULL UNIQUE,
    project_id       INT          NOT NULL REFERENCES project(project_id),
    district_id      INT          REFERENCES district(district_id),
    block_id         INT          REFERENCES block(block_id),
    address          VARCHAR(500),
    pincode          INT,
    latitude         NUMERIC(8,6),
    longitude        NUMERIC(9,6),
    is_active        SMALLINT     NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_inst_project  ON instituation(project_id);
CREATE INDEX IF NOT EXISTS idx_inst_district ON instituation(district_id);
CREATE INDEX IF NOT EXISTS idx_inst_active   ON instituation(is_active);

CREATE TABLE IF NOT EXISTS instituation_project_map (
    institute_project_map_id SERIAL PRIMARY KEY,
    project_id               INT NOT NULL REFERENCES project(project_id),
    institute_id             INT NOT NULL REFERENCES instituation(institute_id),
    is_active                SMALLINT NOT NULL DEFAULT 1,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_inst_proj_map UNIQUE (project_id, institute_id)
);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','003_location_tables.sql') ON CONFLICT DO NOTHING;
