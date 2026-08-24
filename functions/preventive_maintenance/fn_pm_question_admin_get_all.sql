-- Function: fn_pm_question_admin_get_all  |  Domain: preventive_maintenance
-- Admin CRUD listing (all rows, not just active) — distinct from fn_pm_question_get_all
-- which the mobile PM form uses and must keep returning only active rows.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_question_admin_get_all()
RETURNS TABLE(question_id INT, q_id VARCHAR, question TEXT, q_type VARCHAR, sort_order INT, is_active BOOLEAN) AS $$
BEGIN
  RETURN QUERY
  SELECT q.question_id, q.q_id, q.question, q.q_type, q.sort_order, q.is_active
  FROM pm_question q
  ORDER BY q.sort_order ASC;
END;
$$ LANGUAGE plpgsql;
