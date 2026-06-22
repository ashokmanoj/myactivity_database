-- ============================================================================
-- DDL 020: Power Meter Category Table
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS power_meter_category (
    category_id   SERIAL       PRIMARY KEY,
    category_name VARCHAR(50)  NOT NULL UNIQUE,
    is_active     SMALLINT     NOT NULL DEFAULT 1,
    sort_order    INT          NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

INSERT INTO power_meter_category (category_name, sort_order) VALUES
    ('Working',     1),
    ('Not Working', 2)
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.20', '020_power_meter_category.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
