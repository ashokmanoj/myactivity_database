-- DDL 069: Seed survey_question for "Analytics-Powered AI Interaction
-- Virtual Classroom" (Sikkim) — transcribed from Interactive
-- Virtual_Classroom_Survey_Form_V2 - 3.pdf. Unlike Sundargarh's per-classroom
-- equipment checklist, this form is a one-time site-readiness assessment —
-- no repeat_group needed except the fixed Contact Persons/Assets rows.
--
-- Resolved by project NAME, not a hardcoded id — see 068's header comment
-- for why (production's project_id for this project differs from dev's,
-- which is exactly what caused the FK violation this migration originally hit).
SET search_path TO myactivity;

DO $$
DECLARE
  v_project_id INT;
BEGIN
  SELECT project_id INTO v_project_id FROM project WHERE project_name = 'Analytics-Powered AI Interaction Virtual Classroom';
  IF v_project_id IS NULL THEN
    RAISE EXCEPTION 'Project "Analytics-Powered AI Interaction Virtual Classroom" not found — create it first, then re-run this migration.';
  END IF;

  CREATE TEMP TABLE tmp_survey_seed_069 (
    q_id          VARCHAR(60),
    section_name  VARCHAR(150),
    group_label   VARCHAR(200),
    repeat_group  VARCHAR(50),
    question      TEXT,
    q_type_name   VARCHAR(20),
    options       JSON,
    sort_order    INT
  );

  INSERT INTO tmp_survey_seed_069 (q_id, section_name, group_label, repeat_group, question, q_type_name, options, sort_order) VALUES
-- A. School details
('SCH_NAME',    'A. School Details', NULL, NULL, 'School name', 'text', NULL, 10),
('UDISE',        'A. School Details', NULL, NULL, 'UDISE code', 'number', NULL, 20),
('VILLAGE',      'A. School Details', NULL, NULL, 'Village / locality', 'text', NULL, 30),
('PIN',          'A. School Details', NULL, NULL, 'PIN code', 'number', NULL, 40),
('BLOCK',        'A. School Details', NULL, NULL, 'Block', 'text', NULL, 50),
('DISTRICT',     'A. School Details', NULL, NULL, 'District', 'text', NULL, 60),
('LATITUDE',     'A. School Details', NULL, NULL, 'Latitude', 'decimal', NULL, 70),
('LONGITUDE',    'A. School Details', NULL, NULL, 'Longitude', 'decimal', NULL, 80),
('MEDIUM',       'A. School Details', NULL, NULL, 'Medium(s) of instruction', 'text', NULL, 90),
('CLASSES',      'A. School Details', NULL, NULL, 'Classes available', 'text', NULL, 100),
('DIST_EDU_OFF', 'A. School Details', NULL, NULL, 'Distance from District Education Office', 'text', NULL, 110),
('LAST_MILE',    'A. School Details', NULL, NULL, 'Nearest motorable access / last-mile distance', 'text', NULL, 120),

-- B. Contact persons
('HOS_NAME',    'B. Contact Persons', 'Head of School', NULL, 'Name', 'text', NULL, 130),
('HOS_MOBILE',  'B. Contact Persons', 'Head of School', NULL, 'Mobile number', 'number', NULL, 140),
('HOS_EMAIL',   'B. Contact Persons', 'Head of School', NULL, 'Email id', 'text', NULL, 150),
('ICT_NAME',    'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Name', 'text', NULL, 160),
('ICT_MOBILE',  'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Mobile number', 'number', NULL, 170),
('ICT_EMAIL',   'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Email id', 'text', NULL, 180),

