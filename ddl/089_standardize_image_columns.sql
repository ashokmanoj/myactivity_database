-- DDL 089: Standardize every dedicated per-image table to the same two-column
-- shape: image_name (bare filename) + fullpath_url (the full DigitalOcean
-- Spaces URL) — matching what location_photos already looked like.
-- Each block is guarded so this file is safe to re-run after it has already
-- applied (RENAME COLUMN isn't idempotent on its own).
SET search_path TO myactivity;

-- expense_images: had only image_path (held the full URL) — split into
-- image_name (backfilled from the URL's last path segment) + fullpath_url.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_schema = 'myactivity' AND table_name = 'expense_images' AND column_name = 'image_path') THEN
    ALTER TABLE expense_images ADD COLUMN IF NOT EXISTS image_name VARCHAR(255);
    UPDATE expense_images SET image_name = regexp_replace(image_path, '^.*/', '')
      WHERE image_name IS NULL AND image_path IS NOT NULL;
    ALTER TABLE expense_images ALTER COLUMN image_path TYPE VARCHAR(1000);
    ALTER TABLE expense_images RENAME COLUMN image_path TO fullpath_url;
  END IF;
END $$;

-- distance_images: already had image_name — just rename full_path for
-- naming consistency with the other three tables.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_schema = 'myactivity' AND table_name = 'distance_images' AND column_name = 'full_path') THEN
    ALTER TABLE distance_images RENAME COLUMN full_path TO fullpath_url;
  END IF;
END $$;

-- location_photos: already had fullpath_url — just rename photo_filename
-- to image_name for naming consistency.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_schema = 'myactivity' AND table_name = 'location_photos' AND column_name = 'photo_filename') THEN
    ALTER TABLE location_photos RENAME COLUMN photo_filename TO image_name;
  END IF;
END $$;

-- task_activity_images: same split as expense_images.
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns
             WHERE table_schema = 'myactivity' AND table_name = 'task_activity_images' AND column_name = 'image_path') THEN
    ALTER TABLE task_activity_images ADD COLUMN IF NOT EXISTS image_name VARCHAR(255);
    UPDATE task_activity_images SET image_name = regexp_replace(image_path, '^.*/', '')
      WHERE image_name IS NULL AND image_path IS NOT NULL;
    ALTER TABLE task_activity_images ALTER COLUMN image_path TYPE VARCHAR(1000);
    ALTER TABLE task_activity_images RENAME COLUMN image_path TO fullpath_url;
  END IF;
END $$;
