-- Function: fn_district_create  |  Domain: district
CREATE OR REPLACE FUNCTION fn_district_create(p_name VARCHAR, p_state_code VARCHAR)
RETURNS SETOF district AS $$
BEGIN
  RETURN QUERY INSERT INTO district (district_name, state_code, is_active, created_at, updated_at)
  VALUES (p_name, p_state_code, 1, NOW(), NOW()) RETURNING *;
END;
$$ LANGUAGE plpgsql;