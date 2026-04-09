-- Function: fn_company_remove  |  Domain: company

CREATE OR REPLACE FUNCTION fn_company_remove(p_id INT)
RETURNS SETOF company AS $$ BEGIN
RETURN QUERY UPDATE company SET is_active = 0, updated_at = NOW() WHERE company_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;