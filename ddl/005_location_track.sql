-- ============================================================================
-- DDL 005: locations, location_photos
-- ============================================================================
SET search_path TO public;

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
    institution_id INT REFERENCES instituation(institute_id),
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

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','005_location_track.sql') ON CONFLICT DO NOTHING;
