-- DDL 044: Add payment_method to expense_tbl
SET search_path TO myactivity;

ALTER TABLE expense_tbl
  ADD COLUMN IF NOT EXISTS payment_method VARCHAR(20) NOT NULL DEFAULT 'Cash';
