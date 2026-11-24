-- Function: fn_distance_rate_remove  |  Domain: distance
-- In-progress trips of that state fall back to the 3.00 default (what they'd
-- get on ending anyway); ended trips keep theirs — see fn_distance_rate_update.
CREATE OR REPLACE FUNCTION fn_distance_rate_remove(p_id INT)
RETURNS SETOF distance_state_rate AS $$
DECLARE
  v_row distance_state_rate;
BEGIN
  UPDATE distance_state_rate SET is_active = 0, updated_at = NOW()
  WHERE id = p_id RETURNING * INTO v_row;
  IF NOT FOUND THEN RETURN; END IF;

  UPDATE distance_tracking dt SET
    rate_per_km = 3.00,
    updated_at  = NOW()
  WHERE LOWER(dt.state) = LOWER(v_row.state)
    AND dt.end_distance_timestamp IS NULL
    AND dt.vehicle_type IS DISTINCT FROM 'Others';

  RETURN NEXT v_row;
END;
$$ LANGUAGE plpgsql;
