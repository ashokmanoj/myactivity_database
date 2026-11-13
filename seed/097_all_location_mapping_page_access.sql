-- All Location Mapping used to be open to every logged-in user with no page
-- key; it is now the 'AllLocationMapping' page in Role Page Access. Grant it
-- to every role once so nobody loses it on deploy — a Superuser can then
-- untick it per role. ON CONFLICT DO NOTHING keeps those unticks on re-runs.
-- Superuser is skipped: it always gets every page (hardcoded in auth.js).
SET search_path TO myactivity;

INSERT INTO role_page_access (role_id, page_key, is_visible, sort_order)
SELECT r.role_id, 'AllLocationMapping', true,
       COALESCE((SELECT MAX(sort_order) + 1 FROM role_page_access a WHERE a.role_id = r.role_id), 0)
FROM roles r
WHERE r.role_name <> 'Superuser'
ON CONFLICT (role_id, page_key) DO NOTHING;
