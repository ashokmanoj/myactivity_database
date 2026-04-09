-- Function: fn_company_create  |  Domain: company

CREATE OR REPLACE FUNCTION fn_company_create(p_name VARCHAR, p_email VARCHAR, p_website VARCHAR, p_address VARCHAR, p_state VARCHAR, p_country VARCHAR)
RETURNS SETOF company AS $$ BEGIN
RETURN QUERY INSERT INTO company (company_name, email, website, address, state, country, is_active, created_at, updated_at)
VALUES (p_name, p_email, p_website, p_address, p_state, p_country, 1, NOW(), NOW()) RETURNING *;
END; $$ LANGUAGE plpgsql;