-- ============================================================================
-- DDL 090: tool_kit_images — a field executive's tool kit, photographed for
-- verification. One row per photo; image bytes live in DigitalOcean Spaces,
-- only the resulting URL is stored here (image_name + fullpath_url, the same
-- standardized shape as location_photos/expense_images/distance_images/
-- task_activity_images — see DDL 089).
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS tool_kit_images (
    tool_kit_image_id SERIAL        PRIMARY KEY,
    user_id           INT           NOT NULL REFERENCES user_tbl(user_id),
    uuid              VARCHAR(100)  UNIQUE, -- client-generated, for offline-sync dedup
    image_name        VARCHAR(255),
    fullpath_url      VARCHAR(1000),
    is_active         SMALLINT      NOT NULL DEFAULT 1,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_tool_kit_images_user   ON tool_kit_images(user_id);
CREATE INDEX IF NOT EXISTS idx_tool_kit_images_active ON tool_kit_images(is_active);
