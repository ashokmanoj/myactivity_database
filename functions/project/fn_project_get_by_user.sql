-- Function: fn_project_get_by_user  |  Domain: project
-- Projects whose state matches the given user's own state — same
-- curr_state-then-perm_state resolution the frontend already did client-side
-- (fetch the user's profile, then filter the full project list in JS) for
-- RM/RMH project-dropdown scoping; this just moves it server-side.
-- Returns no rows (not "every project") if the user has no state on file.
CREATE OR REPLACE FUNCTION fn_project_get_by_user(p_user_id INT)
RETURNS SETOF project AS $$
DECLARE
  v_state VARCHAR;
BEGIN
  SELECT COALESCE(NULLIF(TRIM(ui.curr_state), ''), NULLIF(TRIM(ui.perm_state), ''))
  INTO v_state
  FROM user_information ui
  WHERE ui.user_id = p_user_id;

  RETURN QUERY
  SELECT * FROM project
  WHERE is_active = 1
    AND state = v_state;
END;
$$ LANGUAGE plpgsql;
