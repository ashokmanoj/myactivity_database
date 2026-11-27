-- Function: fn_yes_no_option_get_all  |  Domain: yes_no_option
-- Active Yes / No master options in display order — what the mobile app
-- offers for yes/no checks such as Class Run Status and VSAT Status.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_yes_no_option_get_all()
RETURNS TABLE (
  id          INT,
  option_name VARCHAR,
  sort_order  INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT o.id, o.option_name, o.sort_order
  FROM yes_no_option o
  WHERE o.is_active = 1
  ORDER BY o.sort_order, o.id;
END;
$$ LANGUAGE plpgsql;
