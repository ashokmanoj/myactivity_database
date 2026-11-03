-- Seed data for ddl/096_task_photos.sql — the photo categories a task can ask for.
SET search_path TO myactivity;

INSERT INTO task_photo_category (category_name, sort_order) VALUES
    ('Podium Photo',    1),
    ('UPS Battery Photo', 2),
    ('Antenna Photo',   3)
ON CONFLICT (category_name) DO NOTHING;
