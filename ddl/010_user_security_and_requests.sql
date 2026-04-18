-- Migration: Add status_comment and create change_requests table
SET search_path TO myactivity;

-- 1. Add status_comment for deactivation reasons
ALTER TABLE user_information 
ADD COLUMN IF NOT EXISTS status_comment TEXT;

-- 2. Create Change Requests table
CREATE TABLE IF NOT EXISTS user_change_requests (
    request_id SERIAL PRIMARY KEY,
    user_info_id INT REFERENCES user_information(user_info_id),
    requested_by INT REFERENCES user_tbl(user_id),
    requested_data JSONB NOT NULL, -- Stores the proposed changes
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    hr_comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
