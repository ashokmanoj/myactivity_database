-- ============================================================================
-- DDL 091: Replace the whole task category / sub-category list with the new
-- business list (8 categories, 15 sub-categories), numbered from 1 again.
-- One-time reset, kept in ddl/ on purpose (see seed/README.md): it must wipe
-- whatever rows exist at this point in migration history. The same list is in
-- seed/023_task_tables.sql for fresh databases.
--
-- assign_task_list.category_id / sub_category_id have no ON DELETE action, so
-- existing tasks are detached (set to NULL) first — the tasks themselves are
-- kept, they just show no category until reassigned.
-- ============================================================================
SET search_path TO myactivity;

UPDATE assign_task_list
SET category_id = NULL, sub_category_id = NULL
WHERE category_id IS NOT NULL OR sub_category_id IS NOT NULL;

DELETE FROM task_sub_category;
DELETE FROM task_category;

ALTER SEQUENCE task_category_category_id_seq         RESTART WITH 1;
ALTER SEQUENCE task_sub_category_sub_category_id_seq RESTART WITH 1;

INSERT INTO task_category (category_name, sort_order) VALUES
    ('Regular Maintenance',    1),
    ('Demo',                   2),
    ('Documentation',          3),
    ('Implementation',         4),
    ('Marketing',              5),
    ('Teacher Training',       6),
    ('Preventive Maintenance', 7),
    ('Physical Verification',  8);

INSERT INTO task_sub_category (category_id, sub_category_name, sort_order)
SELECT c.category_id, s.sub_category_name, s.sort_order
FROM (VALUES
    ('Regular Maintenance',    'Regular Maintenance',             1, 1),
    ('Regular Maintenance',    'Technical Issue',                 2, 2),
    ('Regular Maintenance',    'Software Issue',                  3, 3),
    ('Demo',                   'Demo',                            1, 4),
    ('Documentation',          'Student Data',                    1, 5),
    ('Documentation',          'Report',                          2, 6),
    ('Implementation',         'Survey',                          1, 7),
    ('Implementation',         'Material Delivery',               2, 8),
    ('Implementation',         'Installation',                    3, 9),
    ('Implementation',         'Training',                        4, 10),
    ('Marketing',              'Marketing',                       1, 11),
    ('Teacher Training',       'Teacher Training',                1, 12),
    ('Preventive Maintenance', 'Basic Preventive Maintenance',    1, 13),
    ('Preventive Maintenance', 'Detailed Preventive Maintenance', 2, 14),
    ('Physical Verification',  'Physical Verification',           1, 15)
) AS s(category_name, sub_category_name, sort_order, seq)
JOIN task_category c ON c.category_name = s.category_name
ORDER BY s.seq;

-- Implementation → Survey drives the mobile survey form (see DDL 071).
UPDATE task_sub_category s
SET is_survey = 1
FROM task_category c
WHERE s.category_id = c.category_id
  AND c.category_name = 'Implementation'
  AND s.sub_category_name = 'Survey';
