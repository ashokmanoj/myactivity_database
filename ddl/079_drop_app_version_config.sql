-- DDL 079: Drop app_version_config — the app is now distributed via the
-- Play Store, so the in-house APK upload/hosting feature and its
-- min-version force-update gate (middleware/auth.js) are retired.
-- 038_app_version_config.sql is archived (see database/ddl/archive/README.md)
-- so a fresh database never creates this table in the first place; this
-- migration cleans it up on any database where 038 already ran.
SET search_path TO myactivity;

DROP TABLE IF EXISTS app_version_config;
