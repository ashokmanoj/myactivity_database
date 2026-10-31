-- Function: fn_documentation_update  |  Domain: documentation
-- Partial update — NULL params leave that column unchanged. Changing a
-- project/institution/report type also refreshes its snapshotted name.
-- A non-NULL p_files replaces the whole attachment list (send [] to clear it).
SET search_path TO myactivity;

-- Pre-attach_feedback signature — dropped so it doesn't linger as an overload.
DROP FUNCTION IF EXISTS fn_documentation_update(INT, INT, INT, INT, DATE, TEXT, VARCHAR, SMALLINT, JSONB);

CREATE OR REPLACE FUNCTION fn_documentation_update(
  p_id              INT,
  p_project_id      INT      DEFAULT NULL,
  p_institute_id    INT      DEFAULT NULL,
  p_report_type_id  INT      DEFAULT NULL,
  p_report_date     DATE     DEFAULT NULL,
  p_remarks         TEXT     DEFAULT NULL,
  p_hm_letter_image VARCHAR  DEFAULT NULL,
  p_attach_feedback VARCHAR  DEFAULT NULL,
  p_is_active       SMALLINT DEFAULT NULL,
  p_files           JSONB    DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  UPDATE documentation d SET
    project_id       = COALESCE(p_project_id, d.project_id),
    project_name     = COALESCE((SELECT project_name FROM project WHERE project_id = p_project_id), d.project_name),
    institute_id     = COALESCE(p_institute_id, d.institute_id),
    institution_name = COALESCE((SELECT institution_name FROM institution WHERE institute_id = p_institute_id), d.institution_name),
    report_type_id   = COALESCE(p_report_type_id, d.report_type_id),
    report_type_name = COALESCE((SELECT report_type_name FROM documentation_report_type WHERE id = p_report_type_id), d.report_type_name),
    report_date      = COALESCE(p_report_date, d.report_date),
    remarks          = COALESCE(p_remarks, d.remarks),
    hm_letter_image  = COALESCE(p_hm_letter_image, d.hm_letter_image),
    attach_feedback  = COALESCE(p_attach_feedback, d.attach_feedback),
    is_active        = COALESCE(p_is_active, d.is_active),
    updated_at       = NOW()
  WHERE d.id = p_id;

  IF p_files IS NOT NULL THEN
    PERFORM fn_documentation_files_replace(p_id, p_files);
  END IF;
END;
$$ LANGUAGE plpgsql;
