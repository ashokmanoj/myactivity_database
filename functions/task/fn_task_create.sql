-- Function: fn_task_create  |  Domain: task
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_create(
    p_project_id      INT              DEFAULT NULL,
    p_category_id     INT              DEFAULT NULL,
    p_sub_category_id INT              DEFAULT NULL,
    p_designation     VARCHAR          DEFAULT NULL,
    p_district        VARCHAR          DEFAULT NULL,
    p_block           VARCHAR          DEFAULT NULL,
    p_priority        VARCHAR          DEFAULT 'Medium',
    p_executive_id    INT              DEFAULT NULL,
    p_institution_id  INT              DEFAULT NULL,
    p_start_date      DATE             DEFAULT NULL,
    p_end_date        DATE             DEFAULT NULL,
    p_interval_type   VARCHAR          DEFAULT NULL,
    p_interval_days   INT              DEFAULT NULL,
    p_remarks         TEXT             DEFAULT NULL,
    p_created_by      INT              DEFAULT NULL,
    p_gps_lat         DOUBLE PRECISION DEFAULT NULL,
    p_gps_lng         DOUBLE PRECISION DEFAULT NULL
)
RETURNS SETOF task_list AS $$
BEGIN
    RETURN QUERY
    INSERT INTO task_list (
        project_id, category_id, sub_category_id,
        designation, district, block,
        priority, executive_id, institution_id,
        start_date, end_date,
        interval_type, interval_days,
        remarks, status, created_by,
        gps_lat, gps_lng
    ) VALUES (
        p_project_id, p_category_id, p_sub_category_id,
        p_designation, p_district, p_block,
        p_priority, p_executive_id, p_institution_id,
        p_start_date, p_end_date,
        p_interval_type, p_interval_days,
        p_remarks, 'Pending', p_created_by,
        p_gps_lat, p_gps_lng
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
