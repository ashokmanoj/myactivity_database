-- Function: fn_project_sync  |  Domain: project

CREATE OR REPLACE FUNCTION fn_project_sync(p_name VARCHAR, p_domain VARCHAR, p_code VARCHAR, p_logo VARCHAR, p_start DATE, p_end DATE)
RETURNS SETOF project AS $$ BEGIN
RETURN QUERY INSERT INTO project (project_name, domain, project_code, logo_path, start_date, end_date, is_active, created_at, updated_at)
VALUES (p_name, p_domain, p_code, p_logo, p_start, p_end, 1, NOW(), NOW())
ON CONFLICT (project_code) DO UPDATE SET project_name = EXCLUDED.project_name, domain = EXCLUDED.domain,
logo_path = EXCLUDED.logo_path, updated_at = NOW() RETURNING *;
END; $$ LANGUAGE plpgsql;