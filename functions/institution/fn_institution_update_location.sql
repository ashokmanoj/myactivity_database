-- Function: fn_institution_update_location  |  Domain: institution
-- Overwrites an institution's master lat/lon (used by All Location Mapping's
-- Update button to accept the mobile-submitted GPS point, optionally edited).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_institution_update_location(
    p_institute_id  INT,
    p_latitude      NUMERIC,
    p_longitude     NUMERIC
)
RETURNS TABLE(institute_id INT, latitude NUMERIC, longitude NUMERIC, updated_at TIMESTAMPTZ)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    UPDATE institution i
    SET
        latitude   = p_latitude,
        longitude  = p_longitude,
        updated_at = NOW()
    WHERE i.institute_id = p_institute_id
    RETURNING i.institute_id, i.latitude, i.longitude, i.updated_at;
END;
$$;
