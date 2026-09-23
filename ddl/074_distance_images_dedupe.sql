-- DDL 074: De-duplicate distance_images by content — the upload storage now
-- names files after a SHA-256 hash of their bytes (see middleware/upload.js),
-- so identical photos re-uploaded on a sync retry resolve to the same
-- image_name. This adds a unique constraint so the controller can upsert
-- (reuse the existing row) instead of inserting a fresh duplicate row every
-- time, and first merges any duplicate rows that already exist from before
-- this fix (same image_name, multiple ids) so the constraint can be added
-- cleanly on any environment, regardless of how much duplicate history it has.
SET search_path TO myactivity;

DO $$
DECLARE
  dup RECORD;
  keep_id INT;
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes
    WHERE schemaname = 'myactivity' AND indexname = 'uq_distance_images_name'
  ) THEN
    FOR dup IN
      SELECT image_name FROM distance_images GROUP BY image_name HAVING COUNT(*) > 1
    LOOP
      SELECT MIN(id) INTO keep_id FROM distance_images WHERE image_name = dup.image_name;

      UPDATE distance_tracking SET start_image_id = keep_id
      WHERE start_image_id IN (SELECT id FROM distance_images WHERE image_name = dup.image_name AND id <> keep_id);

      UPDATE distance_tracking SET end_image_id = keep_id
      WHERE end_image_id IN (SELECT id FROM distance_images WHERE image_name = dup.image_name AND id <> keep_id);

      DELETE FROM distance_images WHERE image_name = dup.image_name AND id <> keep_id;
    END LOOP;

    CREATE UNIQUE INDEX uq_distance_images_name ON distance_images(image_name);
  END IF;
END $$;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','074_distance_images_dedupe.sql') ON CONFLICT DO NOTHING;
