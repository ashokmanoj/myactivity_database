-- Function: fn_documentation_create  |  Domain: documentation
-- Idempotent on uuid (mobile offline-sync retry safe) — a resend with the
-- same uuid updates the existing report in place. A NULL uuid never conflicts,
-- so direct web submissions without one just insert. Returns the report id.
-- p_files = NULL leaves an existing report's attachments untouched.
SET search_path TO myactivity;

-- Pre-attach_feedback signature — dropped so it doesn't linger as an overload.
DROP FUNCTION IF EXISTS fn_documentation_create(INT, VARCHAR, INT, INT, INT, DATE, TEXT, VARCHAR, JSONB);

CREATE OR REPLACE FUNCTION fn_documentation_create(
  p_user_id         INT,
  p_uuid            VARCHAR,
  p_project_id      INT,
  p_institute_id    INT,
  p_report_type_id  INT,
  p_report_date     DATE,
  p_remarks         TEXT,
  p_hm_letter_image VARCHAR,
  p_attach_feedback VARCHAR,
  p_files           JSONB
)
RETURNS INT AS $$
DECLARE
  v_id INT;
BEGIN
  INSERT INTO documentation (
    uuid, user_id,
    project_id, project_name,
    institute_id, institution_name,
    report_type_id, report_type_name,
    report_date, remarks, hm_letter_image, attach_feedback
  ) VALUES (
    p_uuid, p_user_id,
    p_project_id,     (SELECT project_name     FROM project                   WHERE project_id   = p_project_id),
    p_institute_id,   (SELECT institution_name FROM institution               WHERE institute_id = p_institute_id),
    p_report_type_id, (SELECT report_type_name FROM documentation_report_type WHERE id           = p_report_type_id),
    COALESCE(p_report_date, CURRENT_DATE), p_remarks, p_hm_letter_image, p_attach_feedback
  )
  ON CONFLICT (uuid) DO UPDATE SET
    user_id          = EXCLUDED.user_id,
    project_id       = EXCLUDED.project_id,
    project_name     = EXCLUDED.project_name,
    institute_id     = EXCLUDED.institute_id,
    institution_name = EXCLUDED.institution_name,
    report_type_id   = EXCLUDED.report_type_id,
    report_type_name = EXCLUDED.report_type_name,
    report_date      = EXCLUDED.report_date,
    remarks          = EXCLUDED.remarks,
    hm_letter_image  = EXCLUDED.hm_letter_image,
    attach_feedback  = EXCLUDED.attach_feedback,
    is_active        = 1,
    updated_at       = NOW()
  RETURNING documentation.id INTO v_id;

  IF p_files IS NOT NULL THEN
    PERFORM fn_documentation_files_replace(v_id, p_files);
  END IF;

  RETURN v_id;
END;
$$ LANGUAGE plpgsql;
