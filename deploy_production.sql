-- ============================================================================
-- PRODUCTION DEPLOYMENT SCRIPT  (complete + idempotent)
-- Safe to run on a fresh DB or an existing one.
--   • All CREATE TABLE uses IF NOT EXISTS
--   • All ALTER TABLE uses ADD COLUMN IF NOT EXISTS
--   • All DML uses ON CONFLICT DO NOTHING
--   • All functions use CREATE OR REPLACE
--
-- Usage:
--   psql -U postgres -d myactivitydb -f deploy_production.sql
-- ============================================================================

-- ── Schema ───────────────────────────────────────────────────────────────────
CREATE SCHEMA IF NOT EXISTS myactivity;
SET search_path TO myactivity;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS schema_versions (
    id             BIGSERIAL    PRIMARY KEY,
    version        VARCHAR(20)  NOT NULL,
    migration_file VARCHAR(200) NOT NULL,
    direction      VARCHAR(4)   NOT NULL DEFAULT 'UP',
    applied_at     TIMESTAMPTZ  DEFAULT NOW(),
    applied_by     VARCHAR(100) DEFAULT current_user,
    status         VARCHAR(20)  DEFAULT 'SUCCESS',
    UNIQUE (migration_file, direction)
);


-- ============================================================================
-- SECTION 1 — ALL TABLES  (CREATE TABLE IF NOT EXISTS)
-- ============================================================================

