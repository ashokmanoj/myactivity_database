-- DDL 069: Seed survey_question for project_id 21 — "Analytics-Powered AI
-- Interaction Virtual Classroom" (Sikkim) — transcribed from Interactive
-- Virtual_Classroom_Survey_Form_V2 - 3.pdf. Unlike Sundargarh's per-classroom
-- equipment checklist, this form is a one-time site-readiness assessment —
-- no repeat_group needed except the fixed Contact Persons/Assets rows.
SET search_path TO myactivity;

INSERT INTO survey_question (project_id, q_id, section, group_label, repeat_group, question, q_type, options, sort_order) VALUES
-- A. School details
(21,'SCH_NAME',    'A. School Details', NULL, NULL, 'School name', 'text', NULL, 10),
(21,'UDISE',        'A. School Details', NULL, NULL, 'UDISE code', 'text', NULL, 20),
(21,'VILLAGE',      'A. School Details', NULL, NULL, 'Village / locality', 'text', NULL, 30),
(21,'PIN',          'A. School Details', NULL, NULL, 'PIN code', 'text', NULL, 40),
(21,'BLOCK',        'A. School Details', NULL, NULL, 'Block', 'text', NULL, 50),
(21,'DISTRICT',     'A. School Details', NULL, NULL, 'District', 'text', NULL, 60),
(21,'LATITUDE',     'A. School Details', NULL, NULL, 'Latitude', 'text', NULL, 70),
(21,'LONGITUDE',    'A. School Details', NULL, NULL, 'Longitude', 'text', NULL, 80),
(21,'MEDIUM',       'A. School Details', NULL, NULL, 'Medium(s) of instruction', 'text', NULL, 90),
(21,'CLASSES',      'A. School Details', NULL, NULL, 'Classes available', 'text', NULL, 100),
(21,'DIST_EDU_OFF', 'A. School Details', NULL, NULL, 'Distance from District Education Office', 'text', NULL, 110),
(21,'LAST_MILE',    'A. School Details', NULL, NULL, 'Nearest motorable access / last-mile distance', 'text', NULL, 120),

-- B. Contact persons
(21,'HOS_NAME',    'B. Contact Persons', 'Head of School', NULL, 'Name', 'text', NULL, 130),
(21,'HOS_MOBILE',  'B. Contact Persons', 'Head of School', NULL, 'Mobile number', 'text', NULL, 140),
(21,'HOS_EMAIL',   'B. Contact Persons', 'Head of School', NULL, 'Email id', 'text', NULL, 150),
(21,'ICT_NAME',    'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Name', 'text', NULL, 160),
(21,'ICT_MOBILE',  'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Mobile number', 'text', NULL, 170),
(21,'ICT_EMAIL',   'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Email id', 'text', NULL, 180),

-- C. Student details (fixed classes 6-12, two mediums)
(21,'STU_6_M1',  'C. Student Details', NULL, NULL, 'Class 6 — Students count (Medium 1)', 'number', NULL, 190),
(21,'STU_6_M2',  'C. Student Details', NULL, NULL, 'Class 6 — Students count (Medium 2)', 'number', NULL, 200),
(21,'STU_7_M1',  'C. Student Details', NULL, NULL, 'Class 7 — Students count (Medium 1)', 'number', NULL, 210),
(21,'STU_7_M2',  'C. Student Details', NULL, NULL, 'Class 7 — Students count (Medium 2)', 'number', NULL, 220),
(21,'STU_8_M1',  'C. Student Details', NULL, NULL, 'Class 8 — Students count (Medium 1)', 'number', NULL, 230),
(21,'STU_8_M2',  'C. Student Details', NULL, NULL, 'Class 8 — Students count (Medium 2)', 'number', NULL, 240),
(21,'STU_9_M1',  'C. Student Details', NULL, NULL, 'Class 9 — Students count (Medium 1)', 'number', NULL, 250),
(21,'STU_9_M2',  'C. Student Details', NULL, NULL, 'Class 9 — Students count (Medium 2)', 'number', NULL, 260),
(21,'STU_10_M1', 'C. Student Details', NULL, NULL, 'Class 10 — Students count (Medium 1)', 'number', NULL, 270),
(21,'STU_10_M2', 'C. Student Details', NULL, NULL, 'Class 10 — Students count (Medium 2)', 'number', NULL, 280),
(21,'STU_11_M1', 'C. Student Details', NULL, NULL, 'Class 11 — Students count (Medium 1)', 'number', NULL, 290),
(21,'STU_11_M2', 'C. Student Details', NULL, NULL, 'Class 11 — Students count (Medium 2)', 'number', NULL, 300),
(21,'STU_12_M1', 'C. Student Details', NULL, NULL, 'Class 12 — Students count (Medium 1)', 'number', NULL, 310),
(21,'STU_12_M2', 'C. Student Details', NULL, NULL, 'Class 12 — Students count (Medium 2)', 'number', NULL, 320),

