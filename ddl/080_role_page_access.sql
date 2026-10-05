SET search_path TO myactivity;

-- Lets a Superuser control, per role, which frontend pages are visible —
-- replaces the previously hardcoded PAGE_ACCESS map in the frontend
-- (myactivity_frontend/src/utils/auth.js) with a DB-backed, admin-editable
-- table. Absence of a row for (role_id, page_key) means "not granted" —
-- there is no separate "default" row; the initial grant snapshot (mirroring
-- what PAGE_ACCESS already hardcoded) lives in database/seed/, not here.
CREATE TABLE IF NOT EXISTS role_page_access (
  id         SERIAL PRIMARY KEY,
  role_id    INT NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
  page_key   VARCHAR(50) NOT NULL,
  is_visible BOOLEAN NOT NULL DEFAULT true,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_role_page_access UNIQUE (role_id, page_key)
);

CREATE INDEX IF NOT EXISTS idx_role_page_access_role ON role_page_access(role_id);
