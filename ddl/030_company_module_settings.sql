-- Company-level feature flags for mobile app modules
CREATE TABLE IF NOT EXISTS myactivity.company_module_settings (
  id          SERIAL PRIMARY KEY,
  company_id  INT NOT NULL,
  module_key  VARCHAR(50) NOT NULL,
  is_enabled  BOOLEAN NOT NULL DEFAULT true,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_company_module UNIQUE (company_id, module_key)
);

-- Seed default (all enabled) for every existing company
INSERT INTO myactivity.company_module_settings (company_id, module_key, is_enabled)
SELECT c.company_id, m.module_key, true
FROM myactivity.company c
CROSS JOIN (VALUES
  ('distance'),
  ('expense'),
  ('task'),
  ('task_activity'),
  ('class_run'),
  ('add_location'),
  ('leave'),
  ('activity'),
  ('pm_inspection'),
  ('survey')
) AS m(module_key)
ON CONFLICT DO NOTHING;
