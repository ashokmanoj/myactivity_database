-- DDL 017: add institution_name column to locations
SET search_path TO myactivity;

ALTER TABLE locations
    ADD COLUMN IF NOT EXISTS institution_name VARCHAR(200);
