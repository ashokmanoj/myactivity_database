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

-- Starter category rows moved to database/seed/020_power_meter_category.sql
-- — DDL files are schema-only now (see database/seed/README.md).
