-- DDL 017: add institution_name column to locations
SET search_path TO myactivity;

ALTER TABLE locations
    ADD COLUMN IF NOT EXISTS institution_name VARCHAR(200);

-- Backfill: rows saved with only institution_id (mobile never sent the name)
-- get the name from the institution master. Safe to re-run — touches NULLs only.
UPDATE locations l
SET    institution_name = i.institution_name
FROM   institution i
WHERE  i.institute_id = l.institution_id
  AND  l.institution_name IS NULL;