-- C. Student details (fixed classes 6-12, two mediums)
('STU_6_M1',  'C. Student Details', NULL, NULL, 'Class 6 — Students count (Medium 1)', 'number', NULL, 190),
('STU_6_M2',  'C. Student Details', NULL, NULL, 'Class 6 — Students count (Medium 2)', 'number', NULL, 200),
('STU_7_M1',  'C. Student Details', NULL, NULL, 'Class 7 — Students count (Medium 1)', 'number', NULL, 210),
('STU_7_M2',  'C. Student Details', NULL, NULL, 'Class 7 — Students count (Medium 2)', 'number', NULL, 220),
('STU_8_M1',  'C. Student Details', NULL, NULL, 'Class 8 — Students count (Medium 1)', 'number', NULL, 230),
('STU_8_M2',  'C. Student Details', NULL, NULL, 'Class 8 — Students count (Medium 2)', 'number', NULL, 240),
('STU_9_M1',  'C. Student Details', NULL, NULL, 'Class 9 — Students count (Medium 1)', 'number', NULL, 250),
('STU_9_M2',  'C. Student Details', NULL, NULL, 'Class 9 — Students count (Medium 2)', 'number', NULL, 260),
('STU_10_M1', 'C. Student Details', NULL, NULL, 'Class 10 — Students count (Medium 1)', 'number', NULL, 270),
('STU_10_M2', 'C. Student Details', NULL, NULL, 'Class 10 — Students count (Medium 2)', 'number', NULL, 280),
('STU_11_M1', 'C. Student Details', NULL, NULL, 'Class 11 — Students count (Medium 1)', 'number', NULL, 290),
('STU_11_M2', 'C. Student Details', NULL, NULL, 'Class 11 — Students count (Medium 2)', 'number', NULL, 300),
('STU_12_M1', 'C. Student Details', NULL, NULL, 'Class 12 — Students count (Medium 1)', 'number', NULL, 310),
('STU_12_M2', 'C. Student Details', NULL, NULL, 'Class 12 — Students count (Medium 2)', 'number', NULL, 320),

