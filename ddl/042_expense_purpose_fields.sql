-- DDL 042: Add purpose-specific columns to expense_tbl
-- Food: state_type, food_sub_type, expense_date
-- Stay: stay_location, stay_lat, stay_lng, stay_days, expense_date (check-in)
SET search_path TO myactivity;

ALTER TABLE expense_tbl
  -- Common: date the expense was incurred (separate from bill_date / created_at)
  ADD COLUMN IF NOT EXISTS expense_date    DATE,

  -- Food-specific
  ADD COLUMN IF NOT EXISTS state_type      VARCHAR(20),   -- 'Within State' | 'Other State'
  ADD COLUMN IF NOT EXISTS food_sub_type   VARCHAR(100),  -- Breakfast | Lunch | Dinner | Snacks etc.

  -- Stay-specific
  ADD COLUMN IF NOT EXISTS hotel_name      VARCHAR(300),  -- hotel / lodge name (free text)
  ADD COLUMN IF NOT EXISTS stay_location   VARCHAR(500),  -- auto-detected GPS address
  ADD COLUMN IF NOT EXISTS stay_lat        NUMERIC(10,7),
  ADD COLUMN IF NOT EXISTS stay_lng        NUMERIC(10,7),
  ADD COLUMN IF NOT EXISTS stay_days       INT;           -- number of nights/days
