-- Function: fn_project_get_by_user  |  Domain: project
-- Projects in the given user's own state (fn_user_posting_state: state of
-- posting, falling back to address state) — e.g. scoping an RM/RMH's or an
-- executive's project dropdown. Match ignores case and stray spaces.
-- Returns no rows (not "every project") if the user has no state on file.
CREATE OR REPLACE FUNCTION fn_project_get_by_user(p_user_id INT)
RETURNS SETOF project AS $$
DECLARE
  v_state VARCHAR;
BEGIN
  v_state := fn_user_posting_state(p_user_id);

  RETURN QUERY
  SELECT * FROM project
  WHERE is_active = 1
    AND v_state IS NOT NULL
    AND LOWER(TRIM(state)) = LOWER(v_state);
END;
$$ LANGUAGE plpgsql;
