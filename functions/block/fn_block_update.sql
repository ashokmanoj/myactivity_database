-- Function: fn_block_update  |  Domain: block
CREATE OR REPLACE FUNCTION fn_block_update(p_id INT, p_name VARCHAR, p_district_id INT)
RETURNS SETOF block AS $$
BEGIN
  RETURN QUERY UPDATE block SET block_name = COALESCE(p_name, block_name),
  district_id = COALESCE(p_district_id, district_id), updated_at = NOW()
  WHERE block_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;