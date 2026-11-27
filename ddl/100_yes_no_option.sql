-- ============================================================================
-- DDL 100: yes_no_option — master list for Yes / No answers, so any table
-- that records a yes/no check (activity_details' class-run and VSAT status,
-- ...) stores an id instead of free text. Seed rows live in
-- database/seed/100_yes_no_option.sql (DDL files are schema-only).
-- ============================================================================
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS yes_no_option (
    id            SERIAL        PRIMARY KEY,
    option_name   VARCHAR(20)   NOT NULL UNIQUE,
    sort_order    INT           NOT NULL DEFAULT 0,
    is_active     SMALLINT      NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);
