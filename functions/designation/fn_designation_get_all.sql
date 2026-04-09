-- Function: fn_designation_get_all  |  Domain: designation

CREATE OR REPLACE FUNCTION fn_designation_get_all(p_project_id INT DEFAULT NULL, p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS TABLE(designation_id INT, designation VARCHAR, project_id INT, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ, project_name VARCHAR) AS $$ BEGIN
RETURN QUERY SELECT d.designation_id, d.designation, d.project_id, d.is_active, d.created_at, d.updated_at, p.project_name
FROM designation d LEFT JOIN project p ON p.project_id = d.project_id
WHERE d.is_active = 1
  AND (p_project_id IS NULL OR d.project_id = p_project_id)
  AND (p_from IS NULL OR d.created_at >= p_from)
  AND (p_to IS NULL OR d.created_at <= p_to);
END; $$ LANGUAGE plpgsql;
