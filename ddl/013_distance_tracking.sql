-- ============================================================================
-- DDL 013: distance_tracking + gps_location + distance_messages
-- All in myactivity schema (adapted from standalone tracking schema)
-- ============================================================================
SET search_path TO myactivity;

-- ── 1. distance_tracking ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS distance_tracking (
    id                        SERIAL          PRIMARY KEY,
    user_id                   INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    rm_user_id                INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    vehicle_type              VARCHAR(20),
    state                     VARCHAR(100),
    district                  VARCHAR(100),

    -- Trip odometer + selfie
    start_odo_reading         INT,
    start_selfie_pic          VARCHAR(500),
    start_distance_timestamp  BIGINT,
    end_odo_reading           INT,
    end_selfie_pic            VARCHAR(500),
    end_distance_timestamp    BIGINT,

    -- Calculated distance & time
    total_distance            INT,
    total_time                INT,

    -- Amount
    rate_per_km               NUMERIC(5,2)    DEFAULT 3.00,
    required_amount           NUMERIC(10,2),

    -- Sync
    is_synced                 SMALLINT        NOT NULL DEFAULT 0,
    uuid                      VARCHAR(100)    UNIQUE,

    -- ── Verifier approval ──────────────────────────────────────────────────
    verifier_status           VARCHAR(20)     NOT NULL DEFAULT 'Pending',
    verifier_by               INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    verifier_comment          TEXT,
    verifier_at               TIMESTAMPTZ,
    verifier_deduction        NUMERIC(10,2)   DEFAULT 0,

    -- ── RM approval ────────────────────────────────────────────────────────
    rm_status                 VARCHAR(20)     NOT NULL DEFAULT 'Pending',
    rm_by                     INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    rm_comment                TEXT,
    rm_at                     TIMESTAMPTZ,

    -- ── TA approval ────────────────────────────────────────────────────────
    ta_status                 VARCHAR(20)     NOT NULL DEFAULT 'Pending',
    ta_by                     INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    ta_comment                TEXT,
    ta_at                     TIMESTAMPTZ,

    -- ── Submit & Payment ───────────────────────────────────────────────────
    is_submitted              SMALLINT        NOT NULL DEFAULT 0,
    submitted_at              TIMESTAMPTZ,
    approved_amount           NUMERIC(10,2),

    payment_status            VARCHAR(30)     NOT NULL DEFAULT 'Processing',
    payment_by                INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    payment_at                TIMESTAMPTZ,

    created_at                TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at                TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dt_user_id   ON distance_tracking(user_id);
CREATE INDEX IF NOT EXISTS idx_dt_rm        ON distance_tracking(rm_user_id);
CREATE INDEX IF NOT EXISTS idx_dt_uuid      ON distance_tracking(uuid);
CREATE INDEX IF NOT EXISTS idx_dt_state     ON distance_tracking(state);
CREATE INDEX IF NOT EXISTS idx_dt_v_status  ON distance_tracking(verifier_status);
CREATE INDEX IF NOT EXISTS idx_dt_rm_status ON distance_tracking(rm_status);
CREATE INDEX IF NOT EXISTS idx_dt_payment   ON distance_tracking(payment_status);

-- ── 2. gps_location ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS gps_location (
    id          BIGSERIAL       PRIMARY KEY,
    trip_id     INT             NOT NULL REFERENCES distance_tracking(id) ON DELETE CASCADE,
    user_id     INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    uuid        VARCHAR(100)    UNIQUE,
    latitude    NUMERIC(10,7)   NOT NULL,
    longitude   NUMERIC(10,7)   NOT NULL,
    altitude    NUMERIC(8,2),
    timestamp   BIGINT          NOT NULL,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gps_trip_id   ON gps_location(trip_id);
CREATE INDEX IF NOT EXISTS idx_gps_user_id   ON gps_location(user_id);
CREATE INDEX IF NOT EXISTS idx_gps_timestamp ON gps_location(timestamp);
CREATE INDEX IF NOT EXISTS idx_gps_uuid      ON gps_location(uuid);

-- ── 3. distance_messages (forward / chat history) ───────────────────────────
CREATE TABLE IF NOT EXISTS distance_messages (
    id              BIGSERIAL       PRIMARY KEY,
    trip_id         INT             NOT NULL REFERENCES distance_tracking(id) ON DELETE CASCADE,
    sender_user_id  INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    sender_role     VARCHAR(50),
    to_role         VARCHAR(50),
    message         TEXT            NOT NULL,
    message_type    VARCHAR(20)     NOT NULL DEFAULT 'forward',
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dm_trip_id ON distance_messages(trip_id);

-- ── Schema version ───────────────────────────────────────────────────────────
INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.13', '013_distance_tracking.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
