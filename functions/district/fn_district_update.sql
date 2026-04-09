-- Function: fn_district_update  |  Domain: district
CREATE OR REPLACE FUNCTION fn_district_update(p_id INT, p_name VARCHAR, p_state_code VARCHAR)
RETURNS SETOF district AS $$
BEGIN
  RETURN QUERY UPDATE district SET district_name = COALESCE(p_name, district_name),
  state_code = COALESCE(p_state_code, state_code), updated_at = NOW()
  WHERE district_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;