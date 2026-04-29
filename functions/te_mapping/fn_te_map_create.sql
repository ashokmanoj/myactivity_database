-- Function: fn_te_map_create  |  Domain: te_mapping
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_create(
    p_user_id      INT,
    p_institute_id INT,
    p_assigned_by  INT DEFAULT NULL
)
RETURNS TABLE(
    map_id       INT,
    user_id      INT,
    institute_id INT,
    assigned_by  INT,
    is_active    SMALLINT,
    created_at   TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    INSERT INTO tech_exec_institution_map (user_id, institute_id, assigned_by, is_active, created_at, updated_at)
    VALUES (p_user_id, p_institute_id, p_assigned_by, 1, NOW(), NOW())
    RETURNING
        tech_exec_institution_map.map_id,
        tech_exec_institution_map.user_id,
        tech_exec_institution_map.institute_id,
        tech_exec_institution_map.assigned_by,
        tech_exec_institution_map.is_active,
        tech_exec_institution_map.created_at;
END;
$$ LANGUAGE plpgsql;
