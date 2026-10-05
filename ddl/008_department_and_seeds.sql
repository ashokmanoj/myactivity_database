-- ============================================================================
-- DDL Additions: department table
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS department (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    is_active     SMALLINT    NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Starter department rows moved to database/seed/008_department_and_seeds.sql
-- — DDL files are schema-only now (see database/seed/README.md).
