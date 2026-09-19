-- DDL 068: Seed survey_question for "Sundargarh AI Virtual classroom" —
-- transcribed from SITE SURVEY FORM v2.pdf.
-- Equipment checklists (IFP/Webcam/Mic/UPS/VSAT) repeat per classroom
-- instance via repeat_group — the mobile app re-asks the same question set
-- each time the user taps "Add another classroom".
--
-- Resolved by project NAME, not a hardcoded id — the numeric project_id
-- this project happens to have differs between databases (dev vs
-- production), since it's an auto-increment value with its own independent
-- history in each environment. A literal id here would insert against the
-- wrong project (or none) anywhere the id doesn't match, exactly the
-- failure this caused on production.
SET search_path TO myactivity;

DO $$
DECLARE
  v_project_id INT;
BEGIN
  SELECT project_id INTO v_project_id FROM project WHERE project_name = 'Sundargarh AI Virtual classroom';
  IF v_project_id IS NULL THEN
    RAISE EXCEPTION 'Project "Sundargarh AI Virtual classroom" not found — create it first, then re-run this migration.';
  END IF;

  CREATE TEMP TABLE tmp_survey_seed_068 (
    q_id          VARCHAR(60),
    section_name  VARCHAR(150),
    group_label   VARCHAR(200),
    repeat_group  VARCHAR(50),
    question      TEXT,
    q_type_name   VARCHAR(20),
    options       JSON,
    sort_order    INT
  );

  INSERT INTO tmp_survey_seed_068 (q_id, section_name, group_label, repeat_group, question, q_type_name, options, sort_order) VALUES
-- A. School details
('SCH_NAME',       'A. School Details', NULL, NULL, 'School Name', 'text', NULL, 10),
('MEDIUM',          'A. School Details', NULL, NULL, 'Medium of Instruction(s)', 'text', NULL, 20),
('UDISE',           'A. School Details', NULL, NULL, 'UDise Code', 'text', NULL, 30),
('VILLAGE',         'A. School Details', NULL, NULL, 'Village', 'text', NULL, 40),
('BLOCK',           'A. School Details', NULL, NULL, 'Block', 'text', NULL, 50),
('DISTRICT',        'A. School Details', NULL, NULL, 'District', 'text', NULL, 60),
('PIN',             'A. School Details', NULL, NULL, 'Pin', 'text', NULL, 70),
('DIST_BLOCK',      'A. School Details', NULL, NULL, 'Distance from Block', 'text', NULL, 80),
('DIST_HQ',         'A. School Details', NULL, NULL, 'Distance from District HQ', 'text', NULL, 90),

-- Contact persons
('HM_NAME',         'Contact Persons', 'Head Master', NULL, 'Name', 'text', NULL, 100),
('HM_CONTACT',      'Contact Persons', 'Head Master', NULL, 'Contact no', 'text', NULL, 110),
('HM_EMAIL',        'Contact Persons', 'Head Master', NULL, 'Email Id', 'text', NULL, 120),
('SUPPORT_CONTACT', 'Contact Persons', NULL, NULL, 'Contact number of Virtual/Smart classroom Supporting staff', 'text', NULL, 130),
('NUM_VC',          'Contact Persons', NULL, NULL, 'Number of Virtual Class rooms', 'number', NULL, 140),
('NUM_DC',          'Contact Persons', NULL, NULL, 'Number of Smart Class rooms', 'number', NULL, 150),

-- Student details (fixed classes 6-10, Section A/B)
('STU_6_A',  'Student Details', NULL, NULL, 'Class 6 — Section A student count', 'number', NULL, 160),
('STU_6_B',  'Student Details', NULL, NULL, 'Class 6 — Section B student count', 'number', NULL, 170),
('STU_7_A',  'Student Details', NULL, NULL, 'Class 7 — Section A student count', 'number', NULL, 180),
('STU_7_B',  'Student Details', NULL, NULL, 'Class 7 — Section B student count', 'number', NULL, 190),
('STU_8_A',  'Student Details', NULL, NULL, 'Class 8 — Section A student count', 'number', NULL, 200),
('STU_8_B',  'Student Details', NULL, NULL, 'Class 8 — Section B student count', 'number', NULL, 210),
('STU_9_A',  'Student Details', NULL, NULL, 'Class 9 — Section A student count', 'number', NULL, 220),
('STU_9_B',  'Student Details', NULL, NULL, 'Class 9 — Section B student count', 'number', NULL, 230),
('STU_10_A', 'Student Details', NULL, NULL, 'Class 10 — Section A student count', 'number', NULL, 240),
('STU_10_B', 'Student Details', NULL, NULL, 'Class 10 — Section B student count', 'number', NULL, 250),

