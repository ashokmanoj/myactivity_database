-- Function: fn_project_update  |  Domain: project

CREATE OR REPLACE FUNCTION fn_project_update(p_id INT, p_name VARCHAR, p_domain VARCHAR, p_code VARCHAR, p_logo VARCHAR, p_start DATE, p_end DATE)
RETURNS SETOF project AS $$ BEGIN
RETURN QUERY UPDATE project SET project_name = COALESCE(p_name, project_name), domain = COALESCE(p_domain, domain),
project_code = COALESCE(p_code, project_code), logo_path = COALESCE(p_logo, logo_path),
start_date = COALESCE(p_start, start_date), end_date = COALESCE(p_end, end_date), updated_at = NOW()
WHERE project_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;