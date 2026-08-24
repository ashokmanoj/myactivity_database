-- Function: fn_state_update  |  Domain: state

CREATE OR REPLACE FUNCTION fn_state_update(p_id INT, p_name VARCHAR)
RETURNS SETOF state AS $$ BEGIN
RETURN QUERY UPDATE state SET state_name = COALESCE(p_name, state_name)
WHERE state_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
