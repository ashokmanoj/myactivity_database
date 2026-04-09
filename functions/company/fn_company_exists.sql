-- Function: fn_company_exists  |  Domain: company

CREATE OR REPLACE FUNCTION fn_company_exists(p_id INT)
RETURNS BOOLEAN AS $$ BEGIN
RETURN EXISTS(SELECT 1 FROM company WHERE company_id = p_id AND is_active = 1);
END; $$ LANGUAGE plpgsql;