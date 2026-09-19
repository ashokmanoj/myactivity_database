-- DDL 073: Correct answer types for a handful of "Analytics-Powered AI
-- Interaction Virtual Classroom" (Sikkim) survey questions that were seeded
-- with the wrong q_type in 069. Editing 069's seed values only affects a
-- fresh install (its INSERT is ON CONFLICT (project_id, q_id) DO NOTHING —
-- it never touches an already-existing row), so any environment that
-- already ran 069 needs this explicit, idempotent UPDATE too.
SET search_path TO myactivity;

DO $$
DECLARE
  v_project_id INT;
BEGIN
  SELECT project_id INTO v_project_id FROM project WHERE project_name = 'Analytics-Powered AI Interaction Virtual Classroom';
  IF v_project_id IS NULL THEN
    RAISE EXCEPTION 'Project "Analytics-Powered AI Interaction Virtual Classroom" not found — create it first, then re-run this migration.';
  END IF;

  -- UDISE code, PIN code, Mobile number(s) — free text originally, now numeric input.
  UPDATE survey_question
  SET q_type_id = (SELECT type_id FROM survey_question_type WHERE type_name = 'number'),
      updated_at = NOW()
  WHERE project_id = v_project_id AND q_id IN ('UDISE', 'PIN', 'HOS_MOBILE', 'ICT_MOBILE');

  -- Latitude / Longitude — decimal coordinates, not plain text or integer.
  UPDATE survey_question
  SET q_type_id = (SELECT type_id FROM survey_question_type WHERE type_name = 'decimal'),
      updated_at = NOW()
  WHERE project_id = v_project_id AND q_id IN ('LATITUDE', 'LONGITUDE');

  -- Cable route distance, measured voltage, measured frequency — free text
  -- (site measurements aren't always clean integers/decimals), was 'number'.
  UPDATE survey_question
  SET q_type_id = (SELECT type_id FROM survey_question_type WHERE type_name = 'text'),
      updated_at = NOW()
  WHERE project_id = v_project_id AND q_id IN ('CABLE_ROUTE', 'VOLTAGE', 'FREQUENCY');
END $$;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','073_survey_sikkim_qtype_fixes.sql') ON CONFLICT DO NOTHING;
