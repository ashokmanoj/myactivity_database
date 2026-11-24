-- Function: fn_distance_rate_create  |  Domain: distance
-- In-progress trips of the new state (started on the 3.00 default) pick the
-- rate up; ended trips keep theirs — see fn_distance_rate_update.
CREATE OR REPLACE FUNCTION fn_distance_rate_create(p_state VARCHAR, p_rate_per_km NUMERIC)
RETURNS SETOF distance_state_rate AS $$
DECLARE
  v_row distance_state_rate;
BEGIN
  INSERT INTO distance_state_rate (state, rate_per_km, is_active, created_at, updated_at)
  VALUES (p_state, p_rate_per_km, 1, NOW(), NOW()) RETURNING * INTO v_row;

  UPDATE distance_tracking dt SET
    rate_per_km = v_row.rate_per_km,
    updated_at  = NOW()
  WHERE LOWER(dt.state) = LOWER(v_row.state)
    AND dt.end_distance_timestamp IS NULL
    AND dt.vehicle_type IS DISTINCT FROM 'Others';

  RETURN NEXT v_row;
END;
$$ LANGUAGE plpgsql;
