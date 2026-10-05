-- Seed data for ddl/021_power_meter_receipt_duration.sql
SET search_path TO myactivity;

INSERT INTO power_meter_receipt_duration (duration_label, sort_order) VALUES
    ('Jan 2023 to Sep 2023',   1),
    ('Aug 2023 to Dec 2023',   2),
    ('Oct 2023 to Dec 2023',   3),
    ('Nov 2023 to Dec 2023',   4),
    ('April 2024 to May 2024', 5),
    ('Jan 2024 to March 2024', 6)
ON CONFLICT (duration_label) DO NOTHING;
