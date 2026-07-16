-- Unified module settings table: covers company, project, and user scopes
CREATE TABLE IF NOT EXISTS myactivity.module_settings (
  id          SERIAL PRIMARY KEY,
  scope_type  VARCHAR(10)  NOT NULL CHECK (scope_type IN ('company', 'project', 'user')),
  scope_id    INT          NOT NULL,
  module_key  VARCHAR(50)  NOT NULL,
  is_enabled  BOOLEAN      NOT NULL DEFAULT true,
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_module_setting UNIQUE (scope_type, scope_id, module_key)
);

CREATE INDEX IF NOT EXISTS idx_module_settings_scope ON myactivity.module_settings (scope_type, scope_id);

-- Migrate existing company_module_settings data into unified table
INSERT INTO myactivity.module_settings (scope_type, scope_id, module_key, is_enabled, updated_at)
SELECT 'company', company_id, module_key, is_enabled, updated_at
FROM myactivity.company_module_settings
ON CONFLICT DO NOTHING;
