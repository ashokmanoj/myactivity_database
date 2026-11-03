-- Function: fn_task_photo_create  |  Domain: task_photo
-- Idempotent on uuid (mobile offline-sync retry safe) — a NULL uuid never
-- conflicts with anything, so submissions without one just insert.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_photo_create(
  p_uuid              VARCHAR,
  p_visit_uuid        VARCHAR,
  p_task_id           INT,
  p_photo_category_id INT,
  p_image_name        VARCHAR,
  p_fullpath_url      VARCHAR,
  p_created_by        INT
)
RETURNS SETOF task_photos AS $$
BEGIN
  RETURN QUERY
  INSERT INTO task_photos (uuid, visit_uuid, task_id, photo_category_id, image_name, fullpath_url, created_by)
  VALUES (p_uuid, p_visit_uuid, p_task_id, p_photo_category_id, p_image_name, p_fullpath_url, p_created_by)
  ON CONFLICT (uuid) DO UPDATE SET
    photo_category_id = EXCLUDED.photo_category_id,
    image_name        = EXCLUDED.image_name,
    fullpath_url      = EXCLUDED.fullpath_url,
    updated_at        = NOW()
  RETURNING *;
END;
$$ LANGUAGE plpgsql;
