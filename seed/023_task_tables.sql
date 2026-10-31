-- Seed data for ddl/023_task_tables.sql
-- (Existing databases were reset to this exact list by ddl/091_reset_task_categories.sql.)
SET search_path TO myactivity;

-- ── Categories ──────────────────────────────────────────────────────────────
INSERT INTO task_category (category_name, sort_order) VALUES
    ('Regular Maintenance',    1),
    ('Demo',                   2),
    ('Documentation',          3),
    ('Implementation',         4),
    ('Marketing',              5),
    ('Teacher Training',       6),
    ('Preventive Maintenance', 7),
    ('Physical Verification',  8)
ON CONFLICT (category_name) DO NOTHING;

-- ── Sub-Categories ──────────────────────────────────────────────────────────
INSERT INTO task_sub_category (category_id, sub_category_name, sort_order)
SELECT c.category_id, s.sub_category_name, s.sort_order
FROM (VALUES
    -- Regular Maintenance
    ('Regular Maintenance',    'Regular Maintenance',                1),
    ('Regular Maintenance',    'Technical Issue',                    2),
    ('Regular Maintenance',    'Software Issue',                     3),
    -- Demo
    ('Demo',                   'Demo',                               1),
    -- Documentation
    ('Documentation',          'Student Data',                       1),
    ('Documentation',          'Report',                             2),
    -- Implementation
    ('Implementation',         'Survey',                             1),
    ('Implementation',         'Material Delivery',                  2),
    ('Implementation',         'Installation',                       3),
    ('Implementation',         'Training',                           4),
    -- Marketing
    ('Marketing',              'Marketing',                          1),
    -- Teacher Training
    ('Teacher Training',       'Teacher Training',                   1),
    -- Preventive Maintenance
    ('Preventive Maintenance', 'Basic Preventive Maintenance',       1),
    ('Preventive Maintenance', 'Detailed Preventive Maintenance',    2),
    -- Physical Verification
    ('Physical Verification',  'Physical Verification',              1)
) AS s(category_name, sub_category_name, sort_order)
JOIN task_category c ON c.category_name = s.category_name
ON CONFLICT (category_id, sub_category_name) DO NOTHING;
