-- Function: fn_project_get_by_id  |  Domain: project

CREATE OR REPLACE FUNCTION fn_project_get_by_id(p_id INT)
RETURNS SETOF project AS $$ BEGIN
RETURN QUERY SELECT * FROM project WHERE project_id = p_id AND is_active = 1;
END; $$ LANGUAGE plpgsql;