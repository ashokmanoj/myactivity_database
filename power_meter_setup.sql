-- ============================================================================
-- Power Meter — Full Setup Script
-- Run this once in psql or pgAdmin against myactivitydb
-- ============================================================================

SET search_path TO myactivity;

-- ── 1. Table ────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS power_meter (
    meter_id       SERIAL        PRIMARY KEY,
    uuid           VARCHAR(100)  UNIQUE,
    project_id     INT,
    institution_id INT,
    user_id        INT,
    meter_status   VARCHAR(20)   NOT NULL DEFAULT 'Working',
    comments       TEXT,
    image_path     VARCHAR(500),
    gps_lat        NUMERIC(10,7),
    gps_lng        NUMERIC(10,7),
    submitted_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    is_synced      SMALLINT      NOT NULL DEFAULT 0,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pwm_project_id     ON power_meter(project_id);
CREATE INDEX IF NOT EXISTS idx_pwm_institution_id ON power_meter(institution_id);
CREATE INDEX IF NOT EXISTS idx_pwm_user_id        ON power_meter(user_id);
CREATE INDEX IF NOT EXISTS idx_pwm_status         ON power_meter(meter_status);
CREATE INDEX IF NOT EXISTS idx_pwm_created_at     ON power_meter(created_at);

-- ── 2. fn_pwm_get_user_projects ─────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_pwm_get_user_projects(
    p_user_id INT
)
RETURNS TABLE(
    project_id   INT,
    project_name VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        p.project_id,
        p.project_name
    FROM user_institution_map m
    JOIN project p ON p.project_id = m.project_id
    WHERE m.user_id   = p_user_id
      AND m.active    = 1
      AND p.is_active = 1
    ORDER BY p.project_name ASC;
END;
$$ LANGUAGE plpgsql;

-- ── 3. fn_pwm_get_user_institutions ─────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_pwm_get_user_institutions(
    p_user_id    INT,
    p_project_id INT DEFAULT NULL
)
RETURNS TABLE(
    institute_id     INT,
    institution_name VARCHAR,
    institute_code   VARCHAR,
    project_id       INT,
    project_name     VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT
        i.institute_id,
        i.institution_name,
        i.institute_code,
        p.project_id,
        p.project_name
    FROM user_institution_map m
    JOIN institution i ON i.institute_id = m.institution_id
    JOIN project     p ON p.project_id   = m.project_id
    WHERE m.user_id   = p_user_id
      AND m.active    = 1
      AND i.is_active = 1
      AND (p_project_id IS NULL OR m.project_id = p_project_id)
    ORDER BY i.institution_name ASC;
END;
$$ LANGUAGE plpgsql;

-- ── 4. fn_pwm_create ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_pwm_create(
    p_uuid           VARCHAR,
    p_project_id     INT,
    p_institution_id INT,
    p_user_id        INT,
    p_meter_status   VARCHAR,
    p_comments       TEXT    DEFAULT NULL,
    p_image_path     VARCHAR DEFAULT NULL,
    p_gps_lat        NUMERIC DEFAULT NULL,
    p_gps_lng        NUMERIC DEFAULT NULL
)
RETURNS SETOF power_meter AS $$
BEGIN
    RETURN QUERY
    INSERT INTO power_meter (
        uuid, project_id, institution_id, user_id,
        meter_status, comments, image_path,
        gps_lat, gps_lng, submitted_at, is_synced
    ) VALUES (
        p_uuid, p_project_id, p_institution_id, p_user_id,
        p_meter_status, p_comments, p_image_path,
        p_gps_lat, p_gps_lng, NOW(), 0
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- ── 5. fn_pwm_get_all ───────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_pwm_get_all(
    p_project_id     INT         DEFAULT NULL,
    p_institution_id INT         DEFAULT NULL,
    p_user_id        INT         DEFAULT NULL,
    p_meter_status   VARCHAR     DEFAULT NULL,
    p_from           TIMESTAMPTZ DEFAULT NULL,
    p_to             TIMESTAMPTZ DEFAULT NULL
)
RETURNS TABLE(
    meter_id         INT,
    uuid             VARCHAR,
    project_id       INT,
    project_name     VARCHAR,
    institution_id   INT,
    institution_name VARCHAR,
    institute_code   VARCHAR,
    user_id          INT,
    full_name        VARCHAR,
    emp_code         VARCHAR,
    meter_status     VARCHAR,
    comments         TEXT,
    image_path       VARCHAR,
    gps_lat          NUMERIC,
    gps_lng          NUMERIC,
    submitted_at     TIMESTAMPTZ,
    is_synced        SMALLINT,
    created_at       TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pm.meter_id,
        pm.uuid,
        p.project_id,
        p.project_name,
        i.institute_id,
        i.institution_name,
        i.institute_code,
        u.user_id,
        u.full_name,
        u.emp_code,
        pm.meter_status,
        pm.comments,
        pm.image_path,
        pm.gps_lat,
        pm.gps_lng,
        pm.submitted_at,
        pm.is_synced,
        pm.created_at
    FROM power_meter pm
    LEFT JOIN project     p ON p.project_id   = pm.project_id
    LEFT JOIN institution i ON i.institute_id  = pm.institution_id
    LEFT JOIN user_tbl    u ON u.user_id       = pm.user_id
    WHERE (p_project_id     IS NULL OR pm.project_id     = p_project_id)
      AND (p_institution_id IS NULL OR pm.institution_id = p_institution_id)
      AND (p_user_id        IS NULL OR pm.user_id        = p_user_id)
      AND (p_meter_status   IS NULL OR pm.meter_status   = p_meter_status)
      AND (p_from           IS NULL OR pm.created_at    >= p_from)
      AND (p_to             IS NULL OR pm.created_at    <= p_to)
    ORDER BY pm.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- ── 6. fn_pwm_get_by_id ─────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_pwm_get_by_id(
    p_meter_id INT
)
RETURNS TABLE(
    meter_id         INT,
    uuid             VARCHAR,
    project_id       INT,
    project_name     VARCHAR,
    institution_id   INT,
    institution_name VARCHAR,
    institute_code   VARCHAR,
    user_id          INT,
    full_name        VARCHAR,
    emp_code         VARCHAR,
    meter_status     VARCHAR,
    comments         TEXT,
    image_path       VARCHAR,
    gps_lat          NUMERIC,
    gps_lng          NUMERIC,
    submitted_at     TIMESTAMPTZ,
    created_at       TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        pm.meter_id,
        pm.uuid,
        p.project_id,
        p.project_name,
        i.institute_id,
        i.institution_name,
        i.institute_code,
        u.user_id,
        u.full_name,
        u.emp_code,
        pm.meter_status,
        pm.comments,
        pm.image_path,
        pm.gps_lat,
        pm.gps_lng,
        pm.submitted_at,
        pm.created_at
    FROM power_meter pm
    LEFT JOIN project     p ON p.project_id   = pm.project_id
    LEFT JOIN institution i ON i.institute_id  = pm.institution_id
    LEFT JOIN user_tbl    u ON u.user_id       = pm.user_id
    WHERE pm.meter_id = p_meter_id;
END;
$$ LANGUAGE plpgsql;

-- ── 7. fn_pwm_sync ──────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_pwm_sync(
    p_uuid           VARCHAR,
    p_project_id     INT,
    p_institution_id INT,
    p_user_id        INT,
    p_meter_status   VARCHAR,
    p_submitted_at   TIMESTAMPTZ DEFAULT NOW(),
    p_comments       TEXT        DEFAULT NULL,
    p_image_path     VARCHAR     DEFAULT NULL,
    p_gps_lat        NUMERIC     DEFAULT NULL,
    p_gps_lng        NUMERIC     DEFAULT NULL
)
RETURNS INT AS $$
DECLARE
    v_meter_id INT;
BEGIN
    INSERT INTO power_meter (
        uuid, project_id, institution_id, user_id,
        meter_status, comments, image_path,
        gps_lat, gps_lng, submitted_at, is_synced
    ) VALUES (
        p_uuid, p_project_id, p_institution_id, p_user_id,
        p_meter_status, p_comments, p_image_path,
        p_gps_lat, p_gps_lng, p_submitted_at, 1
    )
    ON CONFLICT (uuid) DO UPDATE SET
        meter_status   = EXCLUDED.meter_status,
        comments       = EXCLUDED.comments,
        image_path     = COALESCE(EXCLUDED.image_path, power_meter.image_path),
        gps_lat        = EXCLUDED.gps_lat,
        gps_lng        = EXCLUDED.gps_lng,
        submitted_at   = EXCLUDED.submitted_at,
        is_synced      = 1,
        updated_at     = NOW()
    RETURNING meter_id INTO v_meter_id;

    RETURN v_meter_id;
END;
$$ LANGUAGE plpgsql;

-- ── Done ─────────────────────────────────────────────────────────────────────
SELECT 'Power Meter setup complete ✓' AS status;
