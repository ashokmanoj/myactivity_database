-- Add optional checkout date to expense_tbl so a Stay expense can carry a
-- check-in/check-out date range instead of only a manually entered stay_days count.
ALTER TABLE myactivity.expense_tbl
  ADD COLUMN IF NOT EXISTS checkout_date DATE DEFAULT NULL;
