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
    -- Atomic upsert: INSERT and silently ignore duplicate uuid.
    -- Replaces the old EXISTS-then-INSERT pattern which had a race condition
    -- when two requests arrived simultaneously with the same uuid.
    INSERT INTO gps_location (uuid, trip_id, user_id, latitude, longitude, altitude, timestamp)
    VALUES (p_uuid, p_trip_id, p_user_id, p_lat, p_lon, p_alt, p_timestamp)
    ON CONFLICT (uuid) DO NOTHING;

    -- Always return the row (new or pre-existing) so the caller gets a consistent response.
    IF p_uuid IS NOT NULL THEN
        RETURN QUERY SELECT * FROM gps_location WHERE uuid = p_uuid;
    END IF;
END;
$$ LANGUAGE plpgsql;
