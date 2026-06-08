-- Backfill rm_user_id in distance_tracking for trips where it was never stored.
-- Looks up the RM from user_institution_map based on the executive's user_id.
-- Safe to re-run: only updates rows where rm_user_id IS NULL.
SET search_path TO myactivity;

UPDATE distance_tracking dt
SET rm_user_id = (
    SELECT uim.rm_user_id
    FROM user_institution_map uim
    WHERE uim.user_id    = dt.user_id
      AND uim.active     = 1
      AND uim.rm_user_id IS NOT NULL
    LIMIT 1
)
WHERE dt.rm_user_id IS NULL;
