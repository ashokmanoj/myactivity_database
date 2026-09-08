-- Function: fn_distance_rate_remove  |  Domain: distance
CREATE OR REPLACE FUNCTION fn_distance_rate_remove(p_id INT)
RETURNS SETOF distance_state_rate AS $$
BEGIN
  RETURN QUERY UPDATE distance_state_rate SET is_active = 0, updated_at = NOW() WHERE id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;
