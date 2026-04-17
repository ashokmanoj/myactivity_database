-- ============================================================================
-- MASTER SCRIPT: Run this single file to set up the entire database
-- Usage: psql -U postgres -d myactivitydb -f run_all.sql
-- ============================================================================

-- ── Step 1: Schema + Version Tracking ───────────────────────────────────────
\i 'ddl/001_schema.sql'

-- ── Step 2: Tables ──────────────────────────────────────────────────────────
\i 'ddl/002_projects_tables.sql'
\i 'ddl/003_location_tables.sql'
\i 'ddl/004_user_tables.sql'
\i 'ddl/005_location_track.sql'
\i 'ddl/006_token_blacklist.sql'

-- ── Step 3: Functions — Auth ────────────────────────────────────────────────
\i 'functions/auth/fn_find_company.sql'
\i 'functions/auth/fn_login.sql'
\i 'functions/auth/fn_update_last_login.sql'
\i 'functions/auth/fn_blacklist_token.sql'
\i 'functions/auth/fn_is_token_blacklisted.sql'
\i 'functions/auth/fn_get_profile.sql'
\i 'functions/auth/fn_register_login.sql'
\i 'functions/auth/fn_change_password.sql'

-- ── Step 3: Functions — Company ─────────────────────────────────────────────
\i 'functions/company/fn_company_get_all.sql'
\i 'functions/company/fn_company_get_by_id.sql'
\i 'functions/company/fn_company_create.sql'
\i 'functions/company/fn_company_update.sql'
\i 'functions/company/fn_company_remove.sql'
\i 'functions/company/fn_company_exists.sql'

-- ── Step 3: Functions — Project ─────────────────────────────────────────────
\i 'functions/project/fn_project_get_all.sql'
\i 'functions/project/fn_project_get_by_id.sql'
\i 'functions/project/fn_project_create.sql'
\i 'functions/project/fn_project_update.sql'
\i 'functions/project/fn_project_remove.sql'
\i 'functions/project/fn_project_exists.sql'
\i 'functions/project/fn_project_sync.sql'

-- ── Step 3: Functions — Designation ─────────────────────────────────────────
\i 'functions/designation/fn_designation_get_all.sql'
\i 'functions/designation/fn_designation_get_by_id.sql'
\i 'functions/designation/fn_designation_create.sql'
\i 'functions/designation/fn_designation_update.sql'
\i 'functions/designation/fn_designation_remove.sql'
\i 'functions/designation/fn_designation_exists.sql'
\i 'functions/designation/fn_designation_name_exists.sql'
\i 'functions/designation/fn_designation_sync.sql'

-- ── Step 3: Functions — District ────────────────────────────────────────────
\i 'functions/district/fn_district_get_all.sql'
\i 'functions/district/fn_district_get_by_id.sql'
\i 'functions/district/fn_district_create.sql'
\i 'functions/district/fn_district_update.sql'
\i 'functions/district/fn_district_remove.sql'
\i 'functions/district/fn_district_exists.sql'
\i 'functions/district/fn_district_sync.sql'

-- ── Step 3: Functions — Block ───────────────────────────────────────────────
\i 'functions/block/fn_block_get_all.sql'
\i 'functions/block/fn_block_get_by_id.sql'
\i 'functions/block/fn_block_create.sql'
\i 'functions/block/fn_block_update.sql'
\i 'functions/block/fn_block_remove.sql'
\i 'functions/block/fn_block_exists.sql'
\i 'functions/block/fn_block_sync.sql'

-- ── Step 3: Functions — Institution ─────────────────────────────────────────
\i 'institution_functions.sql'

-- ── Step 3: Functions — Institution Map ─────────────────────────────────────
\i 'institution_map_functions.sql'

-- ── Step 3: Functions — Location ────────────────────────────────────────────
\i 'location_functions.sql'

-- ── Step 3: Functions — User Management ─────────────────────────────────────
\i 'functions/user_management/fn_user_get_all.sql'
\i 'functions/user_management/fn_user_get_by_id.sql'
\i 'functions/user_management/fn_user_get_by_emp_code.sql'
\i 'functions/user_management/fn_user_create.sql'
\i 'functions/user_management/fn_user_update.sql'
\i 'functions/user_management/fn_user_remove.sql'
\i 'functions/user_management/fn_user_exists.sql'
\i 'functions/user_management/fn_user_emp_code_taken.sql'
\i 'functions/user_management/fn_user_email_taken.sql'
\i 'functions/user_management/fn_user_sync.sql'
\i 'functions/user_management/fn_user_info_get_all.sql'
\i 'functions/user_management/fn_user_info_get_by_id.sql'
\i 'functions/user_management/fn_user_info_get_by_user_id.sql'

-- ── Step 4: Seed Data ───────────────────────────────────────────────────────
\i 'dml/001_seed_data.sql'

-- ── Done ────────────────────────────────────────────────────────────────────
\echo '✅ All tables, functions, and seed data created successfully!'
