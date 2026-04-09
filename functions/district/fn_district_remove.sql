-- Function: fn_district_remove  |  Domain: district
CREATE OR REPLACE FUNCTION fn_district_remove(p_id INT)
RETURNS SETOF district AS $$
BEGIN
  RETURN QUERY UPDATE district SET is_active = 0, updated_at = NOW() WHERE district_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;