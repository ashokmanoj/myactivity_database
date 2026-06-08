-- Backfill rm_user_id in distance_tracking for trips where it was never stored.
-- Step 1: from user_institution_map (where rm_user_id is set)
-- Step 2: from user_information.reporting_rm name match (fallback)
-- Safe to re-run: only updates rows where rm_user_id IS NULL.
SET search_path TO myactivity;

-- Step 1: match via user_institution_map
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

-- Step 2: match via reporting_rm full-name stored in user_information
UPDATE distance_tracking dt
SET rm_user_id = (
    SELECT u.user_id
    FROM user_tbl u
    JOIN user_information ui ON ui.user_id = dt.user_id
    WHERE u.full_name = ui.reporting_rm
      AND u.is_active = 1
    LIMIT 1
)
WHERE dt.rm_user_id IS NULL;
