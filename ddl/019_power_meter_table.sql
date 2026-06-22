-- ============================================================================
-- DDL 019: Power Meter Table
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS power_meter (
    meter_id       SERIAL        PRIMARY KEY,
    uuid           VARCHAR(100)  UNIQUE,
    project_id     INT,
    institution_id INT,
    user_id        INT,
    meter_status   VARCHAR(20)   NOT NULL DEFAULT 'Working',  -- 'Working' | 'Not Working'
    comments       TEXT,
    image_path     VARCHAR(500),
    gps_lat        NUMERIC(10,7),
    gps_lng        NUMERIC(10,7),
    submitted_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    is_synced      SMALLINT      NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pwm_project_id     ON power_meter(project_id);
CREATE INDEX IF NOT EXISTS idx_pwm_institution_id ON power_meter(institution_id);
CREATE INDEX IF NOT EXISTS idx_pwm_user_id        ON power_meter(user_id);
CREATE INDEX IF NOT EXISTS idx_pwm_status         ON power_meter(meter_status);
CREATE INDEX IF NOT EXISTS idx_pwm_created_at     ON power_meter(created_at);

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.19', '019_power_meter_table.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
