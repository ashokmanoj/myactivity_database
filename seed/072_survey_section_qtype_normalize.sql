-- Seed data for ddl/072_survey_section_qtype_normalize.sql — the 6 fixed
-- survey answer types.
SET search_path TO myactivity;

INSERT INTO survey_question_type (type_name, sort_order) VALUES
    ('text',    1),
    ('number',  2),
    ('boolean', 3),
    ('select',  4),
    ('photo',   5),
    ('decimal', 6)
ON CONFLICT (type_name) DO NOTHING;
