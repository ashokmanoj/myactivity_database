-- ============================================================================
-- DDL 005: location_type, locations, location_photos
-- ============================================================================
SET search_path TO myactivity;

-- Master list for the mobile "Add Location" Location Type dropdown
-- (School, Home, BEO Office, ...) — rows live in database/seed/005_location_track.sql.
CREATE TABLE IF NOT EXISTS location_type (
    location_type_id   SERIAL PRIMARY KEY,
    location_type_name VARCHAR(50) NOT NULL UNIQUE,
    sort_order         INT         NOT NULL DEFAULT 0,
    is_active          SMALLINT    NOT NULL DEFAULT 1,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

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
    project_id     INT REFERENCES project(project_id),
    project_name   VARCHAR(200),
    is_active      SMALLINT    NOT NULL DEFAULT 1,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
-- Mobile "Add Location" project dropdown (projects in the user's state of
-- posting) — ALTER so databases created before this column also get it.
ALTER TABLE locations
    ADD COLUMN IF NOT EXISTS project_id   INT REFERENCES project(project_id),
    ADD COLUMN IF NOT EXISTS project_name VARCHAR(200);
CREATE INDEX IF NOT EXISTS idx_loc_user    ON locations(user_id);
CREATE INDEX IF NOT EXISTS idx_loc_active  ON locations(is_active);
CREATE INDEX IF NOT EXISTS idx_loc_project ON locations(project_id);

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


