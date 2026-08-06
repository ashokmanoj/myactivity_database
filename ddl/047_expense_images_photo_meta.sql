-- Per-photo metadata: which kind of photo it is (bill vs hotel) and the GPS
-- location it was taken at, instead of only one shared stay_lat/stay_lng per expense.
ALTER TABLE myactivity.expense_images
  ADD COLUMN IF NOT EXISTS image_type     VARCHAR(20)   DEFAULT 'bill',
  ADD COLUMN IF NOT EXISTS photo_lat      NUMERIC(10,7) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS photo_lng      NUMERIC(10,7) DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS photo_location VARCHAR(500)  DEFAULT NULL;
