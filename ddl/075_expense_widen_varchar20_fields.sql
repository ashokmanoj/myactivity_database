-- DDL 075: Widen a couple of expense_tbl columns that were sized VARCHAR(20)
-- as short enum-style fields, but broke in production with "value too long
-- for type character varying(20)" on a Food expense submission from the
-- mobile app — state_type ('Within State'/'Other State') and payment_method
-- ('Cash'/'Online'/'UPI'/'Card') are both meant to hold a short label, but
-- nothing enforces that on the client side, so a longer value (a fuller
-- description, a different wording, etc.) hard-crashes the insert instead of
-- just being stored. Matches the same VARCHAR(100) precedent food_sub_type
-- already uses for this exact class of risk (042_expense_purpose_fields.sql).
SET search_path TO myactivity;

ALTER TABLE expense_tbl ALTER COLUMN state_type      TYPE VARCHAR(50);
ALTER TABLE expense_tbl ALTER COLUMN payment_method  TYPE VARCHAR(50);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','075_expense_widen_varchar20_fields.sql') ON CONFLICT DO NOTHING;
