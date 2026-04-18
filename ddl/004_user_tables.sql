-- ============================================================================
-- FULL RESET: user_tbl & user_information (Updated Schema)
-- ============================================================================
SET search_path TO myactivity;

-- Optional: Uncomment these if you want a fresh start
-- DROP TABLE IF EXISTS user_information;
-- DROP TABLE IF EXISTS user_tbl;

-- 1. Core User Table
CREATE TABLE IF NOT EXISTS user_tbl (
    user_id       SERIAL PRIMARY KEY,
    emp_code      VARCHAR(50)  NOT NULL UNIQUE, 
    full_name     VARCHAR(150) NOT NULL,
    date_of_birth DATE         NOT NULL,
    gender        VARCHAR(20)  NOT NULL,
    mobile_number VARCHAR(15)  NOT NULL,
    email         VARCHAR(200) NOT NULL UNIQUE,
    nationality   VARCHAR(100) NOT NULL,
    is_active     SMALLINT     NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- 2. Extended User Information Table
CREATE TABLE IF NOT EXISTS user_information (
    user_info_id        SERIAL PRIMARY KEY,
    user_id             INT NOT NULL UNIQUE REFERENCES user_tbl(user_id) ON DELETE CASCADE,
    company_id          INT, -- REFERENCES company(company_id) if exists
    password            VARCHAR(255),
    title               VARCHAR(20),
    marital_status      VARCHAR(50),
    photo_available     BOOLEAN NOT NULL DEFAULT FALSE,
    photo_path          VARCHAR(500),
    payroll_group       VARCHAR(100),
    emergency_phone     VARCHAR(20),
    father_name         VARCHAR(150),
    mother_name         VARCHAR(150),
    spouse_name         VARCHAR(150),
    
    -- IDs & Docs
    aadhar_number       VARCHAR(12),
    aadhar_document     VARCHAR(500),
    pan_number          VARCHAR(10),
    pan_document        VARCHAR(500),
    
    -- Address
    perm_address        VARCHAR(500),
    perm_block          VARCHAR(100),
    perm_district       VARCHAR(100),
    perm_city           VARCHAR(100),
    perm_state          VARCHAR(100),
    perm_country        VARCHAR(100),
    perm_pincode        VARCHAR(10),
    curr_address        VARCHAR(500),
    curr_block          VARCHAR(100),
    curr_district       VARCHAR(100),
    curr_city           VARCHAR(100),
    curr_state          VARCHAR(100),
    curr_country        VARCHAR(100),
    curr_pincode        VARCHAR(10),
    same_as_permanent   BOOLEAN NOT NULL DEFAULT FALSE,
    
    -- Bank
    bank_name           VARCHAR(100),
    branch_name         VARCHAR(100),
    account_number      VARCHAR(50),
    ifsc_code           VARCHAR(20),
    bank_document       VARCHAR(500),
    
    -- Professional
    reporting_rm        VARCHAR(150),
    executive_name      VARCHAR(150),
    district_of_posting VARCHAR(100),
    block_of_posting    VARCHAR(100),
    experience_status   VARCHAR(100),
    department          VARCHAR(100),
    designation_id      INT,
    date_of_joining     DATE,
    date_of_exit        DATE,
    
    -- Education & Experience
    qualification       VARCHAR(150),
    college_name        VARCHAR(255),
    year_of_passout     VARCHAR(10),
    total_experience    VARCHAR(100),
    last_company_name   VARCHAR(255),
    last_date_of_leaving DATE,
    
    is_active           SMALLINT NOT NULL DEFAULT 1,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Indexes
CREATE INDEX IF NOT EXISTS idx_user_mobile ON user_tbl(mobile_number);
CREATE INDEX IF NOT EXISTS idx_user_info_company ON user_information(company_id);

-- 4. Dummy Data (2 Users)
INSERT INTO user_tbl (emp_code, full_name, date_of_birth, gender, mobile_number, email, nationality)
VALUES 
('EMP101', 'John Doe', '1990-05-15', 'Male', '9876543210', 'john.doe@example.com', 'Indian'),
('EMP102', 'Jane Smith', '1992-08-20', 'Female', '9876543211', 'jane.smith@example.com', 'Indian')
ON CONFLICT (emp_code) DO NOTHING;

INSERT INTO user_information (user_id, title, aadhar_number, aadhar_document, pan_number, pan_document, qualification, total_experience)
VALUES 
(1, 'Mr', '123456789012', '/uploads/docs/john_aadhar.pdf', 'ABCDE1234F', '/uploads/docs/john_pan.jpg', 'Bachelor''s Degree (UG)', '5 years'),
(2, 'Ms', '987654321098', '/uploads/docs/jane_aadhar.pdf', 'XYZW9876G', '/uploads/docs/jane_pan.jpg', 'MBA', 'Fresher (0 years)')
ON CONFLICT (user_id) DO NOTHING;

-- 5. Migration Tracking (Forcing version v1.0.0)
DELETE FROM schema_versions WHERE version = 'v1.0.0'; -- Clear old duplicates if any
INSERT INTO schema_versions (version, migration_file) 
VALUES ('v1.0.0', '004_full_user_rebuild.sql');