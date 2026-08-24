-- Function: fn_state_get_by_id  |  Domain: state

CREATE OR REPLACE FUNCTION fn_state_get_by_id(p_id INT)
RETURNS TABLE(state_id INT, state_name VARCHAR, is_active SMALLINT, created_at TIMESTAMPTZ) AS $$ BEGIN
RETURN QUERY SELECT s.state_id, s.state_name, s.is_active, s.created_at
FROM state s WHERE s.state_id = p_id;
END; $$ LANGUAGE plpgsql;
