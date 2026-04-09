-- Function: fn_designation_name_exists  |  Domain: designation

CREATE OR REPLACE FUNCTION fn_designation_name_exists(p_name VARCHAR)
RETURNS TABLE(designation_id INT) AS $$ BEGIN
RETURN QUERY SELECT d.designation_id FROM designation d WHERE LOWER(d.designation) = LOWER(p_name) AND d.is_active = 1;
END; $$ LANGUAGE plpgsql;