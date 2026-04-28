-- ============================================================================
-- DDL 015: distance_images — normalise selfie storage out of distance_tracking
-- ============================================================================
SET search_path TO myactivity;

-- Standalone image record: one row per uploaded file
CREATE TABLE IF NOT EXISTS distance_images (
    id          SERIAL          PRIMARY KEY,
    image_name  VARCHAR(500)    NOT NULL,       -- bare filename  (e.g. uuid.jpg)
    full_path   VARCHAR(1000)   NOT NULL,       -- relative path  (e.g. uploads/distance/uuid.jpg)
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_di_image_name ON distance_images(image_name);

-- Link distance_tracking rows to the images table
ALTER TABLE distance_tracking
    ADD COLUMN IF NOT EXISTS start_image_id INT REFERENCES distance_images(id) ON DELETE SET NULL,
    ADD COLUMN IF NOT EXISTS end_image_id   INT REFERENCES distance_images(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_dt_start_image ON distance_tracking(start_image_id);
CREATE INDEX IF NOT EXISTS idx_dt_end_image   ON distance_tracking(end_image_id);

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.15', '015_distance_images.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
