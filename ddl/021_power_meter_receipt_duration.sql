-- ============================================================================
-- DDL 021: Power Meter Receipt Duration Table
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS power_meter_receipt_duration (
    duration_id    SERIAL       PRIMARY KEY,
    duration_label VARCHAR(100) NOT NULL UNIQUE,
    is_active      SMALLINT     NOT NULL DEFAULT 1,
    sort_order     INT          NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

INSERT INTO power_meter_receipt_duration (duration_label, sort_order) VALUES
    ('Jan 2023 to Sep 2023',   1),
    ('Aug 2023 to Dec 2023',   2),
    ('Oct 2023 to Dec 2023',   3),
    ('Nov 2023 to Dec 2023',   4),
    ('April 2024 to May 2024', 5),
    ('Jan 2024 to March 2024', 6)
ON CONFLICT (duration_label) DO NOTHING;

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.21', '021_power_meter_receipt_duration.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
