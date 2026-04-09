-- Function: fn_block_get_all  |  Domain: block
CREATE OR REPLACE FUNCTION fn_block_get_all(p_district_id INT DEFAULT NULL, p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS TABLE(block_id INT, block_name VARCHAR, district_id INT, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ, district_name VARCHAR) AS $$
BEGIN
  RETURN QUERY SELECT b.block_id, b.block_name, b.district_id, b.is_active, b.created_at, b.updated_at, d.district_name
  FROM block b JOIN district d ON d.district_id = b.district_id
  WHERE b.is_active = 1
    AND (p_district_id IS NULL OR b.district_id = p_district_id)
    AND (p_from IS NULL OR b.created_at >= p_from)
    AND (p_to IS NULL OR b.created_at <= p_to);
END;
$$ LANGUAGE plpgsql;