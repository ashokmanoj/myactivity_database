-- Function: fn_company_get_all  |  Domain: company

CREATE OR REPLACE FUNCTION fn_company_get_all(p_is_active SMALLINT DEFAULT 1)
RETURNS SETOF company AS $$ BEGIN
RETURN QUERY SELECT * FROM company WHERE is_active = p_is_active ORDER BY company_name ASC;
END; $$ LANGUAGE plpgsql;