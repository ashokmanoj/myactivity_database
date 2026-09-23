# Archived DDL files

These files are **not run** by `run-all-migrations.js` and are kept only for historical
reference — they created the old fixed-shape survey system, which was fully replaced by
the dynamic, project-scoped survey system (`067_survey_dynamic_forms.sql` onward) and
dropped for good by `070_drop_legacy_survey_tables.sql`.

| File | What it did |
|---|---|
| `028_survey_forms.sql` | Created the original fixed-shape `survey_submissions`-style tables |
| `029_survey_changes.sql` | Follow-up changes to that fixed-shape system |
| `032_survey_add_vsat_signal_strength.sql` | Added a column to that same old system |

Do not add these back to `SQL_FILES` in `run-all-migrations.js` — the tables they create
are immediately dropped again by `070_drop_legacy_survey_tables.sql`, which still runs.
