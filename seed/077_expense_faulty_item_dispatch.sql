-- Seed data for ddl/077_expense_faulty_item_dispatch.sql
SET search_path TO myactivity;

INSERT INTO expense_purpose_tbl (name, applies_to)
VALUES ('Faulty Item Sent To Store', 'both')
ON CONFLICT (LOWER(name), COALESCE(company_id, 0)) DO NOTHING;
