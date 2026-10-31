-- Function: fn_location_type_get_all  |  Domain: location
-- Mobile "Add Location" Location Type dropdown.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_location_type_get_all()
RETURNS TABLE(
    location_type_id   INT,
    location_type_name VARCHAR,
    sort_order         INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.location_type_id,
        t.location_type_name,
        t.sort_order
    FROM location_type t
    WHERE t.is_active = 1
    ORDER BY t.sort_order ASC, t.location_type_name ASC;
END;
$$ LANGUAGE plpgsql;
