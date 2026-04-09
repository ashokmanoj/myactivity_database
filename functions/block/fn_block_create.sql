-- Function: fn_block_create  |  Domain: block
CREATE OR REPLACE FUNCTION fn_block_create(p_name VARCHAR, p_district_id INT)
RETURNS SETOF block AS $$
BEGIN
  RETURN QUERY INSERT INTO block (block_name, district_id, is_active, created_at, updated_at)
  VALUES (p_name, p_district_id, 1, NOW(), NOW()) RETURNING *;
END;
$$ LANGUAGE plpgsql;