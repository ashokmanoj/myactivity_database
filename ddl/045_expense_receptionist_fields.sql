-- Add hotel receptionist contact fields to expense_tbl
ALTER TABLE myactivity.expense_tbl
  ADD COLUMN IF NOT EXISTS receptionist_name  VARCHAR(200) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS receptionist_phone VARCHAR(20)  DEFAULT NULL;
