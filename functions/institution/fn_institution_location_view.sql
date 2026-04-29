SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_institution_location_view(
    p_project_id      INT     DEFAULT NULL,
    p_district_id     INT     DEFAULT NULL,
    p_block_id        INT     DEFAULT NULL,
    p_location_type   VARCHAR DEFAULT NULL,
    p_institute_code  VARCHAR DEFAULT NULL,
    p_institution_id  INT     DEFAULT NULL
)
RETURNS TABLE(
    institute_id      INT,
    project_name      VARCHAR,
    district_name     VARCHAR,
    block_name        VARCHAR,
    institution_name  VARCHAR,
    institute_code    VARCHAR,
    pincode           INT,
    address           VARCHAR,
    db_latitude       NUMERIC,
    db_longitude      NUMERIC,
    db_updated_at     TIMESTAMPTZ,
    location_type     VARCHAR,
    meter             NUMERIC,
    gps_latitude      NUMERIC,
    gps_longitude     NUMERIC,
    sync_date         TIMESTAMPTZ,
    executive_name    VARCHAR,
    executive_mobile  VARCHAR,
    is_verified       SMALLINT,
    verified_at       TIMESTAMPTZ,
    verified_by_name  VARCHAR,
    location_id       INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH latest_loc AS (
        SELECT DISTINCT ON (l.institution_id)
            l.location_id,
            l.institution_id,
            l.location_type,
            l.lat,
            l.lon,
            l.created_at     AS sync_date,
            u.full_name      AS executive_name,
            u.mobile_number  AS executive_mobile
        FROM locations l
        JOIN user_tbl u ON u.user_id = l.user_id
        WHERE l.is_active = 1
          AND l.institution_id IS NOT NULL
        ORDER BY l.institution_id, l.created_at DESC
    )
    SELECT
        i.institute_id,
        COALESCE(p.project_name, '—')::VARCHAR,
        COALESCE(d.district_name, '—')::VARCHAR,
        COALESCE(b.block_name, '—')::VARCHAR,
        i.institution_name,
        i.institute_code,
        i.pincode,
        i.address,
        i.latitude                                              AS db_latitude,
        i.longitude                                             AS db_longitude,
        i.updated_at                                            AS db_updated_at,
        ll.location_type,
        CASE
            WHEN i.latitude  IS NOT NULL AND i.longitude  IS NOT NULL
             AND ll.lat      IS NOT NULL AND ll.lon       IS NOT NULL
            THEN ROUND((
                6371000 * 2 * ASIN(SQRT(
                    POWER(SIN(RADIANS((ll.lat::FLOAT  - i.latitude::FLOAT)  / 2.0)), 2) +
                    COS(RADIANS(i.latitude::FLOAT)) * COS(RADIANS(ll.lat::FLOAT)) *
                    POWER(SIN(RADIANS((ll.lon::FLOAT  - i.longitude::FLOAT) / 2.0)), 2)
                ))
            )::NUMERIC, 3)
            ELSE NULL
        END                                                     AS meter,
        ll.lat                                                  AS gps_latitude,
        ll.lon                                                  AS gps_longitude,
        ll.sync_date,
        ll.executive_name,
        ll.executive_mobile,
        COALESCE(i.is_verified, 0)::SMALLINT                    AS is_verified,
        i.verified_at,
        vbu.full_name::VARCHAR                                  AS verified_by_name,
        ll.location_id
    FROM institution i
    LEFT JOIN project   p   ON p.project_id  = i.project_id
    LEFT JOIN district  d   ON d.district_id = i.district_id
    LEFT JOIN block     b   ON b.block_id    = i.block_id
    LEFT JOIN latest_loc ll ON ll.institution_id = i.institute_id
    LEFT JOIN user_tbl  vbu ON vbu.user_id   = i.verified_by
    WHERE i.is_active = 1
      AND (p_project_id     IS NULL OR i.project_id    = p_project_id)
      AND (p_district_id    IS NULL OR i.district_id   = p_district_id)
      AND (p_block_id       IS NULL OR i.block_id      = p_block_id)
      AND (p_location_type  IS NULL OR ll.location_type ILIKE p_location_type)
      AND (p_institute_code IS NULL OR i.institute_code ILIKE '%' || p_institute_code || '%')
      AND (p_institution_id IS NULL OR i.institute_id  = p_institution_id)
    ORDER BY p.project_name NULLS LAST, d.district_name NULLS LAST, i.institution_name;
END;
$$;
