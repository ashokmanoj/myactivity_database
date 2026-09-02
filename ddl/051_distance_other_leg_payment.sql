-- Per-leg payment details for "Other" trips — each vehicle/mode in a multi-leg
-- trip (e.g. bike then taxi) now carries its own payment method, amount, and
-- receipt photo, instead of only one shared set of these at the trip level.
ALTER TABLE myactivity.distance_other_leg
  ADD COLUMN IF NOT EXISTS payment_method VARCHAR(20)  DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS amount         NUMERIC(10,2) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS photo_path     VARCHAR(500)  DEFAULT NULL;
