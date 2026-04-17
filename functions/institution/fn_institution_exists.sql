-- Function: fn_institution_exists  |  Domain: institution
CREATE OR REPLACE FUNCTION fn_institution_exists(p_id INT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS(SELECT 1 FROM institution WHERE institute_id = p_id AND is_active = 1);
END;
$$ LANGUAGE plpgsql;