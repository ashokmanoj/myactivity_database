-- Function: fn_pwm_get_by_id  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_get_by_id(
    p_meter_id INT
)
RETURNS TABLE(
    meter_id               INT,
    uuid                   VARCHAR,
    project_id             INT,
    project_name           VARCHAR,
    institution_id         INT,
    institution_name       VARCHAR,
    institute_code         VARCHAR,
    user_id                INT,
    full_name              VARCHAR,
    emp_code               VARCHAR,
    entry_type             VARCHAR,
    meter_status           VARCHAR,
    meter_reading          VARCHAR,
    receipt_duration_id    INT,
    receipt_duration_label VARCHAR,
    comments               TEXT,
    image_path             VARCHAR,
    gps_lat                NUMERIC,
    gps_lng                NUMERIC,
    submitted_at           TIMESTAMPTZ,
    created_at             TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pm.meter_id,
        pm.uuid,
        p.project_id,
        p.project_name,
        i.institute_id,
        i.institution_name,
        i.institute_code,
        u.user_id,
        u.full_name,
        u.emp_code,
        pm.entry_type,
        pm.meter_status,
        pm.meter_reading,
        pm.receipt_duration_id,
        rd.duration_label,
        pm.comments,
        pm.image_path,
        pm.gps_lat,
        pm.gps_lng,
        pm.submitted_at,
        pm.created_at
    FROM power_meter pm
    LEFT JOIN project                      p  ON p.project_id          = pm.project_id
    LEFT JOIN institution                  i  ON i.institute_id         = pm.institution_id
    LEFT JOIN user_tbl                     u  ON u.user_id              = pm.user_id
    LEFT JOIN power_meter_receipt_duration rd ON rd.duration_id         = pm.receipt_duration_id
    WHERE pm.meter_id = p_meter_id;
END;
$$ LANGUAGE plpgsql;
