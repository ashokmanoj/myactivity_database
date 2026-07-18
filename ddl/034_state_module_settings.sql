-- DDL 034: Add state table and state scope to module_settings
SET search_path TO myactivity;

-- State reference table (populated from existing district data)
CREATE TABLE IF NOT EXISTS state (
  state_id   SERIAL       PRIMARY KEY,
  state_name VARCHAR(100) NOT NULL UNIQUE,
  is_active  SMALLINT     NOT NULL DEFAULT 1,
  created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Populate from existing district state_code values
INSERT INTO state (state_name)
SELECT DISTINCT state_code
FROM district
WHERE state_code IS NOT NULL AND TRIM(state_code) != ''
ON CONFLICT (state_name) DO NOTHING;

-- Extend module_settings to allow 'state' scope
ALTER TABLE module_settings
  DROP CONSTRAINT IF EXISTS module_settings_scope_type_check;

ALTER TABLE module_settings
  ADD CONSTRAINT module_settings_scope_type_check
  CHECK (scope_type IN ('company', 'project', 'user', 'state'));
