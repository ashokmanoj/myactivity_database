-- Seed data for ddl/023_task_tables.sql
SET search_path TO myactivity;

-- ── Categories ──────────────────────────────────────────────────────────────
INSERT INTO task_category (category_name, sort_order) VALUES
    ('Data collection',  1),
    ('Demo',             2),
    ('Feedback',         3),
    ('Implementation',   4),
    ('Installation',     5),
    ('Maintenance',      6),
    ('Marketing',        7),
    ('Other',            8),
    ('Teacher Training', 9),
    ('Technical issue',  10),
    ('Training',         11)
ON CONFLICT (category_name) DO NOTHING;

-- ── Sub-Categories ──────────────────────────────────────────────────────────
INSERT INTO task_sub_category (category_id, sub_category_name, sort_order)
SELECT c.category_id, s.sub_category_name, s.sort_order
FROM (VALUES
    -- Data collection
    ('Data collection',  'Teacher data',                             1),
    -- Demo
    ('Demo',             'Product demo',                             1),
    ('Demo',             'Setup of demo',                            2),
    -- Feedback
    ('Feedback',         'Parents feedback',                         1),
    ('Feedback',         'Principal / HM feedback',                  2),
    ('Feedback',         'Student feedback',                         3),
    ('Feedback',         'Teacher feedback',                         4),
    -- Implementation
    ('Implementation',   'Dry Run',                                  1),
    ('Implementation',   'Go LIVE',                                  2),
    ('Implementation',   'Installation',                             3),
    ('Implementation',   'Material Delivery',                        4),
    ('Implementation',   'Site Readiness',                           5),
    ('Implementation',   'Survey',                                   6),
    ('Implementation',   'Training',                                 7),
    -- Installation
    ('Installation',     'Installation',                             1),
    ('Installation',     'Partial Installation',                     2),
    ('Installation',     'RAFT configuration',                       3),
    ('Installation',     'Stucle installation',                      4),
    ('Installation',     'TV installation',                          5),
    -- Maintenance
    ('Maintenance',      'Battery Maintanance',                      1),
    ('Maintenance',      'Other',                                    2),
    -- Marketing
    ('Marketing',        'Battery Maintanance',                      1),
    ('Marketing',        'Other',                                    2),
    ('Marketing',        'Principal Meeting',                        3),
    ('Marketing',        'Student Data collect',                     4),
    -- Other
    ('Other',            'Other',                                    1),
    -- Teacher Training
    ('Teacher Training', 'Stucle application training for teacher',  1),
    -- Technical issue
    ('Technical issue',  'Hardware issue',                           1),
    ('Technical issue',  'Material pick up',                         2),
    ('Technical issue',  'Material Replacement',                     3),
    ('Technical issue',  'Send faulty material',                     4),
    ('Technical issue',  'Software issue',                           5),
    -- Training
    ('Training',         'Coordinator training',                     1),
    ('Training',         'Principal / HM training',                  2),
    ('Training',         'Product training',                         3),
    ('Training',         'Teacher training',                         4),
    ('Training',         'Technical executive training',             5)
) AS s(category_name, sub_category_name, sort_order)
JOIN task_category c ON c.category_name = s.category_name
ON CONFLICT (category_id, sub_category_name) DO NOTHING;
