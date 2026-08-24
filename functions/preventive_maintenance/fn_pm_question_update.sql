-- Function: fn_pm_question_update  |  Domain: preventive_maintenance
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_question_update(p_id INT, p_q_id VARCHAR, p_question TEXT, p_q_type VARCHAR, p_sort_order INT)
RETURNS SETOF pm_question AS $$ BEGIN
RETURN QUERY UPDATE pm_question SET
  q_id       = COALESCE(p_q_id, q_id),
  question   = COALESCE(p_question, question),
  q_type     = COALESCE(p_q_type, q_type),
  sort_order = COALESCE(p_sort_order, sort_order),
  updated_at = NOW()
WHERE question_id = p_id RETURNING *;
END; $$ LANGUAGE plpgsql;
