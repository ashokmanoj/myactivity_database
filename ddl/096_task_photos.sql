-- ============================================================================
-- DDL 096: Task photo evidence, categorised.
--
--   task_photo_category — master list of the kinds of photo a task can ask
--                         for (Podium Photo, Classroom Photo, Antenna Photo …).
--                         Seed rows live in database/seed/096_task_photo_category.sql
--                         (DDL files are schema-only).
--   task_photos         — one row per photo taken for a task during a visit,
--                         tagged with its photo category. Image bytes live in
--                         DigitalOcean Spaces; only the URL is stored here
--                         (image_name + fullpath_url, same shape as DDL 089).
--
-- The visit is referenced by visit_uuid, not visit_details.id, same as
-- task_activity (DDL 085): the mobile app creates visits offline and only
-- knows their client-generated uuid until they sync.
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS task_photo_category (
    photo_category_id   SERIAL        PRIMARY KEY,
    category_name       VARCHAR(100)  NOT NULL UNIQUE,
    sort_order          INT           NOT NULL DEFAULT 0,
    is_active           SMALLINT      NOT NULL DEFAULT 1,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS task_photos (
    task_photo_id       SERIAL        PRIMARY KEY,
    uuid                VARCHAR(100)  UNIQUE, -- client-generated, for offline-sync dedup
    visit_uuid          VARCHAR(100)  REFERENCES visit_details(uuid)                    ON DELETE SET NULL,
    task_id             INT           REFERENCES assign_task_list(task_id)              ON DELETE SET NULL,
    photo_category_id   INT           NOT NULL REFERENCES task_photo_category(photo_category_id),
    image_name          VARCHAR(255),
    fullpath_url        VARCHAR(1000),
    is_active           SMALLINT      NOT NULL DEFAULT 1,
    created_by          INT           REFERENCES user_tbl(user_id)                      ON DELETE SET NULL,
    created_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_task_photos_visit_uuid ON task_photos(visit_uuid);
CREATE INDEX IF NOT EXISTS idx_task_photos_task_id    ON task_photos(task_id);
CREATE INDEX IF NOT EXISTS idx_task_photos_category   ON task_photos(photo_category_id);