-- Number of teachers (fixed subjects)
('TCH_MATH',    'Number of Teachers', NULL, NULL, 'Mathematics — teacher count', 'number', NULL, 260),
('TCH_SCI',     'Number of Teachers', NULL, NULL, 'Science — teacher count', 'number', NULL, 270),
('TCH_SOC',     'Number of Teachers', NULL, NULL, 'Social Studies — teacher count', 'number', NULL, 280),
('TCH_ENG',     'Number of Teachers', NULL, NULL, 'English — teacher count', 'number', NULL, 290),
('TCH_ODIA',    'Number of Teachers', NULL, NULL, 'Odia — teacher count', 'number', NULL, 300),
('TCH_HINDI',   'Number of Teachers', NULL, NULL, 'Hindi — teacher count', 'number', NULL, 310),
('TCH_COMP',    'Number of Teachers', NULL, NULL, 'Computer — teacher count', 'number', NULL, 320),
('TCH_PT',      'Number of Teachers', NULL, NULL, 'PT — teacher count', 'number', NULL, 330),

-- Power connectivity
('POWER_AVAIL',  'Power Connectivity', NULL, NULL, 'Power Availability in the school', 'boolean', NULL, 340),
('POWER_DUR',    'Power Connectivity', NULL, NULL, 'Power Duration (in hrs.)', 'text', NULL, 350),
('EARTH_FAC',    'Power Connectivity', NULL, NULL, 'Earth Facility for Mains Power Supply', 'text', NULL, 360),

-- Internet connectivity
('NET_AVAIL',    'Internet Connectivity', NULL, NULL, 'Internet Available at School', 'boolean', NULL, 370),
('NET_STATUS',   'Internet Connectivity', NULL, NULL, 'Status of Internet', 'boolean', NULL, 380),
('SPEED_UL',     'Internet Connectivity', NULL, NULL, 'Speed Test Result — UL', 'text', NULL, 390),
('SPEED_DL',     'Internet Connectivity', NULL, NULL, 'Speed Test Result — DL', 'text', NULL, 400),

-- Mobile networks (variable count — "Add another network")
('NET_PROVIDER',  'Mobile Networks Available', NULL, 'mobile_network', 'Service Provider', 'text', NULL, 410),
('NET_5G',        'Mobile Networks Available', NULL, 'mobile_network', '5G Available', 'boolean', NULL, 420),
('NET_4G',        'Mobile Networks Available', NULL, 'mobile_network', '4G Available', 'boolean', NULL, 430),
('NET_3G',        'Mobile Networks Available', NULL, 'mobile_network', '3G Available', 'boolean', NULL, 440),
('NET_SIGNAL',    'Mobile Networks Available', NULL, 'mobile_network', 'Signal Strength', 'select', '["Good","Average","Poor"]', 450),

