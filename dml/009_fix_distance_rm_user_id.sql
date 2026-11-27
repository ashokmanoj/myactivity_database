-- Repair distance_tracking.rm_user_id values that point at a user who is NOT
-- a Regional Manager / Regional Manager Head.
--
-- Cause: fn_distance_sync / fn_distance_start used to resolve the RM by
-- matching user_information.reporting_rm against ANY active user's full_name
-- (LIMIT 1). When a non-RM user shares the RM's name (e.g. a test executive
-- account created with the RM's own name), the trip was stored against that
-- user, so it never showed up in the real RM's Distance view.
--
-- Re-resolves those trips the same way the fixed functions do: institution map
-- first, then reporting_rm matched against RM-role users only. Trips that
-- still can't be resolved are left untouched. Safe to re-run.
SET search_path TO myactivity;

-- Preview what will change (run on its own first if you want to check):
-- SELECT dt.id, dt.user_id, dt.rm_user_id AS old_rm_user_id, x.new_rm_user_id
-- FROM distance_tracking dt
-- CROSS JOIN LATERAL (SELECT COALESCE(
--     (SELECT uim.rm_user_id FROM user_institution_map uim
--      WHERE uim.user_id = dt.user_id AND uim.active = 1 AND uim.rm_user_id IS NOT NULL LIMIT 1),
--     (SELECT rm.user_id FROM fn_te_map_get_rms() rm
--      JOIN user_information ui ON ui.user_id = dt.user_id
--      WHERE TRIM(rm.full_name) = TRIM(ui.reporting_rm) LIMIT 1)) AS new_rm_user_id) x
-- WHERE dt.rm_user_id IS NOT NULL
--   AND NOT EXISTS (SELECT 1 FROM fn_te_map_get_rms() rm WHERE rm.user_id = dt.rm_user_id)
--   AND x.new_rm_user_id IS NOT NULL;

UPDATE distance_tracking dt
SET    rm_user_id = x.new_rm_user_id,
       updated_at = NOW()
FROM  (
    SELECT dt2.id,
           COALESCE(
             (SELECT uim.rm_user_id FROM user_institution_map uim
              WHERE  uim.user_id = dt2.user_id AND uim.active = 1 AND uim.rm_user_id IS NOT NULL
              LIMIT  1),
             (SELECT rm.user_id FROM fn_te_map_get_rms() rm
              JOIN   user_information ui ON ui.user_id = dt2.user_id
              WHERE  TRIM(rm.full_name) = TRIM(ui.reporting_rm)
              LIMIT  1)
           ) AS new_rm_user_id
    FROM   distance_tracking dt2
    WHERE  dt2.rm_user_id IS NOT NULL
      AND  NOT EXISTS (SELECT 1 FROM fn_te_map_get_rms() rm WHERE rm.user_id = dt2.rm_user_id)
) x
WHERE  dt.id = x.id
  AND  x.new_rm_user_id IS NOT NULL;
