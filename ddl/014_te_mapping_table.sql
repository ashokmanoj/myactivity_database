-- ============================================================================
-- DDL 014: user_institution_map — Technical Executive ↔ Institution mapping
-- Replaces legacy tech_exec_institution_map.
-- Columns mirror tblUserInstitutionMap from the production reference schema.
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS user_institution_map (
    map_id         SERIAL PRIMARY KEY,
    project_id     INT          NOT NULL REFERENCES project(project_id)     ON DELETE RESTRICT,
    district_id    INT                   REFERENCES district(district_id)   ON DELETE SET NULL,
    block_id       INT                   REFERENCES block(block_id)         ON DELETE SET NULL,
    institution_id INT          NOT NULL REFERENCES institution(institute_id) ON DELETE RESTRICT,
    user_id        INT          NOT NULL REFERENCES user_tbl(user_id)       ON DELETE RESTRICT,
    rm_user_id     INT                   REFERENCES user_tbl(user_id)       ON DELETE SET NULL,
    active         SMALLINT     NOT NULL DEFAULT 1,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_uim_project   ON user_institution_map(project_id);
CREATE INDEX IF NOT EXISTS idx_uim_district  ON user_institution_map(district_id);
CREATE INDEX IF NOT EXISTS idx_uim_block     ON user_institution_map(block_id);
CREATE INDEX IF NOT EXISTS idx_uim_inst      ON user_institution_map(institution_id);
CREATE INDEX IF NOT EXISTS idx_uim_user      ON user_institution_map(user_id);
CREATE INDEX IF NOT EXISTS idx_uim_rm        ON user_institution_map(rm_user_id);
CREATE INDEX IF NOT EXISTS idx_uim_active    ON user_institution_map(active);

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.14', '014_te_mapping_table.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
