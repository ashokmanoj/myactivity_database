-- Function: fn_distance_rate_create  |  Domain: distance
CREATE OR REPLACE FUNCTION fn_distance_rate_create(p_state VARCHAR, p_rate_per_km NUMERIC)
RETURNS SETOF distance_state_rate AS $$
BEGIN
  RETURN QUERY INSERT INTO distance_state_rate (state, rate_per_km, is_active, created_at, updated_at)
  VALUES (p_state, p_rate_per_km, 1, NOW(), NOW()) RETURNING *;
END;
$$ LANGUAGE plpgsql;
