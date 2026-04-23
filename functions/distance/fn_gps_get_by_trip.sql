SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_gps_get_by_trip(p_trip_id INT)
RETURNS SETOF gps_location
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM gps_location
    WHERE trip_id = p_trip_id
    ORDER BY timestamp ASC;
END;
$$ LANGUAGE plpgsql;
