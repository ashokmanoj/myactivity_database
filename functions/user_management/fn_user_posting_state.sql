-- Function: fn_user_posting_state  |  Domain: user_management
-- A user's working state: state of posting, falling back to address state
-- (curr_state, then perm_state). Same rule as Distance trips and the Not
-- Started list (POSTING_STATE in distance.controller.js). Every "projects in
-- the executive's state" list uses it so they all agree. NULL if none on file.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_user_posting_state(p_user_id INT)
RETURNS VARCHAR AS $$
  SELECT NULLIF(TRIM(COALESCE(NULLIF(TRIM(ui.state_of_posting), ''),
                              NULLIF(TRIM(ui.curr_state), ''),
                              ui.perm_state)), '')
  FROM user_information ui
  WHERE ui.user_id = p_user_id
  ORDER BY ui.is_active DESC
  LIMIT 1;
$$ LANGUAGE sql STABLE;
