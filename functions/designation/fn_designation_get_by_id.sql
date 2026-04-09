-- Function: fn_designation_get_by_id  |  Domain: designation

CREATE OR REPLACE FUNCTION fn_designation_get_by_id(p_id INT)
RETURNS TABLE(designation_id INT, designation VARCHAR, project_id INT, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ, project_name VARCHAR) AS $$ BEGIN
RETURN QUERY SELECT d.designation_id, d.designation, d.project_id, d.is_active, d.created_at, d.updated_at, p.project_name
FROM designation d LEFT JOIN project p ON p.project_id = d.project_id
WHERE d.designation_id = p_id AND d.is_active = 1;
END; $$ LANGUAGE plpgsql;