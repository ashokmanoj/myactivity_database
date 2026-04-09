-- Function: fn_district_get_all  |  Domain: district
CREATE OR REPLACE FUNCTION fn_district_get_all(p_from TIMESTAMPTZ DEFAULT NULL, p_to TIMESTAMPTZ DEFAULT NULL)
RETURNS SETOF district AS $$
BEGIN
  RETURN QUERY SELECT * FROM district WHERE is_active = 1
    AND (p_from IS NULL OR created_at >= p_from)
    AND (p_to IS NULL OR created_at <= p_to);
END;
$$ LANGUAGE plpgsql;