-- Virtual Classroom equipment — repeats per classroom instance ("Add another virtual classroom")
('VC_IFP_DISPLAY',   'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Display', 'select', '["Working","Not Working"]', 460),
('VC_IFP_SOUND',     'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Sound via speakers', 'select', '["Working","Not Working"]', 470),
('VC_IFP_POWER',     'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Power Supply Adaptor', 'select', '["Working","Not Working"]', 480),
('VC_IFP_REMOTE',    'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Remote', 'select', '["Working","Not Working"]', 490),
('VC_IFP_TOUCH',     'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Touch', 'select', '["Working","Not Working"]', 500),
('VC_IFP_HDMI',      'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'HDMI Connectivity', 'select', '["Working","Not Working"]', 510),
('VC_IFP_WIFI',      'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Wi Fi Connectivity', 'select', '["Working","Not Working"]', 520),
('VC_IFP_USB',       'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'USB Ports', 'select', '["Working","Not Working"]', 530),
('VC_IFP_OS',        'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'OS of IFP', 'text', NULL, 540),
('VC_IFP_PC',        'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Built in PC/OPS/External PC', 'text', NULL, 550),
('VC_IFP_PC_STATUS', 'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Status of Built in PC/OPS/External PC', 'select', '["Working","Not Working"]', 560),
('VC_IFP_PC_OS',     'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'OS of Built in PC/OPS/External PC', 'text', NULL, 570),
('VC_IFP_OS_VER',    'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'OS version number', 'text', NULL, 580),
('VC_IFP_RAM',       'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Ram Capacity and Type', 'text', NULL, 590),
('VC_IFP_CPU',       'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Processor Details', 'text', NULL, 600),
('VC_IFP_CPU_GEN',   'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Processor Generation', 'text', NULL, 610),
('VC_IFP_HDD_CAP',   'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Hard Disk capacity', 'text', NULL, 620),
('VC_IFP_HDD_TYPE',  'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Hard disk Type', 'text', NULL, 630),
('VC_IFP_FINAL',     'Status of Virtual Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'virtual_classroom', 'Final Status of 65" Integrated Touch/e-Board', 'select', '["Working","Partial working","Not Working"]', 640),

('VC_CAM_DISPLAY',   'Status of Virtual Class room', 'Web camera', 'virtual_classroom', 'Web cam Display', 'select', '["Working","Not Working"]', 650),
('VC_CAM_PHYSICAL',  'Status of Virtual Class room', 'Web camera', 'virtual_classroom', 'Web Cam Physical status', 'select', '["Good","Damaged"]', 660),
('VC_CAM_CABLE',     'Status of Virtual Class room', 'Web camera', 'virtual_classroom', 'Web cam Cable', 'select', '["Working","Not Working"]', 670),
('VC_CAM_FINAL',     'Status of Virtual Class room', 'Web camera', 'virtual_classroom', 'Final Status of Web camera', 'select', '["Working","Partial working","Not Working"]', 680),

('VC_MIC_BASE',      'Status of Virtual Class room', 'Wireless Microphone', 'virtual_classroom', 'Mic Base Station', 'select', '["Working","Not Working"]', 690),
('VC_MIC_ADAPTOR',   'Status of Virtual Class room', 'Wireless Microphone', 'virtual_classroom', 'Base Station Power Adaptor', 'select', '["Working","Not Working"]', 700),
('VC_MIC_CABLE',     'Status of Virtual Class room', 'Wireless Microphone', 'virtual_classroom', 'Base Station to PC cable', 'select', '["Working","Not Working"]', 710),
('VC_MIC_STATUS',    'Status of Virtual Class room', 'Wireless Microphone', 'virtual_classroom', 'Mic Status', 'select', '["Working","Not Working"]', 720),
('VC_MIC_AUDIO',     'Status of Virtual Class room', 'Wireless Microphone', 'virtual_classroom', 'Mic Audio', 'select', '["Good","Poor"]', 730),
('VC_MIC_FINAL',     'Status of Virtual Class room', 'Wireless Microphone', 'virtual_classroom', 'Final Status of Wireless Microphone', 'select', '["Working","Partial working","Not Working"]', 740),

('VC_UPS_SOCKET',    'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'UPS input Socket', 'select', '["Working","Not Working"]', 750),
('VC_UPS_SWITCH',    'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'UPS switching', 'select', '["Working","Not Working"]', 760),
('VC_UPS_CHORD',     'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'UPS Power chord', 'select', '["Working","Not Working"]', 770),
('VC_UPS_HARNESS',   'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'UPS to battery Harness cable', 'select', '["Working","Not Working"]', 780),
('VC_UPS_PHYSICAL',  'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'UPS physical condition', 'select', '["Good","Damaged"]', 790),
('VC_UPS_BATT_SER',  'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'Battery voltage in series', 'text', NULL, 800),
('VC_UPS_BATT_IND',  'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'Battery Voltage individual', 'text', NULL, 810),
('VC_UPS_BATT_PHYS', 'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'Battery Physical condition', 'select', '["Good","Damaged"]', 820),
('VC_UPS_FINAL',     'Status of Virtual Class room', 'UPS', 'virtual_classroom', 'Final Status of UPS', 'select', '["Working","Partial working","Not Working"]', 830),

('VC_VSAT_REFLECTOR','Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'Reflector', 'select', '["Working","Not Working"]', 840),
('VC_VSAT_RX',       'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'RX cable', 'select', '["Working","Not Working"]', 850),
('VC_VSAT_TX',       'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'TX Cable', 'select', '["Working","Not Working"]', 860),
('VC_VSAT_FEEDHORN', 'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'Feedhorn', 'select', '["Working","Not Working"]', 870),
('VC_VSAT_LNB',      'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'LNB', 'select', '["Working","Not Working"]', 880),
('VC_VSAT_BUC',      'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'BUC', 'select', '["Working","Not Working"]', 890),
('VC_VSAT_MODEM',    'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'Modem', 'select', '["Working","Not Working"]', 900),
('VC_VSAT_MODEM_AD', 'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'Modem power adaptor', 'select', '["Working","Not Working"]', 910),
('VC_VSAT_LAN',      'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'LAN Cable', 'select', '["Working","Not Working"]', 920),
('VC_VSAT_FINAL',    'Status of Virtual Class room', 'VSAT Dish', 'virtual_classroom', 'Final Status of VSAT Dish', 'select', '["Working","Partial working","Not Working"]', 930),

-- Digital Classroom equipment — repeats per classroom instance ("Add another digital classroom")
('DC_IFP_DISPLAY',   'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Display', 'select', '["Working","Not Working"]', 940),
('DC_IFP_SOUND',     'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Sound via speakers', 'select', '["Working","Not Working"]', 950),
('DC_IFP_POWER',     'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Power Supply Adaptor', 'select', '["Working","Not Working"]', 960),
('DC_IFP_REMOTE',    'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Remote', 'select', '["Working","Not Working"]', 970),
('DC_IFP_TOUCH',     'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Touch', 'select', '["Working","Not Working"]', 980),
('DC_IFP_HDMI',      'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'HDMI Connectivity', 'select', '["Working","Not Working"]', 990),
('DC_IFP_WIFI',      'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Wi Fi Connectivity', 'select', '["Working","Not Working"]', 1000),
('DC_IFP_USB',       'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'USB Ports', 'select', '["Working","Not Working"]', 1010),
('DC_IFP_OS',        'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'OS of IFP', 'text', NULL, 1020),
('DC_IFP_PC',        'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Built in PC/OPS/External PC', 'text', NULL, 1030),
('DC_IFP_PC_STATUS', 'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Status of Built in PC/OPS/External PC', 'select', '["Working","Not Working"]', 1040),
('DC_IFP_PC_OS',     'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'OS of Built in PC/OPS/External PC', 'text', NULL, 1050),
('DC_IFP_OS_VER',    'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'OS version number', 'text', NULL, 1060),
('DC_IFP_RAM',       'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Ram Capacity and Type', 'text', NULL, 1070),
('DC_IFP_CPU',       'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Processor Details', 'text', NULL, 1080),
('DC_IFP_CPU_GEN',   'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Processor Generation', 'text', NULL, 1090),
('DC_IFP_HDD_CAP',   'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Hard Disk capacity', 'text', NULL, 1100),
('DC_IFP_HDD_TYPE',  'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Hard disk Type', 'text', NULL, 1110),
('DC_IFP_FINAL',     'Status of Digital Class room', '65" Integrated Touch / e-Board with Embedded IR / Capacitive Touch + Built in PC with TV OS', 'digital_classroom', 'Final Status of 65" Integrated Touch/e-Board', 'select', '["Working","Partial working","Not Working"]', 1120),

('DC_UPS_SOCKET',    'Status of Digital Class room', 'UPS', 'digital_classroom', 'UPS input Socket', 'select', '["Working","Not Working"]', 1130),
('DC_UPS_SWITCH',    'Status of Digital Class room', 'UPS', 'digital_classroom', 'UPS switching', 'select', '["Working","Not Working"]', 1140),
('DC_UPS_CHORD',     'Status of Digital Class room', 'UPS', 'digital_classroom', 'UPS Power chord', 'select', '["Working","Not Working"]', 1150),
('DC_UPS_HARNESS',   'Status of Digital Class room', 'UPS', 'digital_classroom', 'UPS to battery Harness cable', 'select', '["Working","Not Working"]', 1160),
('DC_UPS_PHYSICAL',  'Status of Digital Class room', 'UPS', 'digital_classroom', 'UPS physical condition', 'select', '["Good","Damaged"]', 1170),
('DC_UPS_BATT_SER',  'Status of Digital Class room', 'UPS', 'digital_classroom', 'Battery voltage in series', 'text', NULL, 1180),
('DC_UPS_BATT_IND',  'Status of Digital Class room', 'UPS', 'digital_classroom', 'Battery Voltage individual', 'text', NULL, 1190),
('DC_UPS_BATT_PHYS', 'Status of Digital Class room', 'UPS', 'digital_classroom', 'Battery Physical condition', 'select', '["Good","Damaged"]', 1200),
('DC_UPS_FINAL',     'Status of Digital Class room', 'UPS', 'digital_classroom', 'Final Status of UPS', 'select', '["Working","Partial working","Not Working"]', 1210);

  INSERT INTO survey_section (project_id, section_name)
  SELECT DISTINCT v_project_id, t.section_name FROM tmp_survey_seed_068 t WHERE t.section_name IS NOT NULL
  ON CONFLICT (project_id, section_name) DO NOTHING;

  INSERT INTO survey_question (project_id, q_id, section_id, group_label, repeat_group, question, q_type_id, options, sort_order)
  SELECT v_project_id, t.q_id, ss.section_id, t.group_label, t.repeat_group, t.question, qt.type_id, t.options, t.sort_order
  FROM tmp_survey_seed_068 t
  LEFT JOIN survey_section ss       ON ss.project_id = v_project_id AND ss.section_name = t.section_name
  JOIN survey_question_type qt ON qt.type_name = t.q_type_name
  ON CONFLICT (project_id, q_id) DO NOTHING;

  DROP TABLE tmp_survey_seed_068;
END $$;

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','068_survey_seed_sundargarh.sql') ON CONFLICT DO NOTHING;
