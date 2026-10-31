-- DDL 094: Superuser "App Block" — blocks the whole mobile app (not just a
-- module) for a company / state / project / user, showing a custom message
-- (e.g. "App is under update") until a Superuser unblocks that scope.
-- A user is blocked if ANY scope that applies to them is blocked; the most
-- specific scope's message wins (user → project → state → company).
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS app_block (
  id          SERIAL       PRIMARY KEY,
  scope_type  VARCHAR(10)  NOT NULL CHECK (scope_type IN ('company', 'project', 'state', 'user')),
  scope_id    INT          NOT NULL,
  is_blocked  BOOLEAN      NOT NULL DEFAULT false,
  title       VARCHAR(150),
  message     VARCHAR(1000),
  updated_by  INT,
  updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  CONSTRAINT uq_app_block UNIQUE (scope_type, scope_id)
);

CREATE INDEX IF NOT EXISTS idx_app_block_blocked ON app_block (is_blocked) WHERE is_blocked;
