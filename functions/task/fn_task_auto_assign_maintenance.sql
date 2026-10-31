-- Function: fn_task_auto_assign_maintenance  |  Domain: task
-- Per institution: for every institution mapped to the user in
-- user_institution_map (active mapping + active institution) where that user
-- has no open task (Pending / In Progress) at that institution, assigns one
-- "Regular Maintenance → Regular Maintenance" task there, due the same day
-- it's created. Institutions that already have an open task for the user are
-- left alone. The advisory lock stops two simultaneous callers (the 5-minute
-- job and an app request) from creating the same task twice. Returns the
-- number created.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_task_auto_assign_maintenance(p_user_id INT)
RETURNS INT AS $$
DECLARE
    v_category_id     INT;
    v_sub_category_id INT;
    v_count           INT;
BEGIN
    PERFORM pg_advisory_xact_lock(hashtext('task_auto_assign'), p_user_id);

    SELECT c.category_id, s.sub_category_id
    INTO v_category_id, v_sub_category_id
    FROM task_category c
    JOIN task_sub_category s ON s.category_id = c.category_id
    WHERE c.category_name = 'Regular Maintenance'
      AND s.sub_category_name = 'Regular Maintenance';

    IF v_sub_category_id IS NULL THEN
        RETURN 0;
    END IF;

    INSERT INTO assign_task_list (
        project_id, category_id, sub_category_id,
        district, block, priority, executive_id, institution_id,
        start_date, end_date, remarks, status, created_by
    )
    SELECT DISTINCT ON (m.institution_id)
        m.project_id, v_category_id, v_sub_category_id,
        d.district_name, b.block_name, 'Medium', p_user_id, m.institution_id,
        CURRENT_DATE, CURRENT_DATE,
        'Auto-assigned: no open task at this institution', 'Pending', NULL
    FROM user_institution_map m
    JOIN institution   i ON i.institute_id = m.institution_id AND i.is_active = 1
    LEFT JOIN district d ON d.district_id  = m.district_id
    LEFT JOIN block    b ON b.block_id     = m.block_id
    WHERE m.user_id = p_user_id
      AND m.active  = 1
      AND NOT EXISTS (
          SELECT 1 FROM assign_task_list t
          WHERE t.executive_id   = p_user_id
            AND t.institution_id = m.institution_id
            AND t.status IN ('Pending', 'In Progress')
      )
    ORDER BY m.institution_id, m.map_id DESC;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;
