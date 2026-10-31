-- Seed data for ddl/005_location_track.sql
SET search_path TO myactivity;

INSERT INTO location_type (location_type_name, sort_order) VALUES
    ('School',          1),
    ('Home',            2),
    ('Courier Office',  3),
    ('BEO Office',      4),
    ('Store',           5),
    ('Studio',          6),
    ('IS Office',       7),
    ('DPO Office',      8),
    ('Block Office',    9),
    ('Xerox',          10),
    ('Others',         11)
ON CONFLICT (location_type_name) DO NOTHING;
