-- ============================================================================
-- DDL 004: user_tbl, user_information, user_login
-- ============================================================================
SET search_path TO public;

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
CREATE INDEX IF NOT EXISTS idx_user_mobile ON user_tbl(mobile_number);
CREATE INDEX IF NOT EXISTS idx_user_active ON user_tbl(is_active);

CREATE TABLE IF NOT EXISTS user_information (
    user_info_id        SERIAL PRIMARY KEY,
    user_id             INT NOT NULL UNIQUE REFERENCES user_tbl(user_id),
    company_id          INT REFERENCES company(company_id),
    title               VARCHAR(20),
    photo_available     BOOLEAN     NOT NULL DEFAULT FALSE,
    photo_path          VARCHAR(500),
    payroll_group       VARCHAR(100),
    emergency_phone     VARCHAR(20),
    father_name         VARCHAR(150),
    mother_name         VARCHAR(150),
    spouse_name         VARCHAR(150),
    aadhar_number       VARCHAR(12),
    pan_number          VARCHAR(10),
    perm_address        VARCHAR(500),
    perm_city           VARCHAR(100),
    perm_state          VARCHAR(100),
    perm_country        VARCHAR(100),
    perm_pincode        VARCHAR(10),
    curr_address        VARCHAR(500),
    curr_city           VARCHAR(100),
    curr_state          VARCHAR(100),
    curr_country        VARCHAR(100),
    curr_pincode        VARCHAR(10),
    same_as_permanent   BOOLEAN     NOT NULL DEFAULT FALSE,
    bank_name           VARCHAR(100),
    branch_name         VARCHAR(100),
    account_number      VARCHAR(50),
    ifsc_code           VARCHAR(20),
    bank_document       VARCHAR(500),
    reporting_rm        VARCHAR(150),
    executive_name      VARCHAR(150),
    district_of_posting VARCHAR(100),
    block_of_posting    VARCHAR(100),
    experience_status   VARCHAR(100),
    department          VARCHAR(100),
    designation_id      INT REFERENCES designation(designation_id),
    is_active           SMALLINT    NOT NULL DEFAULT 1,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_user_info_company ON user_information(company_id);

CREATE TABLE IF NOT EXISTS user_login (
    login_id      SERIAL PRIMARY KEY,
    user_id       INT         NOT NULL UNIQUE REFERENCES user_tbl(user_id),
    mobile_number VARCHAR(15) NOT NULL,
    password      VARCHAR(255) NOT NULL,
    company_id    INT REFERENCES company(company_id),
    last_login_at TIMESTAMPTZ,
    is_active     SMALLINT    NOT NULL DEFAULT 1,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_login_mobile ON user_login(mobile_number);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','004_user_tables.sql') ON CONFLICT DO NOTHING;
