-- DDL 040: Add trip_time column to distance_other_trip
SET search_path TO myactivity;

ALTER TABLE distance_other_trip
  ADD COLUMN IF NOT EXISTS trip_time TIME;
