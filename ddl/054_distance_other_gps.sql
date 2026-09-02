-- DDL 054: GPS tracking for "Other" trips, mirroring gps_location but FK'd to
-- distance_other_trip instead of distance_tracking (a separate SERIAL sequence,
-- so the two trip tables' ids can collide — a parallel table is required
-- rather than reusing gps_location, whose trip_id is a hard FK to
-- distance_tracking(id) ON DELETE CASCADE with no discriminator column).
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS distance_other_gps (
    id          BIGSERIAL       PRIMARY KEY,
    trip_id     INT             NOT NULL REFERENCES distance_other_trip(id) ON DELETE CASCADE,
    user_id     INT             REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    uuid        VARCHAR(100)    UNIQUE,
    latitude    NUMERIC(10,7)   NOT NULL,
    longitude   NUMERIC(10,7)   NOT NULL,
    altitude    NUMERIC(8,2),
    timestamp   BIGINT          NOT NULL,
    created_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dog_trip_id   ON distance_other_gps(trip_id);
CREATE INDEX IF NOT EXISTS idx_dog_user_id   ON distance_other_gps(user_id);
CREATE INDEX IF NOT EXISTS idx_dog_timestamp ON distance_other_gps(timestamp);
