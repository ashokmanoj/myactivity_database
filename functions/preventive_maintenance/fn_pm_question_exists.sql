-- Function: fn_pm_question_exists  |  Domain: preventive_maintenance
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_question_exists(p_id INT)
RETURNS BOOLEAN AS $$ BEGIN
RETURN EXISTS(SELECT 1 FROM pm_question WHERE question_id = p_id AND is_active = TRUE);
END; $$ LANGUAGE plpgsql;
