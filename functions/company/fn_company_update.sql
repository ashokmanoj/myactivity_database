-- Function: fn_company_update  |  Domain: company

CREATE OR REPLACE FUNCTION fn_company_update(p_id INT, p_name VARCHAR, p_email VARCHAR, p_website VARCHAR, p_address VARCHAR, p_state VARCHAR, p_country VARCHAR)
RETURNS SETOF company AS $$ BEGIN
RETURN QUERY UPDATE company SET company_name = COALESCE(p_name, company_name), email = COALESCE(p_email, email),
website = COALESCE(p_website, website), address = COALESCE(p_address, address), state = COALESCE(p_state, state),
country = COALESCE(p_country, country), updated_at = NOW() WHERE company_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;