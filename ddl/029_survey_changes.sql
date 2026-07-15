SET search_path TO myactivity;

-- Dynamic student sections (replaces fixed section_a / section_b)
CREATE TABLE IF NOT EXISTS survey_student_sections (
    id              SERIAL PRIMARY KEY,
    submission_id   INT NOT NULL REFERENCES survey_submissions(id) ON DELETE CASCADE,
    class_number    INT NOT NULL,
    section_name    VARCHAR(10) NOT NULL,   -- A, B, C, D, ...
    student_count   INT DEFAULT 0
);

-- Evidence images per survey (one image per device per classroom)
CREATE TABLE IF NOT EXISTS survey_images (
    id              SERIAL PRIMARY KEY,
    submission_id   INT NOT NULL REFERENCES survey_submissions(id) ON DELETE CASCADE,
    field_ref       VARCHAR(100) NOT NULL,  -- e.g. virtual_0_ifp, digital_1_ups
    image_name      VARCHAR(255),
    full_path       VARCHAR(500),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
