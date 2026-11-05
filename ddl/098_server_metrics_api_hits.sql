SET search_path TO myactivity;

-- Adds API traffic to server_metrics (DDL 097), counted per minute by the
-- API's request counter (myactivity_backend/src/utils/requestStats.js):
--   api_hits   — requests finished in that minute
--   api_errors — of those, how many returned 5xx
--   api_avg_ms — average response time of those requests (NULL when 0 hits)
ALTER TABLE server_metrics
  ADD COLUMN IF NOT EXISTS api_hits   INT           NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS api_errors INT           NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS api_avg_ms NUMERIC(10,2);
