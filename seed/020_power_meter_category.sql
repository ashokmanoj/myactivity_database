-- Seed data for ddl/020_power_meter_category.sql
SET search_path TO myactivity;

INSERT INTO power_meter_category (category_name, sort_order) VALUES
    ('Working',     1),
    ('Not Working', 2)
ON CONFLICT (category_name) DO NOTHING;