-- D. Site access, logistics & VSAT feasibility (each has its own Remarks via survey_answer.remarks)
('ROAD_ACCESS',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Motorable road available up to school', 'boolean', NULL, 330),
('HILLY',          'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Hilly / difficult-access location', 'boolean', NULL, 340),
('WEATHER_RISK',   'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Heavy rainfall / snow / high-wind exposure', 'boolean', NULL, 350),
('SKY_VIEW',       'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Clear satellite sky view at proposed antenna location', 'select', '["Clear","Obstructed"]', 360),
('OBSTRUCTION',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Obstruction type and direction', 'select', '["Trees","Forest","Building","Hill","Other"]', 370),
('ANTENNA_LOC',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Proposed antenna location', 'select', '["RCC roof","Slant roof","Wall","Ground mount"]', 380),
('CABLE_ROUTE',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Approx. antenna-to-classroom cable route (metres)', 'text', NULL, 390),
('SAFE_ACCESS',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Safe access for antenna installation and maintenance', 'boolean', NULL, 400),
('INTERNET_EXIST', 'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Existing internet connection', 'boolean', NULL, 410),
('CONN_TYPE',      'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Connectivity type', 'select', '["Fibre","Broadband","Other"]', 420),

-- E. Selected classroom — civil & safety readiness
('ROOM_APPROVED',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Dedicated classroom approved for virtual classroom', 'boolean', NULL, 430),
('ROOM_LENGTH',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal length (ft)', 'number', NULL, 440),
('ROOM_BREADTH',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal breadth (ft)', 'number', NULL, 450),
('ROOM_HEIGHT',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal height (ft)', 'number', NULL, 460),
('SEATING_CAP',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Approx. student seating capacity', 'number', NULL, 470),
('WALL_SUITABLE',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Wall suitable for mounting 65-inch interactive panel', 'select', '["Yes","No","Stand required"]', 480),
('CEILING_TYPE',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Ceiling / roof type', 'select', '["RCC","Tile","Sheet","Other"]', 490),
('CEILING_COND',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Ceiling / roof condition', 'select', '["Good","Repair"]', 500),
('DOORS_SECURE',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Door and windows can be secured', 'boolean', NULL, 510),
('FLOOR_WALL_COND', 'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Floor and wall condition', 'select', '["Good","Minor repair","Major repair"]', 520),
('WATER_LEAKAGE',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Water leakage / dampness observed', 'boolean', NULL, 530),
('FLOOD_PRONE',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room prone to flood / water entry', 'boolean', NULL, 540),
('NUM_CLASSROOMS',  'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'How many classrooms are available at school', 'number', NULL, 550),

-- F. Electrical, earthing & power-backup readiness
('ELECTRICITY',     'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Electricity available at school', 'boolean', NULL, 560),
('SUPPLY_CLASSROOM','F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Supply at selected classroom', 'select', '["Available","Extension required"]', 570),
('VOLTAGE',         'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Measured voltage (V)', 'text', NULL, 580),
('FREQUENCY',       'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Measured frequency (Hz)', 'text', NULL, 590),
('EARTHING',        'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Functional protective earthing', 'boolean', NULL, 600),
('SOCKETS',         'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Number of working sockets available in classroom', 'number', NULL, 610),

-- J. Existing assets status (fixed asset list)
('ASSET_PANEL_QTY',    'J. Existing Assets Status', 'Interactive panel / display', NULL, 'Quantity', 'number', NULL, 620),
('ASSET_PANEL_COND',   'J. Existing Assets Status', 'Interactive panel / display', NULL, 'Working condition', 'select', '["Good","Faulty"]', 630),
('ASSET_PC_QTY',       'J. Existing Assets Status', 'Desktop / laptop', NULL, 'Quantity', 'number', NULL, 640),
('ASSET_PC_COND',      'J. Existing Assets Status', 'Desktop / laptop', NULL, 'Working condition', 'select', '["Good","Faulty"]', 650),
('ASSET_UPS_QTY',      'J. Existing Assets Status', 'UPS / inverter', NULL, 'Quantity', 'number', NULL, 660),
('ASSET_UPS_COND',     'J. Existing Assets Status', 'UPS / inverter', NULL, 'Working condition', 'select', '["Good","Faulty"]', 670),
('ASSET_SOLAR_QTY',    'J. Existing Assets Status', 'Solar', NULL, 'Quantity', 'number', NULL, 680),
('ASSET_SOLAR_COND',   'J. Existing Assets Status', 'Solar', NULL, 'Working condition', 'select', '["Good","Faulty"]', 690),

-- K. Required geo-tagged photographs
('PHOTO_FRONT',     'K. Required Geo Tagged Photographs', NULL, NULL, 'School front with name board', 'photo', NULL, 700),
('PHOTO_PANEL_WALL','K. Required Geo Tagged Photographs', NULL, NULL, 'Selected classroom — front / panel wall', 'photo', NULL, 710),
('PHOTO_CLASSROOM', 'K. Required Geo Tagged Photographs', NULL, NULL, 'Selected classroom — full classroom view', 'photo', NULL, 720),

('KEY_OBSERVATIONS','Key Observations', NULL, NULL, 'Key observations', 'text', NULL, 730);

  INSERT INTO survey_section (project_id, section_name)
  SELECT DISTINCT v_project_id, t.section_name FROM tmp_survey_seed_069 t WHERE t.section_name IS NOT NULL
  ON CONFLICT (project_id, section_name) DO NOTHING;

  INSERT INTO survey_question (project_id, q_id, section_id, group_label, repeat_group, question, q_type_id, options, sort_order)
  SELECT v_project_id, t.q_id, ss.section_id, t.group_label, t.repeat_group, t.question, qt.type_id, t.options, t.sort_order
  FROM tmp_survey_seed_069 t
  LEFT JOIN survey_section ss       ON ss.project_id = v_project_id AND ss.section_name = t.section_name
  JOIN survey_question_type qt ON qt.type_name = t.q_type_name
  ON CONFLICT (project_id, q_id) DO NOTHING;

  DROP TABLE tmp_survey_seed_069;
END $$;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','069_survey_seed_sikkim.sql') ON CONFLICT DO NOTHING;
