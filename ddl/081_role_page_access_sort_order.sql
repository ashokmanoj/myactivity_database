SET search_path TO myactivity;

-- Lets a Superuser set each role's sidebar page ORDER (not just visibility,
-- already covered by 080_role_page_access.sql) from the Role Page Access
-- screen. getMyPages orders by this column, so the sidebar renders pages in
-- whatever sequence was configured per role.
ALTER TABLE role_page_access
  ADD COLUMN IF NOT EXISTS sort_order INT NOT NULL DEFAULT 0;
