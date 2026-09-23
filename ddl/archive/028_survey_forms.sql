SET search_path TO myactivity;

-- Main survey submission record
CREATE TABLE IF NOT EXISTS survey_submissions (
    id                          SERIAL PRIMARY KEY,
    school_name                 VARCHAR(255) NOT NULL,
    medium_of_instruction       VARCHAR(255),
    udise_code                  VARCHAR(50),
    village                     VARCHAR(255),
    block                       VARCHAR(255),
    district                    VARCHAR(255),
    pin                         VARCHAR(10),
    distance_from_block         VARCHAR(50),
    distance_from_district_hq   VARCHAR(50),
    hm_name                     VARCHAR(255),
    hm_contact                  VARCHAR(20),
    hm_email                    VARCHAR(255),
    supporting_staff_contact    VARCHAR(20),
    num_virtual_classrooms      INT DEFAULT 0,
    num_smart_classrooms        INT DEFAULT 0,
    power_available             BOOLEAN,
    power_duration              VARCHAR(50),
    earth_facility              VARCHAR(100),
    internet_available          BOOLEAN,
    internet_status             BOOLEAN,
    speed_ul                    VARCHAR(20),
    speed_dl                    VARCHAR(20),
    submitted_by                INT REFERENCES user_tbl(user_id) ON DELETE SET NULL,
    created_at                  TIMESTAMPTZ DEFAULT NOW(),
    updated_at                  TIMESTAMPTZ DEFAULT NOW()
);

-- Class-wise student counts (classes 6–10)
CREATE TABLE IF NOT EXISTS survey_student_details (
    id              SERIAL PRIMARY KEY,
    submission_id   INT NOT NULL REFERENCES survey_submissions(id) ON DELETE CASCADE,
    class_number    INT NOT NULL,
    section_a       INT DEFAULT 0,
    section_b       INT DEFAULT 0
);

-- Subject-wise teacher counts
CREATE TABLE IF NOT EXISTS survey_teacher_counts (
    id              SERIAL PRIMARY KEY,
    submission_id   INT NOT NULL REFERENCES survey_submissions(id) ON DELETE CASCADE,
    subject         VARCHAR(100) NOT NULL,
    count           INT DEFAULT 0
);

-- Mobile network providers (multiple rows per submission)
CREATE TABLE IF NOT EXISTS survey_mobile_networks (
    id               SERIAL PRIMARY KEY,
    submission_id    INT NOT NULL REFERENCES survey_submissions(id) ON DELETE CASCADE,
    service_provider VARCHAR(100),
    has_5g           BOOLEAN DEFAULT FALSE,
    has_4g           BOOLEAN DEFAULT FALSE,
    has_3g           BOOLEAN DEFAULT FALSE,
    signal_strength  VARCHAR(20)
);

-- Equipment status per classroom (virtual or digital)
CREATE TABLE IF NOT EXISTS survey_classroom_equipment (
    id              SERIAL PRIMARY KEY,
    submission_id   INT NOT NULL REFERENCES survey_submissions(id) ON DELETE CASCADE,
    classroom_type  VARCHAR(20) NOT NULL CHECK (classroom_type IN ('virtual', 'digital')),
    classroom_num   INT DEFAULT 1,
    -- 65" IFP Board
    ifp_display             VARCHAR(20),
    ifp_sound               VARCHAR(20),
    ifp_power_adaptor       VARCHAR(20),
    ifp_remote              VARCHAR(20),
    ifp_touch               VARCHAR(20),
    ifp_hdmi                VARCHAR(20),
    ifp_wifi                VARCHAR(20),
    ifp_usb                 VARCHAR(20),
    ifp_os                  VARCHAR(100),
    ifp_builtin_pc          VARCHAR(100),
    ifp_builtin_pc_status   VARCHAR(20),
    ifp_os_builtin          VARCHAR(100),
    ifp_os_version          VARCHAR(100),
    ifp_ram                 VARCHAR(100),
    ifp_processor           VARCHAR(100),
    ifp_processor_gen       VARCHAR(100),
    ifp_hdd_capacity        VARCHAR(100),
    ifp_hdd_type            VARCHAR(100),
    ifp_final_status        VARCHAR(20),
    ifp_remarks             TEXT,
    -- Web Camera
    webcam_display          VARCHAR(20),
    webcam_physical         VARCHAR(20),
    webcam_cable            VARCHAR(20),
    webcam_final_status     VARCHAR(20),
    webcam_remarks          TEXT,
    -- Wireless Microphone
    mic_base_station        VARCHAR(20),
    mic_power_adaptor       VARCHAR(20),
    mic_pc_cable            VARCHAR(20),
    mic_status              VARCHAR(20),
    mic_audio               VARCHAR(20),
    mic_final_status        VARCHAR(20),
    mic_remarks             TEXT,
    -- UPS
    ups_input_socket        VARCHAR(20),
    ups_switching           VARCHAR(20),
    ups_power_chord         VARCHAR(20),
    ups_battery_harness     VARCHAR(20),
    ups_physical            VARCHAR(20),
    ups_battery_series      VARCHAR(100),
    ups_battery_individual  VARCHAR(100),
    ups_battery_physical    VARCHAR(20),
    ups_final_status        VARCHAR(20),
    ups_remarks             TEXT,
    -- VSAT DISH (virtual classrooms only)
    vsat_reflector          VARCHAR(20),
    vsat_rx_cable           VARCHAR(20),
    vsat_tx_cable           VARCHAR(20),
    vsat_feedhorn           VARCHAR(20),
    vsat_lnb                VARCHAR(20),
    vsat_buc                VARCHAR(20),
    vsat_modem              VARCHAR(20),
    vsat_modem_adaptor      VARCHAR(20),
    vsat_lan_cable          VARCHAR(20),
    vsat_signal_strength    VARCHAR(20),
    vsat_final_status       VARCHAR(20),
    vsat_remarks            TEXT
);
