-- Function: fn_block_get_by_id  |  Domain: block
CREATE OR REPLACE FUNCTION fn_block_get_by_id(p_id INT)
RETURNS TABLE(block_id INT, block_name VARCHAR, district_id INT, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ, district_name VARCHAR) AS $$
BEGIN
  RETURN QUERY SELECT b.block_id, b.block_name, b.district_id, b.is_active, b.created_at, b.updated_at, d.district_name
  FROM block b JOIN district d ON d.district_id = b.district_id
  WHERE b.block_id = p_id AND b.is_active = 1;
END;
$$ LANGUAGE plpgsql;