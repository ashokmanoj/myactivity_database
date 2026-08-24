-- Function: fn_state_get_all  |  Domain: state

CREATE OR REPLACE FUNCTION fn_state_get_all()
RETURNS TABLE(state_id INT, state_name VARCHAR, is_active SMALLINT, created_at TIMESTAMPTZ) AS $$ BEGIN
RETURN QUERY SELECT s.state_id, s.state_name, s.is_active, s.created_at
FROM state s WHERE s.is_active = 1 ORDER BY s.state_name;
END; $$ LANGUAGE plpgsql;
