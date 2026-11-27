-- Seed data for ddl/100_yes_no_option.sql — the Yes / No master options.
-- Explicit ids so the mobile app can rely on 1 = Yes, 2 = No.
SET search_path TO myactivity;

INSERT INTO yes_no_option (id, option_name, sort_order) VALUES
    (1, 'Yes', 1),
    (2, 'No',  2)
ON CONFLICT (option_name) DO NOTHING;

-- Keep the SERIAL past the explicit ids, so a later option added without an id doesn't collide.
SELECT setval(pg_get_serial_sequence('yes_no_option', 'id'), GREATEST((SELECT MAX(id) FROM yes_no_option), 1));
