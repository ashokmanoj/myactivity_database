-- Add Courier expense field (docket / tracking number).
ALTER TABLE myactivity.expense_tbl
  ADD COLUMN IF NOT EXISTS docket_number VARCHAR(50) DEFAULT NULL;
