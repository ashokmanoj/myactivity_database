-- Migration: Add referred_by and date_of_exit_comment to user_information
SET search_path TO myactivity;

ALTER TABLE user_information 
ADD COLUMN IF NOT EXISTS referred_by VARCHAR(150),
ADD COLUMN IF NOT EXISTS date_of_exit_comment VARCHAR(500);
