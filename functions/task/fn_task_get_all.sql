-- Function: fn_task_get_all  |  Domain: task
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_get_all(
    p_project_id      INT         DEFAULT NULL,
    p_category_id     INT         DEFAULT NULL,
    p_sub_category_id INT         DEFAULT NULL,
    p_priority        VARCHAR     DEFAULT NULL,
    p_status          VARCHAR     DEFAULT NULL,
    p_executive_id    INT         DEFAULT NULL,
    p_from            TIMESTAMPTZ DEFAULT NULL,
    p_to              TIMESTAMPTZ DEFAULT NULL
)
RETURNS TABLE(
    task_id              INT,
    project_id           INT,
    project_name         VARCHAR,
    category_id          INT,
    category_name        VARCHAR,
    sub_category_id      INT,
    sub_category_name    VARCHAR,
    designation          VARCHAR,
    district             VARCHAR,
    block                VARCHAR,
    priority             VARCHAR,
    executive_id         INT,
    executive_name       VARCHAR,
    emp_code             VARCHAR,
    institution_id       INT,
    institution_name     VARCHAR,
    institute_code       VARCHAR,
    institution_latitude  NUMERIC,
    institution_longitude NUMERIC,
    start_date           DATE,
    end_date             DATE,
    interval_type        VARCHAR,
    interval_days        INT,
    remarks              TEXT,
    status               VARCHAR,
    created_by           INT,
    created_at           TIMESTAMPTZ,
    gps_lat              DOUBLE PRECISION,
    gps_lng              DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.task_id,
        p.project_id,
        p.project_name,
        c.category_id,
        c.category_name,
        s.sub_category_id,
        s.sub_category_name,
        t.designation,
        t.district,
        t.block,
        t.priority,
        u.user_id,
        u.full_name,
        u.emp_code,
        i.institute_id,
        i.institution_name,
        i.institute_code,
        i.latitude,
        i.longitude,
        t.start_date,
        t.end_date,
        t.interval_type,
        t.interval_days,
        t.remarks,
        t.status,
        t.created_by,
        t.created_at,
        t.gps_lat,
        t.gps_lng
    FROM task_list t
    LEFT JOIN project           p ON p.project_id        = t.project_id
    LEFT JOIN task_category     c ON c.category_id       = t.category_id
    LEFT JOIN task_sub_category s ON s.sub_category_id   = t.sub_category_id
    LEFT JOIN user_tbl          u ON u.user_id            = t.executive_id
    LEFT JOIN institution       i ON i.institute_id       = t.institution_id
    WHERE (p_project_id      IS NULL OR t.project_id      = p_project_id)
      AND (p_category_id     IS NULL OR t.category_id     = p_category_id)
      AND (p_sub_category_id IS NULL OR t.sub_category_id = p_sub_category_id)
      AND (p_priority        IS NULL OR t.priority        = p_priority)
      AND (p_status          IS NULL OR t.status          = p_status)
      AND (p_executive_id    IS NULL OR t.executive_id    = p_executive_id)
      AND (p_from            IS NULL OR t.created_at     >= p_from)
      AND (p_to              IS NULL OR t.created_at     <= p_to)
    ORDER BY t.created_at DESC;
END;
$$ LANGUAGE plpgsql;