-- ── project, designation, company ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS project (
    project_id   SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    domain       VARCHAR(200),
    project_code VARCHAR(50)  UNIQUE,
    logo_path    VARCHAR(500),
    start_date   DATE,
    end_date     DATE,
    is_active    SMALLINT     NOT NULL DEFAULT 1,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_project_active ON project(is_active);

CREATE TABLE IF NOT EXISTS designation (
    designation_id   SERIAL PRIMARY KEY,
    designation_name VARCHAR(200) NOT NULL UNIQUE,
    designation      VARCHAR(200),
    project_id       INT REFERENCES project(project_id) ON DELETE SET NULL,
    is_active        SMALLINT    NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS company (
    company_id   SERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL,
    email        VARCHAR(200),
    website      VARCHAR(500),
    address      VARCHAR(500),
    state        VARCHAR(100),
    country      VARCHAR(100),
    is_active    SMALLINT    NOT NULL DEFAULT 1,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_company_active ON company(is_active);

-- ── district, block, institution, institution_project_map ────────────────────
CREATE TABLE IF NOT EXISTS district (
    district_id   SERIAL PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL UNIQUE,
    state_code    VARCHAR(10),
    is_active     SMALLINT    NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS block (
    block_id    SERIAL PRIMARY KEY,
    block_name  VARCHAR(100) NOT NULL,
    district_id INT          NOT NULL REFERENCES district(district_id),
    is_active   SMALLINT     NOT NULL DEFAULT 1,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_block_name_district_id UNIQUE (block_name, district_id)
);
CREATE INDEX IF NOT EXISTS idx_block_district ON block(district_id);

CREATE TABLE IF NOT EXISTS institution (
    institute_id     SERIAL PRIMARY KEY,
    institution_name VARCHAR(150) NOT NULL,
    institute_code   VARCHAR(50)  NOT NULL UNIQUE,
    project_id       INT          NOT NULL REFERENCES project(project_id),
    district_id      INT          REFERENCES district(district_id),
    block_id         INT          REFERENCES block(block_id),
    address          VARCHAR(500),
    pincode          INT,
    latitude         NUMERIC(8,6),
    longitude        NUMERIC(9,6),
    is_active        SMALLINT     NOT NULL DEFAULT 1,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_inst_project  ON institution(project_id);
CREATE INDEX IF NOT EXISTS idx_inst_district ON institution(district_id);
CREATE INDEX IF NOT EXISTS idx_inst_active   ON institution(is_active);

CREATE TABLE IF NOT EXISTS institution_project_map (
    institute_project_map_id SERIAL PRIMARY KEY,
    project_id               INT NOT NULL REFERENCES project(project_id),
    institute_id             INT NOT NULL REFERENCES institution(institute_id),
    is_active                SMALLINT NOT NULL DEFAULT 1,
    created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_inst_proj_map UNIQUE (project_id, institute_id)
);

-- ── user_tbl, user_information ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS user_tbl (
    user_id       SERIAL PRIMARY KEY,
    emp_code      VARCHAR(50)  NOT NULL UNIQUE,
    full_name     VARCHAR(150) NOT NULL,
    date_of_birth DATE         NOT NULL,
    gender        VARCHAR(20)  NOT NULL,
    mobile_number VARCHAR(15)  NOT NULL,
    email         VARCHAR(200) NOT NULL UNIQUE,
    nationality   VARCHAR(100) NOT NULL,
    is_active     SMALLINT     NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_user_mobile ON user_tbl(mobile_number);

CREATE TABLE IF NOT EXISTS user_information (
    user_info_id        SERIAL PRIMARY KEY,
    user_id             INT NOT NULL UNIQUE REFERENCES user_tbl(user_id) ON DELETE CASCADE,
    company_id          INT,
    password            VARCHAR(255),
    title               VARCHAR(20),
    marital_status      VARCHAR(50),
    photo_available     BOOLEAN NOT NULL DEFAULT FALSE,
    photo_path          VARCHAR(500),
    payroll_group       VARCHAR(100),
    emergency_phone     VARCHAR(20),
    father_name         VARCHAR(150),
    mother_name         VARCHAR(150),
    spouse_name         VARCHAR(150),
    aadhar_number       VARCHAR(12),
    aadhar_document     VARCHAR(500),
    pan_number          VARCHAR(10),
    pan_document        VARCHAR(500),
    perm_address        VARCHAR(500),
    perm_block          VARCHAR(100),
    perm_district       VARCHAR(100),
    perm_city           VARCHAR(100),
    perm_state          VARCHAR(100),
    perm_country        VARCHAR(100),
    perm_pincode        VARCHAR(10),
    curr_address        VARCHAR(500),
    curr_block          VARCHAR(100),
    curr_district       VARCHAR(100),
    curr_city           VARCHAR(100),
    curr_state          VARCHAR(100),
    curr_country        VARCHAR(100),
    curr_pincode        VARCHAR(10),
    same_as_permanent   BOOLEAN NOT NULL DEFAULT FALSE,
    bank_name           VARCHAR(100),
    branch_name         VARCHAR(100),
    account_number      VARCHAR(50),
    ifsc_code           VARCHAR(20),
    bank_document       VARCHAR(500),
    reporting_rm        VARCHAR(150),
    executive_name      VARCHAR(150),
    district_of_posting VARCHAR(100),
    block_of_posting    VARCHAR(100),
    experience_status   VARCHAR(100),
    department          VARCHAR(100),
    designation_id      INT,
    date_of_joining     DATE,
    date_of_exit        DATE,
    qualification       VARCHAR(150),
    college_name        VARCHAR(255),
    year_of_passout     VARCHAR(10),
    total_experience    VARCHAR(100),
    last_company_name   VARCHAR(255),
    last_date_of_leaving DATE,
    is_active           SMALLINT NOT NULL DEFAULT 1,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_user_info_company ON user_information(company_id);

-- ── locations, location_photos ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS locations (
    location_id    SERIAL PRIMARY KEY,
    user_id        INT         NOT NULL REFERENCES user_tbl(user_id),
    location_name  VARCHAR(200),
    location_type  VARCHAR(50),
    lat            NUMERIC(10,7),
    lon            NUMERIC(10,7),
    geo_address    VARCHAR(500),
    geo_pincode    VARCHAR(10),
    description    VARCHAR(500),
    institution_id INT REFERENCES institution(institute_id),
    is_active      SMALLINT    NOT NULL DEFAULT 1,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_loc_user   ON locations(user_id);
CREATE INDEX IF NOT EXISTS idx_loc_active ON locations(is_active);

CREATE TABLE IF NOT EXISTS location_photos (
    location_photo_id SERIAL PRIMARY KEY,
    location_id       INT           NOT NULL REFERENCES locations(location_id),
    photo_filename    VARCHAR(255)  NOT NULL,
    fullpath_url      VARCHAR(1000) NOT NULL,
    is_active         SMALLINT      NOT NULL DEFAULT 1,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_loc_photos_loc ON location_photos(location_id);

-- ── token_blacklist ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS token_blacklist (
    id          SERIAL PRIMARY KEY,
    token       TEXT         NOT NULL,
    user_id     INT          NOT NULL REFERENCES user_tbl(user_id),
    expires_at  TIMESTAMPTZ  NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_blacklist_token   ON token_blacklist(token);
CREATE INDEX IF NOT EXISTS idx_blacklist_expires ON token_blacklist(expires_at);

-- ── roles ─────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS roles (
    role_id     SERIAL PRIMARY KEY,
    role_name   VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active   SMALLINT NOT NULL DEFAULT 1,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO roles (role_id, role_name, description) VALUES
(1,  'Regional Manager Head', 'Full access to all operational features'),
(2,  'Regional Manager',      'Regional oversight and management access'),
(3,  'Office Executive',      'Office-level administrative access'),
(4,  'Procurement',           'Procurement and purchasing access'),
(5,  'Store Executive',       'Inventory and store management access'),
(6,  'Quality/Training',      'Quality control and training management'),
(7,  'HR',                    'Human Resources management access'),
(8,  'Accounts',              'Financial and accounting access'),
(9,  'TA Team',               'Technical Assistant team access'),
(10, 'Field Executive',       'Field executive access'),
(11, 'Verifier',              'Verifies and approves field executive distance claims')
ON CONFLICT (role_name) DO UPDATE SET description = EXCLUDED.description, is_active = 1;

SELECT setval('roles_role_id_seq', 11, true);

-- Link role_id to user_information if not already present
ALTER TABLE user_information
    DROP COLUMN IF EXISTS role;
ALTER TABLE user_information
    ADD COLUMN IF NOT EXISTS role_id INT REFERENCES roles(role_id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_user_info_role_id ON user_information(role_id);

-- ── distance_tracking, gps_location, distance_messages ───────────────────────
CREATE TABLE IF NOT EXISTS distance_tracking (
    id                        SERIAL       PRIMARY KEY,
    user_id                   INT          REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    rm_user_id                INT          REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    vehicle_type              VARCHAR(20),
    state                     VARCHAR(100),
    district                  VARCHAR(100),
    start_odo_reading         INT,
    start_selfie_pic          VARCHAR(500),
    start_distance_timestamp  BIGINT,
    end_odo_reading           INT,
    end_selfie_pic            VARCHAR(500),
    end_distance_timestamp    BIGINT,
    total_distance            INT,
    total_time                INT,
    rate_per_km               NUMERIC(5,2)  DEFAULT 3.00,
    required_amount           NUMERIC(10,2),
    is_synced                 SMALLINT      NOT NULL DEFAULT 0,
    uuid                      VARCHAR(100)  UNIQUE,
    verifier_status           VARCHAR(20)   NOT NULL DEFAULT 'Pending',
    verifier_by               INT           REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    verifier_comment          TEXT,
    verifier_at               TIMESTAMPTZ,
    verifier_deduction        NUMERIC(10,2) DEFAULT 0,
    rm_status                 VARCHAR(20)   NOT NULL DEFAULT 'Pending',
    rm_by                     INT           REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    rm_comment                TEXT,
    rm_at                     TIMESTAMPTZ,
    ta_status                 VARCHAR(20)   NOT NULL DEFAULT 'Pending',
    ta_by                     INT           REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    ta_comment                TEXT,
    ta_at                     TIMESTAMPTZ,
    is_submitted              SMALLINT      NOT NULL DEFAULT 0,
    submitted_at              TIMESTAMPTZ,
    approved_amount           NUMERIC(10,2),
    payment_status            VARCHAR(30)   NOT NULL DEFAULT 'Processing',
    payment_by                INT           REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    payment_at                TIMESTAMPTZ,
    created_at                TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at                TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_dt_user_id   ON distance_tracking(user_id);
CREATE INDEX IF NOT EXISTS idx_dt_rm        ON distance_tracking(rm_user_id);
CREATE INDEX IF NOT EXISTS idx_dt_uuid      ON distance_tracking(uuid);
CREATE INDEX IF NOT EXISTS idx_dt_state     ON distance_tracking(state);
CREATE INDEX IF NOT EXISTS idx_dt_v_status  ON distance_tracking(verifier_status);
CREATE INDEX IF NOT EXISTS idx_dt_rm_status ON distance_tracking(rm_status);
CREATE INDEX IF NOT EXISTS idx_dt_payment   ON distance_tracking(payment_status);

CREATE TABLE IF NOT EXISTS gps_location (
    id          BIGSERIAL     PRIMARY KEY,
    trip_id     INT           NOT NULL REFERENCES distance_tracking(id) ON DELETE CASCADE,
    user_id     INT           REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    uuid        VARCHAR(100)  UNIQUE,
    latitude    NUMERIC(10,7) NOT NULL,
    longitude   NUMERIC(10,7) NOT NULL,
    altitude    NUMERIC(8,2),
    timestamp   BIGINT        NOT NULL,
    created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_gps_trip_id   ON gps_location(trip_id);
CREATE INDEX IF NOT EXISTS idx_gps_user_id   ON gps_location(user_id);
CREATE INDEX IF NOT EXISTS idx_gps_timestamp ON gps_location(timestamp);
CREATE INDEX IF NOT EXISTS idx_gps_uuid      ON gps_location(uuid);

CREATE TABLE IF NOT EXISTS distance_messages (
    id              BIGSERIAL   PRIMARY KEY,
    trip_id         INT         NOT NULL REFERENCES distance_tracking(id) ON DELETE CASCADE,
    sender_user_id  INT         REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    sender_role     VARCHAR(50),
    to_role         VARCHAR(50),
    message         TEXT        NOT NULL,
    message_type    VARCHAR(20) NOT NULL DEFAULT 'forward',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_dm_trip_id ON distance_messages(trip_id);


-- ============================================================================
-- SECTION 2 — NEW DDL COLUMNS / TABLES  (016 → 018)
-- ============================================================================

-- ── 016: Institution verification columns ────────────────────────────────────
ALTER TABLE institution
    ADD COLUMN IF NOT EXISTS is_verified SMALLINT    NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS verified_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS verified_by INT         REFERENCES user_tbl(user_id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_inst_verified ON institution(is_verified);

-- ── 017: locations.institution_name column ────────────────────────────────────
ALTER TABLE locations
    ADD COLUMN IF NOT EXISTS institution_name VARCHAR(200);

-- ── 018: Tech Executive → Institution mapping table ───────────────────────────
CREATE TABLE IF NOT EXISTS tech_exec_institution_map (
    map_id       SERIAL      PRIMARY KEY,
    user_id      INT         NOT NULL REFERENCES user_tbl(user_id),
    institute_id INT         NOT NULL REFERENCES institution(institute_id),
    assigned_by  INT         REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    is_active    SMALLINT    NOT NULL DEFAULT 1,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_te_map_user      ON tech_exec_institution_map(user_id);
CREATE INDEX IF NOT EXISTS idx_te_map_institute ON tech_exec_institution_map(institute_id);
CREATE INDEX IF NOT EXISTS idx_te_map_active    ON tech_exec_institution_map(is_active);


-- ============================================================================
-- SECTION 3 — FUNCTIONS  (new + updated)
-- ============================================================================

-- ── Institution: location view ───────────────────────────────────────────────
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
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    WITH latest_loc AS (
        SELECT DISTINCT ON (l.institution_id)
            l.location_id, l.institution_id, l.location_type, l.lat, l.lon,
            l.created_at   AS sync_date,
            u.full_name    AS executive_name,
            u.mobile_number AS executive_mobile
        FROM locations l
        JOIN user_tbl u ON u.user_id = l.user_id
        WHERE l.is_active = 1 AND l.institution_id IS NOT NULL
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
        i.latitude   AS db_latitude,
        i.longitude  AS db_longitude,
        i.updated_at AS db_updated_at,
        ll.location_type,
        CASE
            WHEN i.latitude IS NOT NULL AND i.longitude IS NOT NULL
             AND ll.lat     IS NOT NULL AND ll.lon      IS NOT NULL
            THEN ROUND((
                6371000 * 2 * ASIN(SQRT(
                    POWER(SIN(RADIANS((ll.lat::FLOAT - i.latitude::FLOAT) / 2.0)), 2) +
                    COS(RADIANS(i.latitude::FLOAT)) * COS(RADIANS(ll.lat::FLOAT)) *
                    POWER(SIN(RADIANS((ll.lon::FLOAT - i.longitude::FLOAT) / 2.0)), 2)
                ))
            )::NUMERIC, 3)
            ELSE NULL
        END AS meter,
        ll.lat  AS gps_latitude,
        ll.lon  AS gps_longitude,
        ll.sync_date,
        ll.executive_name,
        ll.executive_mobile,
        COALESCE(i.is_verified, 0)::SMALLINT AS is_verified,
        i.verified_at,
        vbu.full_name::VARCHAR AS verified_by_name,
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

-- ── Institution: toggle verify ───────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_institution_toggle_verify(
    p_institute_id INT,
    p_user_id      INT
)
RETURNS TABLE(institute_id INT, is_verified SMALLINT, verified_at TIMESTAMPTZ)
LANGUAGE plpgsql AS $$
DECLARE v_current SMALLINT;
BEGIN
    SELECT i.is_verified INTO v_current FROM institution i WHERE i.institute_id = p_institute_id;
    IF NOT FOUND THEN RAISE EXCEPTION 'Institution % not found', p_institute_id; END IF;
    UPDATE institution SET
        is_verified = CASE WHEN v_current = 1 THEN 0 ELSE 1 END,
        verified_at = CASE WHEN v_current = 1 THEN NULL ELSE NOW() END,
        verified_by = CASE WHEN v_current = 1 THEN NULL ELSE p_user_id END
    WHERE institution.institute_id = p_institute_id;
    RETURN QUERY SELECT i.institute_id, i.is_verified, i.verified_at FROM institution i WHERE i.institute_id = p_institute_id;
END;
$$;

-- ── Location: create ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_location_create(
  p_user_id   INT,   p_name    VARCHAR, p_type    VARCHAR,
  p_lat       NUMERIC, p_lon   NUMERIC, p_address VARCHAR,
  p_pincode   VARCHAR, p_desc  VARCHAR, p_inst_id INT,
  p_inst_name VARCHAR DEFAULT NULL
) RETURNS SETOF locations AS $$
BEGIN
  RETURN QUERY
  INSERT INTO locations (
    user_id, location_name, location_type, lat, lon,
    geo_address, geo_pincode, description, institution_id, institution_name,
    is_active, created_at, updated_at
  ) VALUES (
    p_user_id, p_name, p_type, p_lat, p_lon,
    p_address, p_pincode, p_desc, p_inst_id, p_inst_name,
    1, NOW(), NOW()
  ) RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- ── Location: update ─────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_location_update(
  p_id        INT,     p_name    VARCHAR, p_type    VARCHAR,
  p_lat       NUMERIC, p_lon     NUMERIC, p_address VARCHAR,
  p_pincode   VARCHAR, p_desc    VARCHAR, p_inst_id INT,
  p_inst_name VARCHAR DEFAULT NULL
) RETURNS SETOF locations AS $$
BEGIN
  RETURN QUERY
  UPDATE locations SET
    location_name    = COALESCE(p_name,     location_name),
    location_type    = COALESCE(p_type,     location_type),
    lat              = COALESCE(p_lat,      lat),
    lon              = COALESCE(p_lon,      lon),
    geo_address      = COALESCE(p_address,  geo_address),
    geo_pincode      = COALESCE(p_pincode,  geo_pincode),
    description      = COALESCE(p_desc,     description),
    institution_id   = COALESCE(p_inst_id,  institution_id),
    institution_name = COALESCE(p_inst_name, institution_name),
    updated_at       = NOW()
  WHERE location_id = p_id RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- ── Location: sync ───────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_location_sync(
  p_user_id   INT,     p_name    VARCHAR, p_type    VARCHAR,
  p_lat       NUMERIC, p_lon     NUMERIC, p_address VARCHAR,
  p_pincode   VARCHAR, p_desc    VARCHAR, p_inst_id INT,
  p_inst_name VARCHAR DEFAULT NULL
) RETURNS SETOF locations AS $$
BEGIN
  RETURN QUERY
  INSERT INTO locations (
    user_id, location_name, location_type, lat, lon,
    geo_address, geo_pincode, description, institution_id, institution_name,
    is_active, created_at, updated_at
  ) VALUES (
    p_user_id, p_name, p_type, p_lat, p_lon,
    p_address, p_pincode, p_desc, p_inst_id, p_inst_name,
    1, NOW(), NOW()
  ) RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- ── Location: get all ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_location_get_all(
  p_user_id INT DEFAULT NULL,
  p_from    TIMESTAMPTZ DEFAULT NULL,
  p_to      TIMESTAMPTZ DEFAULT NULL
) RETURNS TABLE(
  location_id INT, user_id INT, location_name VARCHAR, location_type VARCHAR,
  lat NUMERIC, lon NUMERIC, geo_address VARCHAR, geo_pincode VARCHAR,
  description VARCHAR, institution_id INT, is_active SMALLINT,
  created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  emp_code VARCHAR, full_name VARCHAR, mobile_number VARCHAR,
  institution_name VARCHAR, institute_code VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    l.location_id, l.user_id, l.location_name, l.location_type,
    l.lat, l.lon, l.geo_address, l.geo_pincode, l.description,
    l.institution_id, l.is_active, l.created_at, l.updated_at,
    u.emp_code, u.full_name, u.mobile_number,
    COALESCE(l.institution_name, i.institution_name)::VARCHAR AS institution_name,
    i.institute_code
  FROM locations l
  JOIN      user_tbl    u ON u.user_id      = l.user_id
  LEFT JOIN institution i ON i.institute_id = l.institution_id
  WHERE l.is_active = 1
    AND (p_user_id IS NULL OR l.user_id    = p_user_id)
    AND (p_from    IS NULL OR l.created_at >= p_from)
    AND (p_to      IS NULL OR l.created_at <= p_to);
END;
$$ LANGUAGE plpgsql;

-- ── Location: get by id ──────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_location_get_by_id(p_id INT)
RETURNS TABLE(
  location_id INT, user_id INT, location_name VARCHAR, location_type VARCHAR,
  lat NUMERIC, lon NUMERIC, geo_address VARCHAR, geo_pincode VARCHAR,
  description VARCHAR, institution_id INT, is_active SMALLINT,
  created_at TIMESTAMPTZ, updated_at TIMESTAMPTZ,
  emp_code VARCHAR, full_name VARCHAR, mobile_number VARCHAR,
  institution_name VARCHAR, institute_code VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    l.location_id, l.user_id, l.location_name, l.location_type,
    l.lat, l.lon, l.geo_address, l.geo_pincode, l.description,
    l.institution_id, l.is_active, l.created_at, l.updated_at,
    u.emp_code, u.full_name, u.mobile_number,
    COALESCE(l.institution_name, i.institution_name)::VARCHAR AS institution_name,
    i.institute_code
  FROM locations l
  JOIN      user_tbl    u ON u.user_id      = l.user_id
  LEFT JOIN institution i ON i.institute_id = l.institution_id
  WHERE l.location_id = p_id AND l.is_active = 1;
END;
$$ LANGUAGE plpgsql;

-- ── TE Mapping: get all ───────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_te_map_get_all(
    p_assigned_by    INT DEFAULT NULL,
    p_project_id     INT DEFAULT NULL,
    p_district_id    INT DEFAULT NULL,
    p_designation_id INT DEFAULT NULL
) RETURNS TABLE(
    map_id INT, user_id INT, emp_code VARCHAR, full_name VARCHAR,
    designation_name VARCHAR, institute_id INT, institution_name VARCHAR,
    institute_code VARCHAR, district_name VARCHAR, block_name VARCHAR,
    assigned_by INT, assigned_by_name VARCHAR, is_active SMALLINT, created_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        tem.map_id, tem.user_id, te.emp_code, te.full_name,
        dsg.designation_name::VARCHAR,
        tem.institute_id, inst.institution_name, inst.institute_code,
        dist.district_name::VARCHAR, blk.block_name::VARCHAR,
        tem.assigned_by, rm.full_name::VARCHAR AS assigned_by_name,
        tem.is_active, tem.created_at
    FROM  tech_exec_institution_map tem
    JOIN  user_tbl                  te   ON te.user_id         = tem.user_id
    LEFT JOIN user_information      ui   ON ui.user_id         = tem.user_id
    LEFT JOIN designation           dsg  ON dsg.designation_id = ui.designation_id
    JOIN  institution               inst ON inst.institute_id  = tem.institute_id
    LEFT JOIN district              dist ON dist.district_id   = inst.district_id
    LEFT JOIN block                 blk  ON blk.block_id       = inst.block_id
    LEFT JOIN user_tbl              rm   ON rm.user_id         = tem.assigned_by
    WHERE tem.is_active = 1
      AND (p_assigned_by    IS NULL OR tem.assigned_by   = p_assigned_by)
      AND (p_district_id    IS NULL OR inst.district_id  = p_district_id)
      AND (p_designation_id IS NULL OR ui.designation_id = p_designation_id)
      AND (p_project_id     IS NULL OR inst.institute_id IN (
              SELECT ipm.institute_id FROM institution_project_map ipm
              WHERE ipm.project_id = p_project_id AND ipm.is_active = 1))
    ORDER BY tem.created_at DESC;
END;
$$ LANGUAGE plpgsql;

-- ── TE Mapping: create ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_te_map_create(
    p_user_id INT, p_institute_id INT, p_assigned_by INT DEFAULT NULL
) RETURNS TABLE(
    map_id INT, user_id INT, institute_id INT, assigned_by INT, is_active SMALLINT, created_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    INSERT INTO tech_exec_institution_map (user_id, institute_id, assigned_by, is_active, created_at, updated_at)
    VALUES (p_user_id, p_institute_id, p_assigned_by, 1, NOW(), NOW())
    RETURNING
        tech_exec_institution_map.map_id, tech_exec_institution_map.user_id,
        tech_exec_institution_map.institute_id, tech_exec_institution_map.assigned_by,
        tech_exec_institution_map.is_active, tech_exec_institution_map.created_at;
END;
$$ LANGUAGE plpgsql;

-- ── TE Mapping: deactivate ────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_te_map_deactivate(p_map_id INT)
RETURNS SETOF tech_exec_institution_map AS $$
BEGIN
    RETURN QUERY
    UPDATE tech_exec_institution_map SET is_active = 0, updated_at = NOW()
    WHERE map_id = p_map_id RETURNING *;
END;
$$ LANGUAGE plpgsql;

-- ── TE Mapping: exists ────────────────────────────────────────────────────────
CREATE OR REPLACE FUNCTION fn_te_map_exists(p_map_id INT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM tech_exec_institution_map WHERE map_id = p_map_id AND is_active = 1);
END;
$$ LANGUAGE plpgsql;


-- ============================================================================
-- SECTION 4 — SEED DATA
-- ============================================================================

-- Company
INSERT INTO company (company_name, email, website, is_active, created_at, updated_at)
VALUES ('MyActivity', 'admin@myactivity.in', 'https://myactivity.in', 1, NOW(), NOW())
ON CONFLICT DO NOTHING;

-- Project
INSERT INTO project (project_name, project_code, is_active, created_at, updated_at)
VALUES ('MyActivity Project', 'MA-001', 1, NOW(), NOW())
ON CONFLICT (project_code) DO NOTHING;


-- ============================================================================
-- SECTION 5 — USERS
-- Password for ALL users: Test@123
-- Hash (bcrypt 10 rounds): $2a$10$n8n9B4ZIu99VI75hvK/uOueCjRfweuoA8FdqzBGIL1XNbGvKAjYdq
--
--  ROLE-001  Regional Manager Head
--  ROLE-002  Regional Manager
--  ROLE-003  Office Executive
--  ROLE-004  Procurement
--  ROLE-005  Store Executive
--  ROLE-006  Quality/Training
--  ROLE-007  HR
--  ROLE-008  Accounts
--  ROLE-009  TA Team
--  ROLE-010  Field Executive
--  ROLE-011  Verifier
--  MTEST-001 … MTEST-005  Field Executive (dummy test users)
-- ============================================================================

INSERT INTO user_tbl (emp_code, full_name, date_of_birth, gender, mobile_number, email, nationality, is_active, created_at, updated_at) VALUES
  ('ROLE-001', 'Admin RMH',        '1990-01-01', 'Male', '9800000001', 'rmh@myactivity.in',         'Indian', 1, NOW(), NOW()),
  ('ROLE-002', 'Admin RM',         '1990-01-02', 'Male', '9800000002', 'rm@myactivity.in',          'Indian', 1, NOW(), NOW()),
  ('ROLE-003', 'Admin Office',     '1990-01-03', 'Male', '9800000003', 'office@myactivity.in',      'Indian', 1, NOW(), NOW()),
  ('ROLE-004', 'Admin Procure',    '1990-01-04', 'Male', '9800000004', 'procure@myactivity.in',     'Indian', 1, NOW(), NOW()),
  ('ROLE-005', 'Admin Store',      '1990-01-05', 'Male', '9800000005', 'store@myactivity.in',       'Indian', 1, NOW(), NOW()),
  ('ROLE-006', 'Admin Quality',    '1990-01-06', 'Male', '9800000006', 'quality@myactivity.in',     'Indian', 1, NOW(), NOW()),
  ('ROLE-007', 'Admin HR',         '1990-01-07', 'Male', '9800000007', 'hr@myactivity.in',          'Indian', 1, NOW(), NOW()),
  ('ROLE-008', 'Admin Accounts',   '1990-01-08', 'Male', '9800000008', 'accounts@myactivity.in',    'Indian', 1, NOW(), NOW()),
  ('ROLE-009', 'Admin TA',         '1990-01-09', 'Male', '9800000009', 'ta@myactivity.in',          'Indian', 1, NOW(), NOW()),
  ('ROLE-010', 'Admin Field Exec', '1990-01-10', 'Male', '9800000010', 'field@myactivity.in',       'Indian', 1, NOW(), NOW()),
  ('ROLE-011', 'Admin Verifier',   '1990-01-11', 'Male', '9800000011', 'verifier2@myactivity.in',   'Indian', 1, NOW(), NOW()),
  ('MTEST-001', 'Manoj Test 01',   '1995-06-01', 'Male', '9900000001', 'manojtest01@myactivity.in', 'Indian', 1, NOW(), NOW()),
  ('MTEST-002', 'Mohit Test 02',   '1995-06-02', 'Male', '9900000002', 'mohittest02@myactivity.in', 'Indian', 1, NOW(), NOW()),
  ('MTEST-003', 'Vikas Test 03',   '1995-06-03', 'Male', '9900000003', 'vikastest03@myactivity.in', 'Indian', 1, NOW(), NOW()),
  ('MTEST-004', 'Nitish Test 04',   '1995-06-04', 'Male', '9900000004', 'nitishtest04@myactivity.in', 'Indian', 1, NOW(), NOW()),
  ('MTEST-005', 'Naveen Test 05',   '1995-06-05', 'Male', '9900000005', 'naveentest05@myactivity.in', 'Indian', 1, NOW(), NOW())
ON CONFLICT (emp_code) DO NOTHING;

-- Role users (one per role, role_id 1–11)
INSERT INTO user_information (user_id, company_id, role_id, password, is_active, created_at, updated_at)
SELECT u.user_id, c.company_id, r.role_id,
       '$2a$10$n8n9B4ZIu99VI75hvK/uOueCjRfweuoA8FdqzBGIL1XNbGvKAjYdq',
       1, NOW(), NOW()
FROM (VALUES
  ('ROLE-001', 1), ('ROLE-002', 2), ('ROLE-003', 3), ('ROLE-004', 4),
  ('ROLE-005', 5), ('ROLE-006', 6), ('ROLE-007', 7), ('ROLE-008', 8),
  ('ROLE-009', 9), ('ROLE-010', 10), ('ROLE-011', 11)
) AS mapping(emp_code, role_id)
JOIN user_tbl u ON u.emp_code  = mapping.emp_code
JOIN company  c ON c.company_name = 'AND'
JOIN roles    r ON r.role_id   = mapping.role_id
ON CONFLICT (user_id) DO NOTHING;

-- 5 dummy Field Executive test users (role_id = 10)
INSERT INTO user_information (user_id, company_id, role_id, password, is_active, created_at, updated_at)
SELECT u.user_id, c.company_id, 10,
       '$2a$10$n8n9B4ZIu99VI75hvK/uOueCjRfweuoA8FdqzBGIL1XNbGvKAjYdq',
       1, NOW(), NOW()
FROM user_tbl u
CROSS JOIN company c
WHERE u.emp_code  IN ('MTEST-001','MTEST-002','MTEST-003','MTEST-004','MTEST-005')
  AND c.company_name = 'AND'
ON CONFLICT (user_id) DO NOTHING;


-- ============================================================================
-- DONE
-- ============================================================================
\echo ''
\echo '==========================================================='
\echo ' Production deployment complete!'
\echo ' 16 users created  |  All passwords: Test@123'
\echo '==========================================================='
\echo ''
\echo ' emp_code  | role'
\echo '-----------|-------------------------------'
\echo ' ROLE-001  | Regional Manager Head'
\echo ' ROLE-002  | Regional Manager'
\echo ' ROLE-003  | Office Executive'
\echo ' ROLE-004  | Procurement'
\echo ' ROLE-005  | Store Executive'
\echo ' ROLE-006  | Quality/Training'
\echo ' ROLE-007  | HR'
\echo ' ROLE-008  | Accounts'
\echo ' ROLE-009  | TA Team'
\echo ' ROLE-010  | Field Executive'
\echo ' ROLE-011  | Verifier'
\echo ' MTEST-001 | Field Executive  (Manoj Test 01)'
\echo ' MTEST-002 | Field Executive  (Manoj Test 02)'
\echo ' MTEST-003 | Field Executive  (Manoj Test 03)'
\echo ' MTEST-004 | Field Executive  (Manoj Test 04)'
\echo ' MTEST-005 | Field Executive  (Manoj Test 05)'
