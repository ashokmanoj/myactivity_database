-- Add village to institution, alongside the existing address/pincode location detail.
ALTER TABLE myactivity.institution
  ADD COLUMN IF NOT EXISTS village VARCHAR(255) DEFAULT NULL;
