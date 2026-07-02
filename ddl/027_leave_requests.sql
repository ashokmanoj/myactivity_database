-- ============================================================================
-- DDL 027: Leave requests table
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS leave_requests (
    id              SERIAL PRIMARY KEY,
    user_id         INT NOT NULL REFERENCES user_tbl(user_id) ON DELETE CASCADE,
    company_id      INT NOT NULL,
    leave_type      VARCHAR(30)  NOT NULL DEFAULT 'leave',   -- 'leave' | 'local_holiday'
    leave_date      DATE         NOT NULL DEFAULT CURRENT_DATE,
    reason          TEXT,
    status          VARCHAR(20)  NOT NULL DEFAULT 'pending', -- 'pending' | 'approved' | 'rejected'
    reviewed_by     INT REFERENCES user_tbl(user_id),
    review_remarks  TEXT,
    reviewed_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_leave_user_id    ON leave_requests (user_id);
CREATE INDEX IF NOT EXISTS idx_leave_company_id ON leave_requests (company_id);
CREATE INDEX IF NOT EXISTS idx_leave_date       ON leave_requests (leave_date);
CREATE INDEX IF NOT EXISTS idx_leave_status     ON leave_requests (status);

INSERT INTO schema_versions (version, migration_file)
VALUES ('v1.0.27', '027_leave_requests.sql')
ON CONFLICT (migration_file, direction) DO NOTHING;
