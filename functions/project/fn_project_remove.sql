-- Function: fn_project_remove  |  Domain: project

CREATE OR REPLACE FUNCTION fn_project_remove(p_id INT)
RETURNS SETOF project AS $$ BEGIN
RETURN QUERY UPDATE project SET is_active = 0, updated_at = NOW() WHERE project_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;