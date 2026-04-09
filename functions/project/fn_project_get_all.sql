-- Function: fn_project_get_all  |  Domain: project

CREATE OR REPLACE FUNCTION fn_project_get_all(p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS SETOF project AS $$ BEGIN
RETURN QUERY SELECT * FROM project WHERE is_active = 1
  AND (p_from IS NULL OR created_at >= p_from)
  AND (p_to IS NULL OR created_at <= p_to);
END; $$ LANGUAGE plpgsql;