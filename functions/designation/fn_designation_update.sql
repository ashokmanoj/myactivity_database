-- Function: fn_designation_update  |  Domain: designation

CREATE OR REPLACE FUNCTION fn_designation_update(p_id INT, p_name VARCHAR, p_project_id INT)
RETURNS SETOF designation AS $$ BEGIN
RETURN QUERY UPDATE designation SET designation = p_name, project_id = p_project_id, updated_at = NOW()
WHERE designation_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;