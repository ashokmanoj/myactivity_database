-- Function: fn_location_get_project_institutions  |  Domain: location
-- Mobile "Add Location" Institution dropdown — active institutions belonging
-- to the selected project (institution.project_id or institution_project_map).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_location_get_project_institutions(
    p_project_id INT
)
RETURNS TABLE(
    institute_id     INT,
    institution_name VARCHAR,
    institute_code   VARCHAR,
    latitude         NUMERIC,
    longitude        NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        i.institute_id,
        i.institution_name,
        i.institute_code,
        i.latitude,
        i.longitude
    FROM institution i
    WHERE i.is_active = 1
      AND (i.project_id = p_project_id
           OR EXISTS (
               SELECT 1 FROM institution_project_map m
               WHERE m.institute_id = i.institute_id
                 AND m.project_id   = p_project_id
                 AND m.is_active    = 1
           ))
    ORDER BY i.institution_name ASC;
END;
$$ LANGUAGE plpgsql;
