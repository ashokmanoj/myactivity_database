-- Function: fn_district_get_by_id  |  Domain: district
CREATE OR REPLACE FUNCTION fn_district_get_by_id(p_id INT)
RETURNS TABLE(district_id INT, district_name VARCHAR, state_code VARCHAR, is_active SMALLINT, created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ, blocks JSON) AS $$
BEGIN
  RETURN QUERY
  SELECT d.district_id, d.district_name, d.state_code, d.is_active, d.created_at, d.updated_at,
         COALESCE(json_agg(b.*) FILTER (WHERE b.block_id IS NOT NULL AND b.is_active = 1), '[]'::json) AS blocks
  FROM district d
  LEFT JOIN block b ON b.district_id = d.district_id AND b.is_active = 1
  WHERE d.district_id = p_id AND d.is_active = 1
  GROUP BY d.district_id;
END;
$$ LANGUAGE plpgsql;