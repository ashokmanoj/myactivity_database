-- DDL 057: Track who marked an expense as paid, and when
-- Mirrors distance_tracking.payment_by / payment_at.
SET search_path TO myactivity;

ALTER TABLE expense_tbl
  ADD COLUMN IF NOT EXISTS payment_by INT REFERENCES user_tbl(user_id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS payment_at TIMESTAMPTZ;
