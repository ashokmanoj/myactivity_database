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

  INSERT INTO survey_question (project_id, q_id, section, group_label, repeat_group, question, q_type, options, sort_order) VALUES
-- A. School details
(v_project_id,'SCH_NAME',    'A. School Details', NULL, NULL, 'School name', 'text', NULL, 10),
(v_project_id,'UDISE',        'A. School Details', NULL, NULL, 'UDISE code', 'text', NULL, 20),
(v_project_id,'VILLAGE',      'A. School Details', NULL, NULL, 'Village / locality', 'text', NULL, 30),
(v_project_id,'PIN',          'A. School Details', NULL, NULL, 'PIN code', 'text', NULL, 40),
(v_project_id,'BLOCK',        'A. School Details', NULL, NULL, 'Block', 'text', NULL, 50),
(v_project_id,'DISTRICT',     'A. School Details', NULL, NULL, 'District', 'text', NULL, 60),
(v_project_id,'LATITUDE',     'A. School Details', NULL, NULL, 'Latitude', 'text', NULL, 70),
(v_project_id,'LONGITUDE',    'A. School Details', NULL, NULL, 'Longitude', 'text', NULL, 80),
(v_project_id,'MEDIUM',       'A. School Details', NULL, NULL, 'Medium(s) of instruction', 'text', NULL, 90),
(v_project_id,'CLASSES',      'A. School Details', NULL, NULL, 'Classes available', 'text', NULL, 100),
(v_project_id,'DIST_EDU_OFF', 'A. School Details', NULL, NULL, 'Distance from District Education Office', 'text', NULL, 110),
(v_project_id,'LAST_MILE',    'A. School Details', NULL, NULL, 'Nearest motorable access / last-mile distance', 'text', NULL, 120),

-- B. Contact persons
(v_project_id,'HOS_NAME',    'B. Contact Persons', 'Head of School', NULL, 'Name', 'text', NULL, 130),
(v_project_id,'HOS_MOBILE',  'B. Contact Persons', 'Head of School', NULL, 'Mobile number', 'text', NULL, 140),
(v_project_id,'HOS_EMAIL',   'B. Contact Persons', 'Head of School', NULL, 'Email id', 'text', NULL, 150),
(v_project_id,'ICT_NAME',    'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Name', 'text', NULL, 160),
(v_project_id,'ICT_MOBILE',  'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Mobile number', 'text', NULL, 170),
(v_project_id,'ICT_EMAIL',   'B. Contact Persons', 'ICT / Computer Teacher', NULL, 'Email id', 'text', NULL, 180),

-- C. Student details (fixed classes 6-12, two mediums)
(v_project_id,'STU_6_M1',  'C. Student Details', NULL, NULL, 'Class 6 — Students count (Medium 1)', 'number', NULL, 190),
(v_project_id,'STU_6_M2',  'C. Student Details', NULL, NULL, 'Class 6 — Students count (Medium 2)', 'number', NULL, 200),
(v_project_id,'STU_7_M1',  'C. Student Details', NULL, NULL, 'Class 7 — Students count (Medium 1)', 'number', NULL, 210),
(v_project_id,'STU_7_M2',  'C. Student Details', NULL, NULL, 'Class 7 — Students count (Medium 2)', 'number', NULL, 220),
(v_project_id,'STU_8_M1',  'C. Student Details', NULL, NULL, 'Class 8 — Students count (Medium 1)', 'number', NULL, 230),
(v_project_id,'STU_8_M2',  'C. Student Details', NULL, NULL, 'Class 8 — Students count (Medium 2)', 'number', NULL, 240),
(v_project_id,'STU_9_M1',  'C. Student Details', NULL, NULL, 'Class 9 — Students count (Medium 1)', 'number', NULL, 250),
(v_project_id,'STU_9_M2',  'C. Student Details', NULL, NULL, 'Class 9 — Students count (Medium 2)', 'number', NULL, 260),
(v_project_id,'STU_10_M1', 'C. Student Details', NULL, NULL, 'Class 10 — Students count (Medium 1)', 'number', NULL, 270),
(v_project_id,'STU_10_M2', 'C. Student Details', NULL, NULL, 'Class 10 — Students count (Medium 2)', 'number', NULL, 280),
(v_project_id,'STU_11_M1', 'C. Student Details', NULL, NULL, 'Class 11 — Students count (Medium 1)', 'number', NULL, 290),
(v_project_id,'STU_11_M2', 'C. Student Details', NULL, NULL, 'Class 11 — Students count (Medium 2)', 'number', NULL, 300),
(v_project_id,'STU_12_M1', 'C. Student Details', NULL, NULL, 'Class 12 — Students count (Medium 1)', 'number', NULL, 310),
(v_project_id,'STU_12_M2', 'C. Student Details', NULL, NULL, 'Class 12 — Students count (Medium 2)', 'number', NULL, 320),

