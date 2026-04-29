-- Function: fn_te_map_deactivate  |  Domain: te_mapping
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_deactivate(p_map_id INT)
RETURNS SETOF tech_exec_institution_map AS $$
BEGIN
    RETURN QUERY
    UPDATE tech_exec_institution_map
    SET    is_active = 0, updated_at = NOW()
    WHERE  map_id = p_map_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
