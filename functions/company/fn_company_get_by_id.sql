-- Function: fn_company_get_by_id  |  Domain: company

CREATE OR REPLACE FUNCTION fn_company_get_by_id(p_id INT)
RETURNS SETOF company AS $$ BEGIN
RETURN QUERY SELECT * FROM company WHERE company_id = p_id AND is_active = 1;
END; $$ LANGUAGE plpgsql;