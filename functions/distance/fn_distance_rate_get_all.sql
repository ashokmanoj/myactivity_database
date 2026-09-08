-- Function: fn_distance_rate_get_all  |  Domain: distance
CREATE OR REPLACE FUNCTION fn_distance_rate_get_all()
RETURNS SETOF distance_state_rate AS $$
BEGIN
  RETURN QUERY SELECT * FROM distance_state_rate WHERE is_active = 1 ORDER BY state;
END;
$$ LANGUAGE plpgsql;
