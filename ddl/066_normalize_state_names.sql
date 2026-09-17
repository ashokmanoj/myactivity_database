-- DDL 066: The `state` master table (shown as "States" in the Admin Panel)
-- had stale abbreviated names (KA/MH/TN/TS) left over from an old district
-- import, inconsistent with every other place a state name is stored in this
-- app (district.state_code, distance_tracking.state, distance_state_rate.state
-- all use full names like "Karnataka"). Normalizing so the Create Project
-- page can safely use this table as its State dropdown source without
-- breaking the Distance page's State-based project/rate filtering.
--
-- district.state_code is fixed too, not just `state` — migration 034 reseeds
-- `state` from district.state_code on every single migration run (it's not a
-- one-time seed), so leaving the district values as 'KA'/'MH'/'TN'/'TS' would
-- keep resurrecting the abbreviations here right after this migration renames
-- them, colliding with the already-renamed row on the very next full run.
SET search_path TO myactivity;

-- Was VARCHAR(10), sized for abbreviations only — too narrow for
-- "Maharashtra" (11 chars) once state_code holds full names.
ALTER TABLE district ALTER COLUMN state_code TYPE VARCHAR(100);

UPDATE district SET state_code = 'Karnataka'   WHERE state_code = 'KA';
UPDATE district SET state_code = 'Maharashtra' WHERE state_code = 'MH';
UPDATE district SET state_code = 'Tamil Nadu'  WHERE state_code = 'TN';
UPDATE district SET state_code = 'Telangana'   WHERE state_code = 'TS';

-- Belt-and-braces even with district fixed above: if an abbreviated row was
-- already resurrected by an earlier run (before this fix existed) and the
-- canonical name now also exists, drop the stray abbreviation instead of
-- trying to rename it into a duplicate.
DELETE FROM state WHERE state_name = 'KA' AND EXISTS (SELECT 1 FROM state WHERE state_name = 'Karnataka');
DELETE FROM state WHERE state_name = 'MH' AND EXISTS (SELECT 1 FROM state WHERE state_name = 'Maharashtra');
DELETE FROM state WHERE state_name = 'TN' AND EXISTS (SELECT 1 FROM state WHERE state_name = 'Tamil Nadu');
DELETE FROM state WHERE state_name = 'TS' AND EXISTS (SELECT 1 FROM state WHERE state_name = 'Telangana');

UPDATE state SET state_name = 'Karnataka'   WHERE state_name = 'KA';
UPDATE state SET state_name = 'Maharashtra' WHERE state_name = 'MH';
UPDATE state SET state_name = 'Tamil Nadu'  WHERE state_name = 'TN';
UPDATE state SET state_name = 'Telangana'   WHERE state_name = 'TS';

-- And the reverse — states now in `state` that distance_state_rate doesn't
-- know about yet — seeded at the same 3.00 default the rate lookup already
-- falls back to, so a project tagged with any of these still gets a valid
-- rate once it starts generating Distance trips.
INSERT INTO distance_state_rate (state, rate_per_km)
SELECT s.state_name, 3.00
FROM state s
WHERE s.is_active = 1
  AND NOT EXISTS (
    SELECT 1 FROM distance_state_rate r WHERE r.state = s.state_name
  )
ON CONFLICT (state) DO NOTHING;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','066_normalize_state_names.sql') ON CONFLICT DO NOTHING;
