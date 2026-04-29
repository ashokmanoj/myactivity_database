-- DDL 018: tech_exec_institution_map — maps Technical Executives to Institutions
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS tech_exec_institution_map (
    map_id         SERIAL PRIMARY KEY,
    user_id        INT         NOT NULL REFERENCES user_tbl(user_id),
    institute_id   INT         NOT NULL REFERENCES institution(institute_id),
    assigned_by    INT         REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    is_active      SMALLINT    NOT NULL DEFAULT 1,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_te_map_user      ON tech_exec_institution_map(user_id);
CREATE INDEX IF NOT EXISTS idx_te_map_institute ON tech_exec_institution_map(institute_id);
CREATE INDEX IF NOT EXISTS idx_te_map_active    ON tech_exec_institution_map(is_active);

INSERT INTO schema_versions(version, migration_file)
VALUES ('v1.0.18', '018_tech_exec_mapping.sql')
ON CONFLICT DO NOTHING;
