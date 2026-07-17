SET search_path TO myactivity;

-- Add missing vsat_signal_strength column to survey_classroom_equipment.
-- This column exists in the application code but was omitted from the
-- original 028_survey_forms.sql table definition.
ALTER TABLE survey_classroom_equipment
    ADD COLUMN IF NOT EXISTS vsat_signal_strength VARCHAR(20);
