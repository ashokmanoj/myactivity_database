-- Function: fn_project_create  |  Domain: project
DROP FUNCTION IF EXISTS fn_project_create(VARCHAR, VARCHAR, VARCHAR, VARCHAR, DATE, DATE);

CREATE OR REPLACE FUNCTION fn_project_create(p_name VARCHAR, p_domain VARCHAR, p_code VARCHAR, p_logo VARCHAR, p_start DATE, p_end DATE, p_state VARCHAR DEFAULT NULL)
RETURNS SETOF project AS $$ BEGIN
RETURN QUERY INSERT INTO project (project_name, domain, project_code, logo_path, start_date, end_date, state, is_active, created_at, updated_at)
VALUES (p_name, p_domain, p_code, p_logo, p_start, p_end, p_state, 1, NOW(), NOW()) RETURNING *;
END; $$ LANGUAGE plpgsql;
