-- Function: fn_pm_question_remove  |  Domain: preventive_maintenance
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_question_remove(p_id INT)
RETURNS SETOF pm_question AS $$ BEGIN
RETURN QUERY UPDATE pm_question SET is_active = FALSE, updated_at = NOW() WHERE question_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
