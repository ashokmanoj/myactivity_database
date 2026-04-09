-- ============================================================================
-- schema_version.sql
-- Creates the version tracking table for database migrations
-- Run this ONCE before running any DDL migrations
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS myactivity;

CREATE TABLE IF NOT EXISTS myactivity.schema_versions (
    id              BIGSERIAL PRIMARY KEY,
    version         VARCHAR(20)  NOT NULL,           -- e.g. 'v1.0.0'
    migration_file  VARCHAR(200) NOT NULL,           -- e.g. '001_schema.sql'
    direction       VARCHAR(4)   NOT NULL,           -- 'UP' or 'DOWN'
    applied_at      TIMESTAMPTZ  DEFAULT NOW(),
    applied_by      VARCHAR(100),
    checksum        VARCHAR(64),                     -- SHA-256 of file
    execution_time_ms INT,
    status          VARCHAR(20)  DEFAULT 'SUCCESS',  -- SUCCESS, FAILED
    notes           TEXT,
    UNIQUE(version, migration_file, direction)
);

CREATE INDEX IF NOT EXISTS idx_schema_versions_version
    ON myactivity.schema_versions(version);

COMMENT ON TABLE myactivity.schema_versions IS
    'Tracks all applied DB migrations — do not edit manually';
