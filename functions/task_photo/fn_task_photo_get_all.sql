-- Function: fn_task_photo_get_all  |  Domain: task_photo
-- Active task photos with their category name, oldest first (capture order).
-- Every filter is optional; p_visit_uuids narrows to a set of visits (the
-- Activity page asks for just the visits on its current page).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_photo_get_all(
  p_visit_uuids       VARCHAR[] DEFAULT NULL,
  p_task_id           INT       DEFAULT NULL,
  p_photo_category_id INT       DEFAULT NULL
)
RETURNS TABLE (
  task_photo_id     INT,
  uuid              VARCHAR,
  visit_uuid        VARCHAR,
  task_id           INT,
  photo_category_id INT,
  category_name     VARCHAR,
  category_order    INT,
  image_name        VARCHAR,
  fullpath_url      VARCHAR,
  created_by        INT,
  created_at        TIMESTAMPTZ
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    p.task_photo_id, p.uuid, p.visit_uuid, p.task_id,
    p.photo_category_id, c.category_name, c.sort_order,
    p.image_name, p.fullpath_url, p.created_by, p.created_at
  FROM task_photos p
  JOIN task_photo_category c ON c.photo_category_id = p.photo_category_id
  WHERE p.is_active = 1
    AND (p_visit_uuids       IS NULL OR p.visit_uuid        = ANY(p_visit_uuids))
    AND (p_task_id           IS NULL OR p.task_id           = p_task_id)
    AND (p_photo_category_id IS NULL OR p.photo_category_id = p_photo_category_id)
  ORDER BY c.sort_order, p.created_at;
END;
$$ LANGUAGE plpgsql;
