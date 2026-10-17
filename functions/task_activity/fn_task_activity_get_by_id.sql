-- Function: fn_task_activity_get_by_id  |  Domain: task_activity
-- Single-activity counterpart to fn_task_activity_get_all — same joins,
-- filtered to one id. Used to return the full joined row after create/update
-- instead of the bare task_activity row.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_activity_get_by_id(p_id INT)
RETURNS TABLE(
    id                INT,
    uuid              VARCHAR,
    visit_uuid        VARCHAR,
    project_name      VARCHAR,
    institution_name  VARCHAR,
    institute_code    VARCHAR,
    institution_lat   NUMERIC,
    institution_lng   NUMERIC,
    user_id           INT,
    full_name         VARCHAR,
    emp_code          VARCHAR,
    mobile_number     VARCHAR,
    task_id           INT,
    category_name     VARCHAR,
    sub_category_name VARCHAR,
    task_priority     VARCHAR,
    task_district     VARCHAR,
    task_start_date   DATE,
    remarks           TEXT,
    status_id         INT,
    status_name       VARCHAR,
    is_active         SMALLINT,
    activity_start_at TIMESTAMPTZ,
    activity_end_at   TIMESTAMPTZ,
    images            JSON,
    created_at        TIMESTAMPTZ,
    updated_at        TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ta.id, ta.uuid, ta.visit_uuid,
        p.project_name, i.institution_name, i.institute_code, i.latitude, i.longitude,
        u.user_id, u.full_name, u.emp_code, u.mobile_number,
        t.task_id, tc.category_name, tsc.sub_category_name, t.priority, t.district, t.start_date,
        ta.remarks, ast.id, ast.status_name,
        ta.is_active, ta.activity_start_at, ta.activity_end_at,
        COALESCE(
            (SELECT json_agg(img.fullpath_url ORDER BY img.sort_order)
             FROM task_activity_images img WHERE img.task_activity_id = ta.id),
            '[]'::json
        ),
        ta.created_at, ta.updated_at
    FROM task_activity ta
    LEFT JOIN visit_details    v   ON v.uuid               = ta.visit_uuid
    LEFT JOIN project          p   ON p.project_id         = v.project_id
    LEFT JOIN institution      i   ON i.institute_id        = v.institution_id
    LEFT JOIN user_tbl         u   ON u.user_id             = v.user_id
    LEFT JOIN assign_task_list t   ON t.task_id             = ta.task_id
    LEFT JOIN task_category    tc  ON tc.category_id        = t.category_id
    LEFT JOIN task_sub_category tsc ON tsc.sub_category_id  = t.sub_category_id
    LEFT JOIN activity_status  ast ON ast.id                = ta.status_id
    WHERE ta.id = p_id;
END;
$$ LANGUAGE plpgsql;
