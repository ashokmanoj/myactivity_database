-- Function: fn_state_exists  |  Domain: state

CREATE OR REPLACE FUNCTION fn_state_exists(p_id INT)
RETURNS BOOLEAN AS $$ BEGIN
RETURN EXISTS(SELECT 1 FROM state WHERE state_id = p_id AND is_active = 1);
END; $$ LANGUAGE plpgsql;
