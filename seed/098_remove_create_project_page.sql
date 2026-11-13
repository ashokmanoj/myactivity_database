-- The 'CreateProject' page was an empty placeholder and has been removed from
-- the web app. Drop any Role Page Access grants for it so it no longer shows
-- up as a legacy key on the Role Page Access screen.
SET search_path TO myactivity;

DELETE FROM role_page_access WHERE page_key = 'CreateProject';
