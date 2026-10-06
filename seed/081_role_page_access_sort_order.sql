-- Seed data for ddl/081_role_page_access_sort_order.sql
-- Backfills sort_order to match the exact page order each role's array had
-- in the original hardcoded PAGE_ACCESS map (same source as
-- seed/080_role_page_access.sql), so turning on ordering doesn't reshuffle
-- anyone's sidebar on day one — a Superuser reorders from here on via the
-- Role Page Access screen's "Sidebar Order" panel.
SET search_path TO myactivity;

CREATE TEMP TABLE tmp_role_page_order (role_name VARCHAR(100), page_key VARCHAR(50), ord INT) ON COMMIT DROP;

INSERT INTO tmp_role_page_order (role_name, page_key, ord) VALUES
('Regional Manager Head', 'Distance', 0),
('Regional Manager Head', 'Expenses', 1),
('Regional Manager Head', 'HotelDetails', 2),
('Regional Manager Head', 'UserCreation', 3),
('Regional Manager Head', 'location', 4),
('Regional Manager Head', 'AppVersionTracker', 5),
('Regional Manager Head', 'LeaveApproval', 6),
('Regional Manager Head', 'SchoolSurvey', 7),

('Regional Manager', 'Dashboard', 0),
('Regional Manager', 'Distance', 1),
('Regional Manager', 'Expenses', 2),
('Regional Manager', 'HotelDetails', 3),
('Regional Manager', 'CreateTask', 4),
('Regional Manager', 'ActivityList', 5),
('Regional Manager', 'ClassRunDetails', 6),
('Regional Manager', 'TechExecMapping', 7),
('Regional Manager', 'TechExecDaySummary', 8),
('Regional Manager', 'PreventiveMaintenanceReport', 9),
('Regional Manager', 'PowerMeterReport', 10),
('Regional Manager', 'LeaveApproval', 11),
('Regional Manager', 'UserCreation', 12),

('Office Executive', 'Dashboard', 0),
('Office Executive', 'Distance', 1),
('Office Executive', 'Expenses', 2),
('Office Executive', 'CreateTask', 3),
('Office Executive', 'ActivityList', 4),
('Office Executive', 'ClassRunDetails', 5),
('Office Executive', 'ReportView', 6),
('Office Executive', 'TechExecMapping', 7),
('Office Executive', 'TechExecDaySummary', 8),
('Office Executive', 'PreventiveMaintenanceReport', 9),
('Office Executive', 'PowerMeterReport', 10),

('Procurement', 'Dashboard', 0),

('Store Executive', 'Dashboard', 0),

('Quality/Training', 'Distance', 0),
('Quality/Training', 'Expenses', 1),
('Quality/Training', 'HotelDetails', 2),
('Quality/Training', 'ActivityList', 3),

('HR', 'HRDashboard', 0),
('HR', 'UserCreation', 1),
('HR', 'ActivityList', 2),
('HR', 'ReportView', 3),
('HR', 'TechExecMapping', 4),
('HR', 'TechExecDaySummary', 5),
('HR', 'PreventiveMaintenanceReport', 6),
('HR', 'PowerMeterReport', 7),

('Accounts', 'Dashboard', 0),
('Accounts', 'Distance', 1),
('Accounts', 'Expenses', 2),
('Accounts', 'HotelDetails', 3),
('Accounts', 'TaskList', 4),
('Accounts', 'TaskDetails', 5),

('TA Team', 'Dashboard', 0),
('TA Team', 'UserCreation', 1),
('TA Team', 'ActivityList', 2),
('TA Team', 'ReportView', 3),
('TA Team', 'TechExecMapping', 4),
('TA Team', 'TechExecDaySummary', 5),
('TA Team', 'Distance', 6),
('TA Team', 'Expenses', 7),
('TA Team', 'HotelDetails', 8),
('TA Team', 'PreventiveMaintenanceReport', 9),
('TA Team', 'PowerMeterReport', 10),
('TA Team', 'DistanceRateSettings', 11),
('TA Team', 'TaskList', 12),
('TA Team', 'TaskDetails', 13),

('Field Executive', 'Dashboard', 0),
('Field Executive', 'ActivityList', 1),
('Field Executive', 'PreventiveMaintenance', 2),

('Verifier', 'Distance', 0),
('Verifier', 'Expenses', 1),
('Verifier', 'HotelDetails', 2),
('Verifier', 'ActivityList', 3),
('Verifier', 'CreateTask', 4),
('Verifier', 'ReportView', 5),
('Verifier', 'TechExecMapping', 6),
('Verifier', 'TechExecDaySummary', 7),
('Verifier', 'TaskList', 8),
('Verifier', 'TaskDetails', 9),

('Project Manager', 'Dashboard', 0),
('Project Manager', 'Distance', 1),
('Project Manager', 'Expenses', 2),
('Project Manager', 'HotelDetails', 3),
('Project Manager', 'ActivityList', 4),
('Project Manager', 'ReportView', 5),
('Project Manager', 'TechExecMapping', 6),
('Project Manager', 'TechExecDaySummary', 7),
('Project Manager', 'TaskList', 8),
('Project Manager', 'TaskDetails', 9);

UPDATE role_page_access rpa
SET sort_order = t.ord
FROM tmp_role_page_order t
JOIN roles r ON r.role_name = t.role_name
WHERE rpa.role_id = r.role_id AND rpa.page_key = t.page_key;
