SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_gps_create(
    p_uuid      VARCHAR,
    p_trip_id   INT,
    p_lat       NUMERIC,
    p_lon       NUMERIC,
    p_alt       NUMERIC,
    p_timestamp BIGINT,
    p_user_id   INT DEFAULT NULL
)
RETURNS SETOF gps_location
AS $$
BEGIN
    IF p_uuid IS NOT NULL AND EXISTS (
        SELECT 1 FROM gps_location WHERE uuid = p_uuid
    ) THEN
        RETURN QUERY SELECT * FROM gps_location WHERE uuid = p_uuid;
        RETURN;
    END IF;

    RETURN QUERY
    INSERT INTO gps_location (uuid, trip_id, user_id, latitude, longitude, altitude, timestamp)
    VALUES (p_uuid, p_trip_id, p_user_id, p_lat, p_lon, p_alt, p_timestamp)
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
