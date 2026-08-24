-- Function: fn_state_create  |  Domain: state

CREATE OR REPLACE FUNCTION fn_state_create(p_name VARCHAR)
RETURNS SETOF state AS $$ BEGIN
RETURN QUERY INSERT INTO state (state_name, is_active, created_at)
VALUES (p_name, 1, NOW()) RETURNING *;
END; $$ LANGUAGE plpgsql;
