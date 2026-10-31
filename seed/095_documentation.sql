-- Seed data for ddl/095_documentation.sql
-- Report types and the states each one applies to. State names must match
-- project.state (compared case-insensitively by fn_documentation_report_type_get_all).
SET search_path TO myactivity;

INSERT INTO documentation_report_type (report_type_name, sort_order) VALUES
    ('Distal water Refilled', 1),
    ('RAFT-SOP',              2),
    ('Scholarship',           3),
    ('School Training',       4),
    ('School Visit Report',   5),
    ('sub-meter',             6),
    ('Timetable',             7),
    ('Tool kit',              8)
ON CONFLICT (report_type_name) DO NOTHING;

INSERT INTO documentation_report_type_state (report_type_id, state_name)
SELECT t.id, s.state_name
FROM (VALUES
    ('Distal water Refilled', ARRAY['Assam', 'Uttarakhand', 'Odisha']),
    ('RAFT-SOP',              ARRAY['Assam', 'Uttarakhand', 'Odisha', 'Tripura', 'Mizoram', 'Sikkim']),
    ('Scholarship',           ARRAY['Assam', 'Uttarakhand', 'Odisha', 'Tripura', 'Mizoram', 'Sikkim']),
    ('School Training',       ARRAY['Assam', 'Uttarakhand', 'Odisha', 'Tripura', 'Mizoram', 'Sikkim']),
    ('School Visit Report',   ARRAY['Assam', 'Uttarakhand', 'Odisha']),
    ('sub-meter',             ARRAY['Assam', 'Uttarakhand', 'Odisha']),
    ('Timetable',             ARRAY['Assam', 'Uttarakhand', 'Odisha']),
    ('Tool kit',              ARRAY['Assam', 'Uttarakhand', 'Odisha', 'Tripura', 'Mizoram', 'Sikkim'])
) AS m(report_type_name, states)
JOIN documentation_report_type t ON t.report_type_name = m.report_type_name
CROSS JOIN LATERAL UNNEST(m.states) AS s(state_name)
ON CONFLICT (report_type_id, state_name) DO NOTHING;
