-- Function: fn_task_photo_category_get_all  |  Domain: task_photo
-- Active photo categories (Podium Photo, Classroom Photo, …) in display order —
-- what the mobile app offers when capturing a task photo.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_photo_category_get_all()
RETURNS TABLE (
  photo_category_id INT,
  category_name     VARCHAR,
  sort_order        INT
) AS $$
BEGIN
  RETURN QUERY
  SELECT c.photo_category_id, c.category_name, c.sort_order
  FROM task_photo_category c
  WHERE c.is_active = 1
  ORDER BY c.sort_order, c.category_name;
END;
$$ LANGUAGE plpgsql;
