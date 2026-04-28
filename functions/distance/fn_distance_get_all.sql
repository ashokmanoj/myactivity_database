SET search_path TO myactivity;

DROP FUNCTION IF EXISTS fn_distance_get_all(INT, INT, INT, INT, VARCHAR, VARCHAR, VARCHAR);
DROP FUNCTION IF EXISTS fn_distance_get_all(INT, INT, INT, INT, VARCHAR, VARCHAR);

CREATE OR REPLACE FUNCTION fn_distance_get_all(
    p_page       INT     DEFAULT 1,
    p_page_size  INT     DEFAULT 10,
    p_user_id    INT     DEFAULT NULL,
    p_rm_user_id INT     DEFAULT NULL,
    p_state      VARCHAR DEFAULT NULL,
    p_status     VARCHAR DEFAULT NULL,
    p_role       VARCHAR DEFAULT NULL   -- current user's distance role for unread count
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
    -- Image columns: id + metadata from distance_images (falls back to old string columns)
    start_image_id           INT,
    start_image_name         VARCHAR,
    start_selfie_pic         VARCHAR,   -- full_path for display (or legacy string)
    end_image_id             INT,
    end_image_name           VARCHAR,
    end_selfie_pic           VARCHAR,   -- full_path for display (or legacy string)
    start_distance_timestamp BIGINT,
    end_distance_timestamp   BIGINT,
    total_distance           INT,
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
    LEFT JOIN user_tbl         u_exec   ON dt.user_id       = u_exec.user_id
    LEFT JOIN user_tbl         u_rm     ON dt.rm_user_id    = u_rm.user_id
    LEFT JOIN distance_images  di_start ON dt.start_image_id = di_start.id
    LEFT JOIN distance_images  di_end   ON dt.end_image_id   = di_end.id
    WHERE
        (p_user_id    IS NULL OR dt.user_id    = p_user_id)
        AND (p_rm_user_id IS NULL OR dt.rm_user_id = p_rm_user_id)
        AND (p_state   IS NULL OR LOWER(dt.state) = LOWER(p_state))
        AND (p_status  IS NULL OR dt.payment_status = p_status)
    ORDER BY dt.id DESC
    LIMIT  p_page_size
    OFFSET (p_page - 1) * p_page_size;
END;
$$ LANGUAGE plpgsql;
