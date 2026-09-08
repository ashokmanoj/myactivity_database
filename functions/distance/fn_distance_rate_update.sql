-- Function: fn_distance_rate_update  |  Domain: distance
CREATE OR REPLACE FUNCTION fn_distance_rate_update(p_id INT, p_state VARCHAR, p_rate_per_km NUMERIC)
RETURNS SETOF distance_state_rate AS $$
BEGIN
  RETURN QUERY UPDATE distance_state_rate SET
    state       = COALESCE(p_state, state),
    rate_per_km = COALESCE(p_rate_per_km, rate_per_km),
    updated_at  = NOW()
  WHERE id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;