-- D. Site access, logistics & VSAT feasibility (each has its own Remarks via survey_answer.remarks)
(v_project_id,'ROAD_ACCESS',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Motorable road available up to school', 'boolean', NULL, 330),
(v_project_id,'HILLY',          'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Hilly / difficult-access location', 'boolean', NULL, 340),
(v_project_id,'WEATHER_RISK',   'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Heavy rainfall / snow / high-wind exposure', 'boolean', NULL, 350),
(v_project_id,'SKY_VIEW',       'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Clear satellite sky view at proposed antenna location', 'select', '["Clear","Obstructed"]', 360),
(v_project_id,'OBSTRUCTION',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Obstruction type and direction', 'select', '["Trees","Forest","Building","Hill","Other"]', 370),
(v_project_id,'ANTENNA_LOC',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Proposed antenna location', 'select', '["RCC roof","Slant roof","Wall","Ground mount"]', 380),
(v_project_id,'CABLE_ROUTE',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Approx. antenna-to-classroom cable route (metres)', 'number', NULL, 390),
(v_project_id,'SAFE_ACCESS',    'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Safe access for antenna installation and maintenance', 'boolean', NULL, 400),
(v_project_id,'INTERNET_EXIST', 'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Existing internet connection', 'boolean', NULL, 410),
(v_project_id,'CONN_TYPE',      'D. Site Access, Logistics & VSAT Feasibility', NULL, NULL, 'Connectivity type', 'select', '["Fibre","Broadband","Other"]', 420),

-- E. Selected classroom — civil & safety readiness
(v_project_id,'ROOM_APPROVED',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Dedicated classroom approved for virtual classroom', 'boolean', NULL, 430),
(v_project_id,'ROOM_LENGTH',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal length (ft)', 'number', NULL, 440),
(v_project_id,'ROOM_BREADTH',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal breadth (ft)', 'number', NULL, 450),
(v_project_id,'ROOM_HEIGHT',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room internal height (ft)', 'number', NULL, 460),
(v_project_id,'SEATING_CAP',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Approx. student seating capacity', 'number', NULL, 470),
(v_project_id,'WALL_SUITABLE',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Wall suitable for mounting 65-inch interactive panel', 'select', '["Yes","No","Stand required"]', 480),
(v_project_id,'CEILING_TYPE',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Ceiling / roof type', 'select', '["RCC","Tile","Sheet","Other"]', 490),
(v_project_id,'CEILING_COND',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Ceiling / roof condition', 'select', '["Good","Repair"]', 500),
(v_project_id,'DOORS_SECURE',    'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Door and windows can be secured', 'boolean', NULL, 510),
(v_project_id,'FLOOR_WALL_COND', 'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Floor and wall condition', 'select', '["Good","Minor repair","Major repair"]', 520),
(v_project_id,'WATER_LEAKAGE',   'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Water leakage / dampness observed', 'boolean', NULL, 530),
(v_project_id,'FLOOD_PRONE',     'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'Room prone to flood / water entry', 'boolean', NULL, 540),
(v_project_id,'NUM_CLASSROOMS',  'E. Selected Classroom — Civil & Safety Readiness', NULL, NULL, 'How many classrooms are available at school', 'number', NULL, 550),

-- F. Electrical, earthing & power-backup readiness
(v_project_id,'ELECTRICITY',     'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Electricity available at school', 'boolean', NULL, 560),
(v_project_id,'SUPPLY_CLASSROOM','F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Supply at selected classroom', 'select', '["Available","Extension required"]', 570),
(v_project_id,'VOLTAGE',         'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Measured voltage (V)', 'number', NULL, 580),
(v_project_id,'FREQUENCY',       'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Measured frequency (Hz)', 'number', NULL, 590),
(v_project_id,'EARTHING',        'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Functional protective earthing', 'boolean', NULL, 600),
(v_project_id,'SOCKETS',         'F. Electrical, Earthing & Power-backup Readiness', NULL, NULL, 'Number of working sockets available in classroom', 'number', NULL, 610),

-- J. Existing assets status (fixed asset list)
(v_project_id,'ASSET_PANEL_QTY',    'J. Existing Assets Status', 'Interactive panel / display', NULL, 'Quantity', 'number', NULL, 620),
(v_project_id,'ASSET_PANEL_COND',   'J. Existing Assets Status', 'Interactive panel / display', NULL, 'Working condition', 'select', '["Good","Faulty"]', 630),
(v_project_id,'ASSET_PC_QTY',       'J. Existing Assets Status', 'Desktop / laptop', NULL, 'Quantity', 'number', NULL, 640),
(v_project_id,'ASSET_PC_COND',      'J. Existing Assets Status', 'Desktop / laptop', NULL, 'Working condition', 'select', '["Good","Faulty"]', 650),
(v_project_id,'ASSET_UPS_QTY',      'J. Existing Assets Status', 'UPS / inverter', NULL, 'Quantity', 'number', NULL, 660),
(v_project_id,'ASSET_UPS_COND',     'J. Existing Assets Status', 'UPS / inverter', NULL, 'Working condition', 'select', '["Good","Faulty"]', 670),
(v_project_id,'ASSET_SOLAR_QTY',    'J. Existing Assets Status', 'Solar', NULL, 'Quantity', 'number', NULL, 680),
(v_project_id,'ASSET_SOLAR_COND',   'J. Existing Assets Status', 'Solar', NULL, 'Working condition', 'select', '["Good","Faulty"]', 690),

-- K. Required geo-tagged photographs
(v_project_id,'PHOTO_FRONT',     'K. Required Geo Tagged Photographs', NULL, NULL, 'School front with name board', 'photo', NULL, 700),
(v_project_id,'PHOTO_PANEL_WALL','K. Required Geo Tagged Photographs', NULL, NULL, 'Selected classroom — front / panel wall', 'photo', NULL, 710),
(v_project_id,'PHOTO_CLASSROOM', 'K. Required Geo Tagged Photographs', NULL, NULL, 'Selected classroom — full classroom view', 'photo', NULL, 720),

(v_project_id,'KEY_OBSERVATIONS','Key Observations', NULL, NULL, 'Key observations', 'text', NULL, 730)
  ON CONFLICT (project_id, q_id) DO NOTHING;
END $$;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','069_survey_seed_sikkim.sql') ON CONFLICT DO NOTHING;
