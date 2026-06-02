-- ============================================================================
-- DML 006: Seed – Standard School Preventive Maintenance Questions
-- Safe to re-run: ON CONFLICT (q_id) DO NOTHING
-- ============================================================================
SET search_path TO myactivity;

INSERT INTO pm_question (q_id, question, q_type, sort_order, is_active)
VALUES
    ('Q_PM_001', 'Is the school infrastructure adequate?',              'yesNo', 1,  TRUE),
    ('Q_PM_002', 'Is clean drinking water available?',                  'yesNo', 2,  TRUE),
    ('Q_PM_003', 'Are functional toilets available for students?',      'yesNo', 3,  TRUE),
    ('Q_PM_004', 'Is there adequate classroom furniture?',              'yesNo', 4,  TRUE),
    ('Q_PM_005', 'Is the electrical supply functional?',                'yesNo', 5,  TRUE),
    ('Q_PM_006', 'Are sanitation facilities properly maintained?',      'yesNo', 6,  TRUE),
    ('Q_PM_007', 'Is the playground/sports area well-maintained?',      'yesNo', 7,  TRUE),
    ('Q_PM_008', 'Is there proper ventilation in classrooms?',          'yesNo', 8,  TRUE),
    ('Q_PM_009', 'Are school records and documents up to date?',        'yesNo', 9,  TRUE),
    ('Q_PM_010', 'Is the school boundary wall/fencing secure?',         'yesNo', 10, TRUE)
ON CONFLICT (q_id) DO NOTHING;
