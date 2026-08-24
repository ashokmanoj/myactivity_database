-- Function: fn_state_remove  |  Domain: state

CREATE OR REPLACE FUNCTION fn_state_remove(p_id INT)
RETURNS SETOF state AS $$ BEGIN
RETURN QUERY UPDATE state SET is_active = 0 WHERE state_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
