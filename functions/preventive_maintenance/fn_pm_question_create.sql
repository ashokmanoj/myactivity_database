-- Function: fn_pm_question_create  |  Domain: preventive_maintenance
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_question_create(p_q_id VARCHAR, p_question TEXT, p_q_type VARCHAR, p_sort_order INT)
RETURNS SETOF pm_question AS $$ BEGIN
RETURN QUERY INSERT INTO pm_question (q_id, question, q_type, sort_order, is_active, created_at, updated_at)
VALUES (p_q_id, p_question, COALESCE(p_q_type, 'yesNo'), COALESCE(p_sort_order, 0), TRUE, NOW(), NOW())
RETURNING *;
END; $$ LANGUAGE plpgsql;
