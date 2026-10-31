-- Function: fn_documentation_exists  |  Domain: documentation
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_exists(p_id INT)
RETURNS BOOLEAN AS $$
DECLARE v_exists BOOLEAN;
BEGIN
  SELECT EXISTS (SELECT 1 FROM documentation WHERE id = p_id) INTO v_exists;
  RETURN v_exists;
END;
$$ LANGUAGE plpgsql;
