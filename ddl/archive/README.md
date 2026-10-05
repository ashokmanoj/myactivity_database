# Archived DDL files

These files are **not run** by `run-all-migrations.js` and are kept only for historical
reference.

| File | What it did | Dropped by |
|---|---|---|
| `028_survey_forms.sql` | Created the original fixed-shape `survey_submissions`-style tables | `070_drop_legacy_survey_tables.sql` |
| `029_survey_changes.sql` | Follow-up changes to that fixed-shape system | `070_drop_legacy_survey_tables.sql` |
| `032_survey_add_vsat_signal_strength.sql` | Added a column to that same old system | `070_drop_legacy_survey_tables.sql` |
| `038_app_version_config.sql` | Created the APK upload/min-version force-update table — retired once the app shipped via the Play Store | `079_drop_app_version_config.sql` |

Do not add these back to `SQL_FILES` in `run-all-migrations.js` — the tables they create
are immediately dropped again by the migration named above, which still runs.

Two more files are archived for a different reason — not dropped tables, but files that
were **100% data with no schema in them at all** (role rows, no CREATE/ALTER/DROP). Once
DDL files became schema-only (see `database/seed/README.md`), there was nothing left to
keep in `ddl/` for these two — their row is now in the matching file under `database/seed/`
instead:

| File | What it did |
|---|---|
| `012_add_verifier_role.sql` | Inserted the `Verifier` role row |
| `033_add_superuser_role.sql` | Inserted the `Superuser` role row |
| `068_survey_seed_sundargarh.sql` | Seeded ~190 survey questions for the Sundargarh project (a `DO $$` block staging through a temp table — no persistent schema) |
| `069_survey_seed_sikkim.sql` | Seeded ~90 survey questions for the Sikkim project (same pattern) |
