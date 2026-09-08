-- DDL 062: Drop fn_distance_end — orphaned since the merge-Others refactor.
-- Bike/Car trips are started+ended exclusively via fn_distance_sync, and
-- Others trips end via a direct leg-sum UPDATE in the controller; nothing in
-- the app calls fn_distance_end any more. It was still being recreated on
-- every migration run and carried its own stale rate/amount math (missing the
-- /1000 km conversion, and a hardcoded fallback rate) that had drifted out of
-- sync with the real amount logic in fn_distance_sync/fn_distance_start —
-- removed entirely rather than fixed, since dead code with amount logic is
-- exactly the kind of thing that causes confusion later.
SET search_path TO myactivity;

DROP FUNCTION IF EXISTS fn_distance_end(INT, INT, VARCHAR, BIGINT, INT, INT, VARCHAR);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','062_drop_dead_fn_distance_end.sql') ON CONFLICT DO NOTHING;
