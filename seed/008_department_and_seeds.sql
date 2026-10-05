-- Seed data for ddl/008_department_and_seeds.sql
SET search_path TO myactivity;

INSERT INTO department (department_name) VALUES
('HR'), ('Finance'), ('IT'), ('Operations'), ('Sales'), ('Marketing')
ON CONFLICT (department_name) DO NOTHING;