-- D. Site access, logistics & VSAT feasibility (each has its own Remarks via survey_answer.remarks)
(21,'ROAD_ACCESS',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Motorable road available up to school', 'boolean', NULL, 330),
(21,'HILLY',          'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Hilly / difficult-access location', 'boolean', NULL, 340),
(21,'WEATHER_RISK',   'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Heavy rainfall / snow / high-wind exposure', 'boolean', NULL, 350),
(21,'SKY_VIEW',       'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Clear satellite sky view at proposed antenna location', 'select', '["Clear","Obstructed"]', 360),
(21,'OBSTRUCTION',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Obstruction type and direction', 'select', '["Trees","Forest","Building","Hill","Other"]', 370),
(21,'ANTENNA_LOC',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Proposed antenna location', 'select', '["RCC roof","Slant roof","Wall","Ground mount"]', 380),
(21,'CABLE_ROUTE',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Approx. antenna-to-classroom cable route (metres)', 'number', NULL, 390),
(21,'SAFE_ACCESS',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Safe access for antenna installation and maintenance', 'boolean', NULL, 400),
(21,'INTERNET_EXIST', 'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Existing internet connection', 'boolean', NULL, 410),
(21,'CONN_TYPE',      'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Connectivity type', 'select', '["Fibre","Broadband","Other"]', 420),

-- E. Selected classroom — civil & safety readiness
(21,'ROOM_APPROVED',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Dedicated classroom approved for virtual classroom', 'boolean', NULL, 430),
(21,'ROOM_LENGTH',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal length (ft)', 'number', NULL, 440),
(21,'ROOM_BREADTH',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal breadth (ft)', 'number', NULL, 450),
(21,'ROOM_HEIGHT',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal height (ft)', 'number', NULL, 460),
(21,'SEATING_CAP',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Approx. student seating capacity', 'number', NULL, 470),
(21,'WALL_SUITABLE',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Wall suitable for mounting 65-inch interactive panel', 'select', '["Yes","No","Stand required"]', 480),
(21,'CEILING_TYPE',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Ceiling / roof type', 'select', '["RCC","Tile","Sheet","Other"]', 490),
(21,'CEILING_COND',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Ceiling / roof condition', 'select', '["Good","Repair"]', 500),
(21,'DOORS_SECURE',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Door and windows can be secured', 'boolean', NULL, 510),
(21,'FLOOR_WALL_COND', 'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Floor and wall condition', 'select', '["Good","Minor repair","Major repair"]', 520),
(21,'WATER_LEAKAGE',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Water leakage / dampness observed', 'boolean', NULL, 530),
(21,'FLOOD_PRONE',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room prone to flood / water entry', 'boolean', NULL, 540),
(21,'NUM_CLASSROOMS',  'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'How many classrooms are available at school', 'number', NULL, 550),

-- F. Electrical, earthing & power-backup readiness
(21,'ELECTRICITY',     'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Electricity available at school', 'boolean', NULL, 560),
(21,'SUPPLY_CLASSROOM','F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Supply at selected classroom', 'select', '["Available","Extension required"]', 570),
(21,'VOLTAGE',         'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Measured voltage (V)', 'number', NULL, 580),
(21,'FREQUENCY',       'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Measured frequency (Hz)', 'number', NULL, 590),
(21,'EARTHING',        'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Functional protective earthing', 'boolean', NULL, 600),
(21,'SOCKETS',         'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Number of working sockets available in classroom', 'number', NULL, 610),

-- J. Existing assets status (fixed asset list)
(21,'ASSET_PANEL_QTY',    'J. Existing Assets Status', 'Interactive panel / display', NULL, 'Quantity', 'number', NULL, 620),
(21,'ASSET_PANEL_COND',   'J. Existing Assets Status', 'Interactive panel / display', NULL, 'Working condition', 'select', '["Good","Faulty"]', 630),
(21,'ASSET_PC_QTY',       'J. Existing Assets Status', 'Desktop / laptop', NULL, 'Quantity', 'number', NULL, 640),
(21,'ASSET_PC_COND',      'J. Existing Assets Status', 'Desktop / laptop', NULL, 'Working condition', 'select', '["Good","Faulty"]', 650),
(21,'ASSET_UPS_QTY',      'J. Existing Assets Status', 'UPS / inverter', NULL, 'Quantity', 'number', NULL, 660),
(21,'ASSET_UPS_COND',     'J. Existing Assets Status', 'UPS / inverter', NULL, 'Working condition', 'select', '["Good","Faulty"]', 670),
(21,'ASSET_SOLAR_QTY',    'J. Existing Assets Status', 'Solar', NULL, 'Quantity', 'number', NULL, 680),
(21,'ASSET_SOLAR_COND',   'J. Existing Assets Status', 'Solar', NULL, 'Working condition', 'select', '["Good","Faulty"]', 690),

-- K. Required geo-tagged photographs
(21,'PHOTO_FRONT',     'K. Required Geo Tagged Photographs', NULL, NULL, 'School front with name board', 'photo', NULL, 700),
(21,'PHOTO_PANEL_WALL','K. Required Geo Tagged Photographs', NULL, NULL, 'Selected classroom — front / panel wall', 'photo', NULL, 710),
(21,'PHOTO_CLASSROOM', 'K. Required Geo Tagged Photographs', NULL, NULL, 'Selected classroom — full classroom view', 'photo', NULL, 720),

(21,'KEY_OBSERVATIONS','Key Observations', NULL, NULL, 'Key observations', 'text', NULL, 730)
ON CONFLICT (project_id, q_id) DO NOTHING;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','069_survey_seed_sikkim.sql') ON CONFLICT DO NOTHING;
