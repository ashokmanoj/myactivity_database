SET search_path TO myactivity;

-- Single-trip counterpart to fn_distance_get_all — same joins/columns, filtered to one id.
-- Used to return the full trip after any mutation (sync/start/end/approve/submit/payment/
-- forward/markRead/bulk actions) instead of the mutation's own minimal status row.
CREATE OR REPLACE FUNCTION fn_distance_get_by_id(
    p_id    INT,
    p_role  VARCHAR DEFAULT NULL  -- current user's distance role for unread count
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
    start_image_id           INT,
    start_image_name         VARCHAR,
    start_selfie_pic         VARCHAR,
    end_image_id             INT,
    end_image_name           VARCHAR,
    end_selfie_pic           VARCHAR,
    start_distance_timestamp BIGINT,
    end_distance_timestamp   BIGINT,
    total_distance           INT,
    gps_distance_km          NUMERIC,
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
    legs                     JSON
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

        dt.start_image_id,
        di_start.image_name                                             AS start_image_name,
        COALESCE(di_start.full_path, dt.start_selfie_pic)              AS start_selfie_pic,

        dt.end_image_id,
        di_end.image_name                                               AS end_image_name,
        COALESCE(di_end.full_path, dt.end_selfie_pic)                  AS end_selfie_pic,

        dt.start_distance_timestamp,
        dt.end_distance_timestamp,
        dt.total_distance,

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

        COALESCE((
            SELECT COUNT(*)::BIGINT
            FROM distance_messages dm
            WHERE dm.trip_id = dt.id
              AND LOWER(dm.to_role) = LOWER(COALESCE(p_role, ''))
              AND dm.is_read = 0
        ), 0)                                                           AS unread_count,

        COALESCE((
            SELECT json_agg(dl ORDER BY dl.sort_order, dl.id)
            FROM distance_leg dl
            WHERE dl.trip_id = dt.id
        ), '[]'::json)                                                  AS legs

    FROM distance_tracking dt
    LEFT JOIN user_tbl         u_exec   ON dt.user_id        = u_exec.user_id
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
    WHERE dt.id = p_id;
END;
$$ LANGUAGE plpgsql;
