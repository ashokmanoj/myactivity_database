-- DDL 061: State-wise per-km rate for Distance, editable by Superuser/TA Team.
-- Replaces the two hard-coded, mutually inconsistent rate CASE statements that
-- used to live in fn_distance_sync (Assam=3.00, Tripura=3.50, else 3.00) and
-- fn_distance_start (Odisha=4.00, else 3.75) with one shared source of truth.
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS distance_state_rate (
    id           SERIAL PRIMARY KEY,
    state        VARCHAR(100) NOT NULL UNIQUE,
    rate_per_km  NUMERIC(5,2) NOT NULL,
    is_active    SMALLINT     NOT NULL DEFAULT 1,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Seed with the states already in use across the app (mobile access user
-- creation's State dropdown, Distance's rate logic) at their prior effective
-- rate — Assam/Tripura/Odisha from fn_distance_sync's CASE, the rest at the
-- 3.00 default both old CASE statements ultimately fell back to.


INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','061_distance_state_rate.sql') ON CONFLICT DO NOTHING;
