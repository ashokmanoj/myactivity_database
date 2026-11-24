-- Function: fn_distance_rate_update  |  Domain: distance
-- A new rate applies from now on: trips of that state still in progress pick it
-- up (so they end on it), while trips that already ended keep the rate they
-- were paid at. 'Others' trips are skipped — their amount is the leg total.
CREATE OR REPLACE FUNCTION fn_distance_rate_update(p_id INT, p_state VARCHAR, p_rate_per_km NUMERIC)
RETURNS SETOF distance_state_rate AS $$
DECLARE
  v_row distance_state_rate;
BEGIN
  UPDATE distance_state_rate SET
    state       = COALESCE(p_state, state),
    rate_per_km = COALESCE(p_rate_per_km, rate_per_km),
    updated_at  = NOW()
  WHERE id = p_id RETURNING * INTO v_row;
  IF NOT FOUND THEN RETURN; END IF;

  IF v_row.is_active = 1 THEN
    UPDATE distance_tracking dt SET
      rate_per_km = v_row.rate_per_km,
      updated_at  = NOW()
    WHERE LOWER(dt.state) = LOWER(v_row.state)
      AND dt.end_distance_timestamp IS NULL
      AND dt.vehicle_type IS DISTINCT FROM 'Others';
  END IF;

  RETURN NEXT v_row;
END;
$$ LANGUAGE plpgsql;
