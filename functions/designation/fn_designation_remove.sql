-- Function: fn_designation_remove  |  Domain: designation

CREATE OR REPLACE FUNCTION fn_designation_remove(p_id INT)
RETURNS SETOF designation AS $$ BEGIN
RETURN QUERY UPDATE designation SET is_active = 0, updated_at = NOW() WHERE designation_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;