-- DDL 088: Drop file_blob (from DDL 078). Every file it held has been
-- uploaded to DigitalOcean Spaces and every DB column that referenced it has
-- been rewritten to the resulting Spaces URL (see
-- myactivity_backend/src/scripts/migrate-blobs-to-spaces.js) — no file bytes
-- are stored in this database any more, only the Spaces URL/path, per the
-- app's design (presigned-URL uploads direct to Spaces).
SET search_path TO myactivity;

DROP TABLE IF EXISTS file_blob;
