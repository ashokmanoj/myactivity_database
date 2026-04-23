SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_get_all(
    p_page          INT     DEFAULT 1,
    p_page_size     INT     DEFAULT 10,
    p_user_id       INT     DEFAULT NULL,
    p_rm_user_id    INT     DEFAULT NULL,
    p_state         VARCHAR DEFAULT NULL,
    p_status        VARCHAR DEFAULT NULL
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
    start_selfie_pic         VARCHAR,
    end_selfie_pic           VARCHAR,
    start_distance_timestamp BIGINT,
    end_distance_timestamp   BIGINT,
    total_distance           INT,
    rate_per_km              NUMERIC,
    required_amount          NUMERIC,
    approved_amount          NUMERIC,
    verifier_status          VARCHAR,
    verifier_by              INT,
    verifier_comment         TEXT,
    verifier_at              TIMESTAMPTZ,
    verifier_deduction       NUMERIC,
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
    is_active                BOOLEAN,
    total_count              BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        dt.id,
        dt.user_id,
        u_exec.full_name                    AS executive_name,
        dt.rm_user_id,
        u_rm.full_name                      AS rm_name,
        dt.vehicle_type,
        dt.state,
        dt.district,
        dt.start_selfie_pic,
        dt.end_selfie_pic,
        dt.start_distance_timestamp,
        dt.end_distance_timestamp,
        dt.total_distance,
        dt.rate_per_km,
        dt.required_amount,
        dt.approved_amount,
        dt.verifier_status,
        dt.verifier_by,
        dt.verifier_comment,
        dt.verifier_at,
        dt.verifier_deduction,
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
        (dt.end_odo_reading IS NULL)::BOOLEAN AS is_active,
        COUNT(*) OVER ()                     AS total_count
    FROM distance_tracking dt
    LEFT JOIN user_tbl u_exec ON dt.user_id    = u_exec.user_id
    LEFT JOIN user_tbl u_rm   ON dt.rm_user_id = u_rm.user_id
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
