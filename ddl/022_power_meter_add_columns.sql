-- ============================================================================
-- DDL 022: Add entry_type, meter_reading, receipt_duration_id to power_meter
-- ============================================================================
SET search_path TO myactivity;

ALTER TABLE power_meter
    ADD COLUMN IF NOT EXISTS entry_type          VARCHAR(20)  NOT NULL DEFAULT 'POWER_METER',
    ADD COLUMN IF NOT EXISTS meter_reading       VARCHAR(100),
    ADD COLUMN IF NOT EXISTS receipt_duration_id INT;

COMMENT ON COLUMN power_meter.entry_type          IS 'POWER_METER or RECEIPT';
COMMENT ON COLUMN power_meter.meter_reading       IS 'Reading shown on the meter (Power Meter type only)';
COMMENT ON COLUMN power_meter.receipt_duration_id IS 'FK to power_meter_receipt_duration (Receipt type only)';

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.22', '022_power_meter_add_columns.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
