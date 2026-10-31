-- Function: fn_documentation_get_by_id  |  Domain: documentation
-- Same row shape as fn_documentation_get_all; returns inactive rows too.
SET search_path TO myactivity;

-- Return columns change over time (attach_feedback added) — CREATE OR REPLACE
-- can't change a return type, so drop first.
DROP FUNCTION IF EXISTS fn_documentation_get_by_id(INT);

CREATE OR REPLACE FUNCTION fn_documentation_get_by_id(p_id INT)
RETURNS TABLE (
  id               INT,
  uuid             VARCHAR,
  user_id          INT,
  full_name        VARCHAR,
  emp_code         VARCHAR,
  project_id       INT,
  project_name     VARCHAR,
  state            VARCHAR,
  institute_id     INT,
  institution_name VARCHAR,
  report_type_id   INT,
  report_type_name VARCHAR,
  report_date      TEXT, -- 'YYYY-MM-DD', same as fn_expense_get_all (avoids a timezone shift in node-pg)
  remarks          TEXT,
  hm_letter_image  VARCHAR,
  attach_feedback  VARCHAR,
  files            JSONB,
  is_active        SMALLINT,
  created_at       TIMESTAMPTZ,
  updated_at       TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    d.id, d.uuid, d.user_id, u.full_name, u.emp_code,
    d.project_id, d.project_name, p.state,
    d.institute_id, d.institution_name,
    d.report_type_id, d.report_type_name,
    TO_CHAR(d.report_date, 'YYYY-MM-DD'), d.remarks, d.hm_letter_image, d.attach_feedback,
    COALESCE(
      (SELECT JSONB_AGG(JSONB_BUILD_OBJECT(
                'id', f.id, 'file_type', f.file_type,
                'file_name', f.file_name, 'fullpath_url', f.fullpath_url
              ) ORDER BY f.sort_order, f.id)
       FROM documentation_files f
       WHERE f.documentation_id = d.id AND f.is_active = 1),
      '[]'::JSONB
    ),
    d.is_active, d.created_at, d.updated_at
  FROM documentation d
  LEFT JOIN user_tbl u ON u.user_id    = d.user_id
  LEFT JOIN project  p ON p.project_id = d.project_id
  WHERE d.id = p_id;
END;
$$ LANGUAGE plpgsql;
