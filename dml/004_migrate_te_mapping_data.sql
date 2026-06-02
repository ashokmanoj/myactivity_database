-- ============================================================================
-- DML 004: Migrate legacy TE mapping data from tech_exec_institution_map
--          into the new user_institution_map table.
-- Safe to run multiple times (NOT EXISTS guard prevents duplicates).
-- Records without a resolvable project_id are skipped.
-- ============================================================================
SET search_path TO myactivity;

DO $$
DECLARE
  v_migrated INT := 0;
BEGIN
  -- Only run if the legacy table exists
  IF NOT EXISTS (
    SELECT FROM information_schema.tables
    WHERE table_schema = 'myactivity' AND table_name = 'tech_exec_institution_map'
  ) THEN
    RAISE NOTICE 'Legacy table tech_exec_institution_map not found — skipping migration.';
    RETURN;
  END IF;

  INSERT INTO user_institution_map
    (project_id, district_id, block_id, institution_id, user_id, rm_user_id, active, created_at, updated_at)
  SELECT
    COALESCE(
      -- Prefer project from institution_project_map link
      (SELECT ipm.project_id
       FROM   institution_project_map ipm
       WHERE  ipm.institute_id = tem.institute_id AND ipm.is_active = 1
       ORDER  BY ipm.institute_project_map_id
       LIMIT  1),
      -- Fallback: project stored directly on institution
      i.project_id
    )                    AS project_id,
    i.district_id,
    i.block_id,
    tem.institute_id     AS institution_id,
    tem.user_id,
    tem.assigned_by      AS rm_user_id,
    tem.is_active        AS active,
    tem.created_at,
    tem.updated_at
  FROM  tech_exec_institution_map tem
  JOIN  institution i ON i.institute_id = tem.institute_id
  WHERE tem.is_active = 1
    -- Skip records where project cannot be determined (NOT NULL constraint)
    AND COALESCE(
          (SELECT ipm.project_id FROM institution_project_map ipm
           WHERE ipm.institute_id = tem.institute_id AND ipm.is_active = 1
           ORDER BY ipm.institute_project_map_id LIMIT 1),
          i.project_id
        ) IS NOT NULL
    -- Idempotency: skip already-migrated records
    AND NOT EXISTS (
      SELECT 1 FROM user_institution_map uim
      WHERE uim.user_id        = tem.user_id
        AND uim.institution_id = tem.institute_id
        AND uim.active         = 1
    );

  GET DIAGNOSTICS v_migrated = ROW_COUNT;
  RAISE NOTICE 'Migrated % record(s) from legacy tech_exec_institution_map.', v_migrated;
END $$;
