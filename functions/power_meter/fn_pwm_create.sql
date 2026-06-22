-- Function: fn_pwm_create  |  Domain: power_meter
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pwm_create(
    p_uuid                VARCHAR,
    p_project_id          INT,
    p_institution_id      INT,
    p_user_id             INT,
    p_entry_type          VARCHAR  DEFAULT 'POWER_METER',
    p_meter_status        VARCHAR  DEFAULT NULL,
    p_meter_reading       VARCHAR  DEFAULT NULL,
    p_receipt_duration_id INT      DEFAULT NULL,
    p_comments            TEXT     DEFAULT NULL,
    p_image_path          VARCHAR  DEFAULT NULL,
    p_gps_lat             NUMERIC  DEFAULT NULL,
    p_gps_lng             NUMERIC  DEFAULT NULL
)
RETURNS SETOF power_meter AS $$
BEGIN
    RETURN QUERY
    INSERT INTO power_meter (
        uuid, project_id, institution_id, user_id,
        entry_type, meter_status, meter_reading, receipt_duration_id,
        comments, image_path, gps_lat, gps_lng, submitted_at, is_synced
    ) VALUES (
        p_uuid, p_project_id, p_institution_id, p_user_id,
        p_entry_type, p_meter_status, p_meter_reading, p_receipt_duration_id,
        p_comments, p_image_path, p_gps_lat, p_gps_lng, NOW(), 0
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
