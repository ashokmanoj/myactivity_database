-- ============================================================================
-- DDL 097: Server performance history for the Superuser "Server Performance"
-- screen.
--
--   server_metrics — one row per minute, written by the API's background job
--                    (myactivity_backend/src/jobs/serverMetrics.js). "server_*"
--                    columns are the whole machine; "app_*" columns are the
--                    MyActivity API process alone. CPU % is of the whole
--                    machine (all cores), so the two are directly comparable.
--                    Sizes are in MB. Rows older than 90 days are purged by
--                    the same job.
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS server_metrics (
    id                  BIGSERIAL      PRIMARY KEY,
    recorded_at         TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    server_cpu_pct      NUMERIC(5,2)   NOT NULL,
    app_cpu_pct         NUMERIC(5,2)   NOT NULL,
    mem_total_mb        NUMERIC(12,2)  NOT NULL,
    mem_used_mb         NUMERIC(12,2)  NOT NULL,
    app_mem_mb          NUMERIC(12,2)  NOT NULL,
    disk_total_mb       NUMERIC(14,2)  NOT NULL,
    disk_used_mb        NUMERIC(14,2)  NOT NULL,
    db_size_mb          NUMERIC(14,2)  NOT NULL,
    logs_size_mb        NUMERIC(12,2)  NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_server_metrics_recorded_at ON server_metrics(recorded_at);
