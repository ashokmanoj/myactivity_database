-- Seed data for ddl/080_role_page_access.sql
-- Snapshot of the PAGE_ACCESS map that was hardcoded in
-- myactivity_frontend/src/utils/auth.js at the time this table was
-- introduced, so switching to the DB-backed system doesn't change anyone's
-- access on day one — a Superuser edits it from here on via the Role Page
-- Access screen. Superuser itself is intentionally not seeded here: it
-- always gets every page (hardcoded in auth.js), never consults this table.
SET search_path TO myactivity;

CREATE TEMP TABLE tmp_role_page_access (role_name VARCHAR(100), page_key VARCHAR(50)) ON COMMIT DROP;

INSERT INTO tmp_role_page_access (role_name, page_key) VALUES
('Regional Manager Head', 'Distance'),
('Regional Manager Head', 'Expenses'),
('Regional Manager Head', 'HotelDetails'),
('Regional Manager Head', 'UserCreation'),
('Regional Manager Head', 'location'),
('Regional Manager Head', 'AppVersionTracker'),
('Regional Manager Head', 'LeaveApproval'),
('Regional Manager Head', 'SchoolSurvey'),

('Regional Manager', 'Dashboard'),
('Regional Manager', 'Distance'),
('Regional Manager', 'Expenses'),
('Regional Manager', 'HotelDetails'),
('Regional Manager', 'CreateTask'),
('Regional Manager', 'ActivityList'),
('Regional Manager', 'ClassRunDetails'),
('Regional Manager', 'TechExecMapping'),
('Regional Manager', 'TechExecDaySummary'),
('Regional Manager', 'PreventiveMaintenanceReport'),
('Regional Manager', 'PowerMeterReport'),
('Regional Manager', 'LeaveApproval'),
('Regional Manager', 'UserCreation'),

('Office Executive', 'Dashboard'),
('Office Executive', 'Distance'),
('Office Executive', 'Expenses'),
('Office Executive', 'CreateTask'),
('Office Executive', 'ActivityList'),
('Office Executive', 'ClassRunDetails'),
('Office Executive', 'ReportView'),
('Office Executive', 'TechExecMapping'),
('Office Executive', 'TechExecDaySummary'),
('Office Executive', 'PreventiveMaintenanceReport'),
('Office Executive', 'PowerMeterReport'),

('Procurement', 'Dashboard'),

('Store Executive', 'Dashboard'),

('Quality/Training', 'Distance'),
('Quality/Training', 'Expenses'),
('Quality/Training', 'HotelDetails'),
('Quality/Training', 'ActivityList'),

('HR', 'HRDashboard'),
('HR', 'UserCreation'),
('HR', 'ActivityList'),
('HR', 'ReportView'),
('HR', 'TechExecMapping'),
('HR', 'TechExecDaySummary'),
('HR', 'PreventiveMaintenanceReport'),
('HR', 'PowerMeterReport'),

('Accounts', 'Dashboard'),
('Accounts', 'Distance'),
('Accounts', 'Expenses'),
('Accounts', 'HotelDetails'),
('Accounts', 'TaskList'),
('Accounts', 'TaskDetails'),

('TA Team', 'Dashboard'),
('TA Team', 'UserCreation'),
('TA Team', 'ActivityList'),
('TA Team', 'ReportView'),
('TA Team', 'TechExecMapping'),
('TA Team', 'TechExecDaySummary'),
('TA Team', 'Distance'),
('TA Team', 'Expenses'),
('TA Team', 'HotelDetails'),
('TA Team', 'PreventiveMaintenanceReport'),
('TA Team', 'PowerMeterReport'),
('TA Team', 'DistanceRateSettings'),
('TA Team', 'TaskList'),
('TA Team', 'TaskDetails'),

('Field Executive', 'Dashboard'),
('Field Executive', 'ActivityList'),
('Field Executive', 'PreventiveMaintenance'),

('Verifier', 'Distance'),
('Verifier', 'Expenses'),
('Verifier', 'HotelDetails'),
('Verifier', 'ActivityList'),
('Verifier', 'CreateTask'),
('Verifier', 'ReportView'),
('Verifier', 'TechExecMapping'),
('Verifier', 'TechExecDaySummary'),
('Verifier', 'TaskList'),
('Verifier', 'TaskDetails'),

('Project Manager', 'Dashboard'),
('Project Manager', 'Distance'),
('Project Manager', 'Expenses'),
('Project Manager', 'HotelDetails'),
('Project Manager', 'ActivityList'),
('Project Manager', 'ReportView'),
('Project Manager', 'TechExecMapping'),
('Project Manager', 'TechExecDaySummary'),
('Project Manager', 'TaskList'),
('Project Manager', 'TaskDetails');

INSERT INTO role_page_access (role_id, page_key, is_visible)
SELECT r.role_id, t.page_key, true
FROM tmp_role_page_access t
JOIN roles r ON r.role_name = t.role_name
ON CONFLICT (role_id, page_key) DO NOTHING;
