-- Function: fn_designation_exists  |  Domain: designation

CREATE OR REPLACE FUNCTION fn_designation_exists(p_id INT)
RETURNS BOOLEAN AS $$ BEGIN
RETURN EXISTS(SELECT 1 FROM designation WHERE designation_id = p_id AND is_active = 1);
END; $$ LANGUAGE plpgsql;