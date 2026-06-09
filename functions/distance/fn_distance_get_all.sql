SET search_path TO myactivity;

DROP FUNCTION IF EXISTS fn_distance_get_all(INT, INT, INT, INT, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_get_all(INT, INT, INT, INT, VARCHAR, VARCHAR, VARCHAR, DATE, DATE);
DROP FUNCTION IF EXISTS fn_distance_get_all(INT, INT, INT, INT, VARCHAR, VARCHAR);

CREATE OR REPLACE FUNCTION fn_distance_get_all(
    p_page       INT     DEFAULT 1,
    p_page_size  INT     DEFAULT 10,
    p_user_id    INT     DEFAULT NULL,
    p_rm_user_id INT     DEFAULT NULL,
    p_state      VARCHAR DEFAULT NULL,
    p_status     VARCHAR DEFAULT NULL,
    p_role       VARCHAR DEFAULT NULL,  -- current user's distance role for unread count
    p_start_date DATE    DEFAULT NULL,  -- filter: trip start date (inclusive, IST)
    p_end_date   DATE    DEFAULT NULL   -- filter: trip end date (inclusive, IST)
)
RETURNS TABLE (
    id                       INT,
    user_id                  INT,
    executive_name           VARCHAR,
    rm_user_id               INT,
    rm_name                  VARCHAR,
    vehicle_type             VARCHAR,
    state                    VARCHAR,
    district                 VARCHAR,
    -- Image columns
    start_image_id           INT,
    start_image_name         VARCHAR,
    start_selfie_pic         VARCHAR,
    end_image_id             INT,
    end_image_name           VARCHAR,
    end_selfie_pic           VARCHAR,
    start_distance_timestamp BIGINT,
    end_distance_timestamp   BIGINT,
    total_distance           INT,
    gps_distance_km          NUMERIC,   -- haversine distance computed from GPS points
    rate_per_km              NUMERIC,
    required_amount          NUMERIC,
    verifier_amount          NUMERIC,
    rm_amount                NUMERIC,
    approved_amount          NUMERIC,
    verifier_status          VARCHAR,
    verifier_by              INT,
    verifier_comment         TEXT,
    verifier_at              TIMESTAMPTZ,
    rm_status                VARCHAR,
    rm_by                    INT,
    rm_comment               TEXT,
    rm_at                    TIMESTAMPTZ,
    ta_status                VARCHAR,
    ta_by                    INT,
    ta_comment               TEXT,
    ta_at                    TIMESTAMPTZ,
    is_submitted             SMALLINT,
    submitted_at             TIMESTAMPTZ,
    payment_status           VARCHAR,
    payment_by               INT,
    payment_at               TIMESTAMPTZ,
    uuid                     VARCHAR,
    unread_count             BIGINT,
    total_count              BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        dt.id,
        dt.user_id,
        u_exec.full_name                                                AS executive_name,
        dt.rm_user_id,
        u_rm.full_name                                                  AS rm_name,
        dt.vehicle_type,
        dt.state,
        dt.district,

        -- Start image
        dt.start_image_id,
        di_start.image_name                                             AS start_image_name,
        COALESCE(di_start.full_path, dt.start_selfie_pic)              AS start_selfie_pic,

        -- End image
        dt.end_image_id,
        di_end.image_name                                               AS end_image_name,
        COALESCE(di_end.full_path, dt.end_selfie_pic)                  AS end_selfie_pic,

        dt.start_distance_timestamp,
        dt.end_distance_timestamp,
        dt.total_distance,

        -- GPS haversine distance (km) computed from stored GPS points
        ROUND(COALESCE((
            SELECT SUM(
                6371.0 * 2.0 * ASIN(SQRT(
                    POWER(SIN(RADIANS((latitude - prev_lat) / 2.0)), 2) +
                    COS(RADIANS(prev_lat)) * COS(RADIANS(latitude)) *
                    POWER(SIN(RADIANS((longitude - prev_lng) / 2.0)), 2)
                ))
            )
            FROM (
                SELECT
                    latitude::FLOAT   AS latitude,
                    longitude::FLOAT  AS longitude,
                    LAG(latitude::FLOAT)  OVER (ORDER BY timestamp) AS prev_lat,
                    LAG(longitude::FLOAT) OVER (ORDER BY timestamp) AS prev_lng
                FROM gps_location
                WHERE trip_id = dt.id
            ) gps_sub
            WHERE gps_sub.prev_lat IS NOT NULL
        ), 0)::NUMERIC, 2)                                             AS gps_distance_km,

        dt.rate_per_km,
        dt.required_amount,
        dt.verifier_amount,
        dt.rm_amount,
        dt.approved_amount,
        dt.verifier_status,
        dt.verifier_by,
        dt.verifier_comment,
        dt.verifier_at,
        dt.rm_status,
        dt.rm_by,
        dt.rm_comment,
        dt.rm_at,
        dt.ta_status,
        dt.ta_by,
        dt.ta_comment,
        dt.ta_at,
        dt.is_submitted,
        dt.submitted_at,
        dt.payment_status,
        dt.payment_by,
        dt.payment_at,
        dt.uuid,

        -- Unread messages directed to this role
        COALESCE((
            SELECT COUNT(*)::BIGINT
            FROM distance_messages dm
            WHERE dm.trip_id = dt.id
              AND LOWER(dm.to_role) = LOWER(COALESCE(p_role, ''))
              AND dm.is_read = 0
        ), 0)                                                           AS unread_count,

        COUNT(*) OVER ()                                                AS total_count

    FROM distance_tracking dt
    LEFT JOIN user_tbl         u_exec   ON dt.user_id        = u_exec.user_id
    -- RM: use stored rm_user_id first; then user_institution_map; then reporting_rm name match
    LEFT JOIN LATERAL (
        SELECT COALESCE(
            (SELECT uim.rm_user_id FROM user_institution_map uim
             WHERE uim.user_id = dt.user_id AND uim.active = 1 AND uim.rm_user_id IS NOT NULL
             LIMIT 1),
            (SELECT u2.user_id FROM user_tbl u2
             JOIN user_information ui2 ON ui2.user_id = dt.user_id
             WHERE u2.full_name = ui2.reporting_rm AND u2.is_active = 1
             LIMIT 1)
        ) AS mapped_rm_id
    ) uim_rm ON (dt.rm_user_id IS NULL)
    LEFT JOIN user_tbl         u_rm     ON COALESCE(dt.rm_user_id, uim_rm.mapped_rm_id) = u_rm.user_id
    LEFT JOIN distance_images  di_start ON dt.start_image_id = di_start.id
    LEFT JOIN distance_images  di_end   ON dt.end_image_id   = di_end.id
    WHERE
        (p_user_id IS NULL OR dt.user_id = p_user_id)
        AND (
            p_rm_user_id IS NULL
            OR dt.rm_user_id = p_rm_user_id
            -- fallback 1: executive is mapped to this RM in user_institution_map
            OR (dt.rm_user_id IS NULL AND EXISTS (
                SELECT 1 FROM user_institution_map uim
                WHERE uim.user_id    = dt.user_id
                  AND uim.rm_user_id = p_rm_user_id
                  AND uim.active     = 1
            ))
            -- fallback 2: executive's reporting_rm name matches this RM's full_name
            OR (dt.rm_user_id IS NULL AND EXISTS (
                SELECT 1 FROM user_tbl u
                JOIN user_information ui ON ui.user_id = dt.user_id
                WHERE u.user_id   = p_rm_user_id
                  AND u.full_name = ui.reporting_rm
                  AND u.is_active = 1
            ))
        )
        AND (p_state  IS NULL OR LOWER(dt.state) = LOWER(p_state))
        AND (p_status IS NULL OR dt.payment_status = p_status)
        AND (p_start_date IS NULL OR
             (TO_TIMESTAMP(dt.start_distance_timestamp / 1000.0) AT TIME ZONE 'Asia/Kolkata')::DATE >= p_start_date)
        AND (p_end_date   IS NULL OR
             (TO_TIMESTAMP(dt.start_distance_timestamp / 1000.0) AT TIME ZONE 'Asia/Kolkata')::DATE <= p_end_date)
    ORDER BY dt.id DESC
    LIMIT  p_page_size
    OFFSET (p_page - 1) * p_page_size;
END;
$$ LANGUAGE plpgsql;
