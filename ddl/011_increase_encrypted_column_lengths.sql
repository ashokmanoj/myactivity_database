-- Migration: Increase column lengths for encrypted fields
SET search_path TO myactivity;

ALTER TABLE user_information 
ALTER COLUMN aadhar_number TYPE VARCHAR(500),
ALTER COLUMN pan_number TYPE VARCHAR(500),
ALTER COLUMN bank_name TYPE VARCHAR(500),
ALTER COLUMN branch_name TYPE VARCHAR(500),
ALTER COLUMN account_number TYPE VARCHAR(500),
ALTER COLUMN ifsc_code TYPE VARCHAR(500);
