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

-- Seed some departments
INSERT INTO department (department_name) VALUES 
('HR'), ('Finance'), ('IT'), ('Operations'), ('Sales'), ('Marketing')
ON CONFLICT (department_name) DO NOTHING;
