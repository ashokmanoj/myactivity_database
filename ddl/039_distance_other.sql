-- DDL 039: Other-mode distance trips (Bus, Auto, Train, mixed-vehicle)
SET search_path TO myactivity;

-- Main trip record (one per submission)
CREATE TABLE IF NOT EXISTS distance_other_trip (
  id               SERIAL PRIMARY KEY,
  user_id          INT           NOT NULL,
  company_id       INT,
  trip_date        DATE          NOT NULL DEFAULT CURRENT_DATE,
  remarks          TEXT,
  payment_method   VARCHAR(20)   NOT NULL DEFAULT 'Cash',
  amount           NUMERIC(10,2) NOT NULL DEFAULT 0,
  payment_screenshot VARCHAR(500),

  -- approval workflow (mirrors distance_tracking)
  is_submitted     SMALLINT      NOT NULL DEFAULT 0,
  submitted_at     TIMESTAMPTZ,

  verifier_status  VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  verifier_by      INT,
  verifier_comment TEXT,
  verifier_at      TIMESTAMPTZ,
  verifier_amount  NUMERIC(10,2),

  rm_status        VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  rm_by            INT,
  rm_comment       TEXT,
  rm_at            TIMESTAMPTZ,
  rm_amount        NUMERIC(10,2),

  ta_status        VARCHAR(20)   NOT NULL DEFAULT 'Pending',
  ta_by            INT,
  ta_comment       TEXT,
  ta_at            TIMESTAMPTZ,

  approved_amount  NUMERIC(10,2),
  payment_status   VARCHAR(30)   NOT NULL DEFAULT 'Processing',
  payment_by       INT,
  payment_at       TIMESTAMPTZ,

  created_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Individual vehicle legs within a trip (one row per leg)
CREATE TABLE IF NOT EXISTS distance_other_leg (
  id             SERIAL PRIMARY KEY,
  trip_id        INT           NOT NULL REFERENCES myactivity.distance_other_trip(id) ON DELETE CASCADE,
  mode           VARCHAR(50)   NOT NULL,   -- Bus, Auto, Train, Rickshaw, etc.
  from_location  VARCHAR(200),
  to_location    VARCHAR(200),
  distance       NUMERIC(10,2),
  sort_order     INT           NOT NULL DEFAULT 0,
  created_at     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dot_user_id   ON distance_other_trip(user_id);
-- idx_dot_trip_date removed — the trip_date column was dropped in
-- 053_distance_other_trip_cleanup.sql (superseded by start_timestamp).
CREATE INDEX IF NOT EXISTS idx_dol_trip_id   ON distance_other_leg(trip_id);
