-- Add Material Dispatch expense fields (driver + vehicle details).
ALTER TABLE myactivity.expense_tbl
  ADD COLUMN IF NOT EXISTS driver_name    VARCHAR(150) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS driver_number  VARCHAR(20)  DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS vehicle_number VARCHAR(30)  DEFAULT NULL;
