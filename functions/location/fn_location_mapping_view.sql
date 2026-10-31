-- Function: fn_location_mapping_view  |  Domain: location
-- One row per mobile "Add Location" submission. When the submission is linked
-- to an institution (e.g. a School), the institution's master lat/lon is
-- returned alongside the mobile GPS lat/lon plus the distance between them in
-- metres. Other submissions (Home, etc.) come back with the institution
-- columns NULL — the UI just shows what the user sent.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_location_mapping_view(
    p_project_id      INT         DEFAULT NULL,
    p_district_id     INT         DEFAULT NULL,
    p_block_id        INT         DEFAULT NULL,
    p_institution_id  INT         DEFAULT NULL,
    p_location_type   VARCHAR     DEFAULT NULL,
    p_institute_code  VARCHAR     DEFAULT NULL,
    p_from            TIMESTAMPTZ DEFAULT NULL,
    p_to              TIMESTAMPTZ DEFAULT NULL
)
RETURNS TABLE(
    location_id       INT,
    user_id           INT,
    location_name     VARCHAR,
    location_type     VARCHAR,
    gps_latitude      NUMERIC,
    gps_longitude     NUMERIC,
    geo_address       VARCHAR,
    geo_pincode       VARCHAR,
    description       VARCHAR,
    sync_date         TIMESTAMPTZ,
    executive_name    VARCHAR,
    emp_code          VARCHAR,
    executive_mobile  VARCHAR,
    institute_id      INT,
    institution_name  VARCHAR,
    institute_code    VARCHAR,
    project_name      VARCHAR,
    district_name     VARCHAR,
    block_name        VARCHAR,
    pincode           INT,
    address           VARCHAR,
    db_latitude       NUMERIC,
    db_longitude      NUMERIC,
    db_updated_at     TIMESTAMPTZ,
    meter             NUMERIC,
    is_verified       SMALLINT,
    verified_at       TIMESTAMPTZ
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        l.location_id,
        l.user_id,
        l.location_name,
        l.location_type,
        l.lat                                                   AS gps_latitude,
        l.lon                                                   AS gps_longitude,
        l.geo_address,
        l.geo_pincode,
        l.description,
        l.created_at                                            AS sync_date,
        u.full_name                                             AS executive_name,
        u.emp_code,
        u.mobile_number                                         AS executive_mobile,
        i.institute_id,
        COALESCE(i.institution_name, l.institution_name)::VARCHAR,
        i.institute_code,
        COALESCE(p.project_name, l.project_name)::VARCHAR,
        d.district_name,
        b.block_name,
        i.pincode,
        i.address,
        i.latitude                                              AS db_latitude,
        i.longitude                                             AS db_longitude,
        i.updated_at                                            AS db_updated_at,
        CASE
            WHEN i.latitude IS NOT NULL AND i.longitude IS NOT NULL
             AND l.lat      IS NOT NULL AND l.lon       IS NOT NULL
            THEN ROUND((
                6371000 * 2 * ASIN(SQRT(
                    POWER(SIN(RADIANS((l.lat::FLOAT - i.latitude::FLOAT)  / 2.0)), 2) +
                    COS(RADIANS(i.latitude::FLOAT)) * COS(RADIANS(l.lat::FLOAT)) *
                    POWER(SIN(RADIANS((l.lon::FLOAT - i.longitude::FLOAT) / 2.0)), 2)
                ))
            )::NUMERIC, 3)
            ELSE NULL
        END                                                     AS meter,
        COALESCE(i.is_verified, 0)::SMALLINT                    AS is_verified,
        i.verified_at
    FROM locations l
    JOIN      user_tbl    u ON u.user_id      = l.user_id
    LEFT JOIN institution i ON i.institute_id = l.institution_id
    LEFT JOIN project     p ON p.project_id   = COALESCE(l.project_id, i.project_id)
    LEFT JOIN district    d ON d.district_id  = i.district_id
    LEFT JOIN block       b ON b.block_id     = i.block_id
    WHERE l.is_active = 1
      AND (p_project_id     IS NULL OR p.project_id     = p_project_id)
      AND (p_district_id    IS NULL OR i.district_id    = p_district_id)
      AND (p_block_id       IS NULL OR i.block_id       = p_block_id)
      AND (p_institution_id IS NULL OR i.institute_id   = p_institution_id)
      AND (p_location_type  IS NULL OR l.location_type  ILIKE p_location_type)
      AND (p_institute_code IS NULL OR i.institute_code ILIKE '%' || p_institute_code || '%')
      AND (p_from           IS NULL OR l.created_at    >= p_from)
      AND (p_to             IS NULL OR l.created_at    <= p_to)
    ORDER BY l.created_at DESC;
END;
$$;
