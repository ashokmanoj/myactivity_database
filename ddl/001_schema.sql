-- ============================================================================
-- DDL 001: Base Schema
-- Run once. Creates schema + version tracking table.
-- ============================================================================
CREATE SCHEMA IF NOT EXISTS public;
SET search_path TO public;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS schema_versions (
    id                BIGSERIAL PRIMARY KEY,
    version           VARCHAR(20)  NOT NULL,
    migration_file    VARCHAR(200) NOT NULL,
    direction         VARCHAR(4)   NOT NULL DEFAULT 'UP',
    applied_at        TIMESTAMPTZ  DEFAULT NOW(),
    applied_by        VARCHAR(100) DEFAULT current_user,
    status            VARCHAR(20)  DEFAULT 'SUCCESS',
    UNIQUE (migration_file, direction)
);
