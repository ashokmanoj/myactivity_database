-- Function: fn_designation_sync  |  Domain: designation

CREATE OR REPLACE FUNCTION fn_designation_sync(p_name VARCHAR, p_project_id INT)
RETURNS SETOF designation AS $$ BEGIN
RETURN QUERY INSERT INTO designation (designation, project_id, is_active, created_at, updated_at)
VALUES (p_name, p_project_id, 1, NOW(), NOW())
ON CONFLICT (designation) DO UPDATE SET project_id = EXCLUDED.project_id, updated_at = NOW() RETURNING *;
END; $$ LANGUAGE plpgsql;