-- Function: fn_task_get_sub_categories  |  Domain: task
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_get_sub_categories(
    p_category_id INT DEFAULT NULL
)
RETURNS TABLE(
    sub_category_id   INT,
    category_id       INT,
    sub_category_name VARCHAR,
    sort_order        INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT s.sub_category_id, s.category_id, s.sub_category_name, s.sort_order
    FROM task_sub_category s
    WHERE s.is_active = 1
      AND (p_category_id IS NULL OR s.category_id = p_category_id)
    ORDER BY s.sort_order ASC;
END;
$$ LANGUAGE plpgsql;
