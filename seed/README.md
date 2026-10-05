# Seed data

`database/ddl/*.sql` is schema-only — every file there just creates/alters/drops
tables, columns, indexes and constraints. No `.sql` file under `ddl/` contains
an `INSERT`/`DELETE` of business data (or the `schema_versions` bookkeeping
row — that's now recorded by the runner itself, in
`myactivity_backend/src/scripts/run-all-migrations.js`, after each `ddl/`
file succeeds).

Files here hold the actual seed/lookup data that used to live inline in the
matching `ddl/` file — same number and name, so it's easy to trace which
schema migration a given seed file's data originally came from. Run them with:

```
node src/scripts/run-all-seeds.js
```

(from `myactivity_backend/`, same idempotent `ON CONFLICT DO NOTHING` pattern
as the migrations — safe to re-run).

| File | Seeds |
|---|---|
| `004_user_tables.sql` | 2 dummy test users (John Doe / Jane Smith) for local dev login testing |
| `007_roles_table.sql` | The 10 base roles |
| `008_department_and_seeds.sql` | 6 starter department names |
| `012_add_verifier_role.sql` | The `Verifier` role |
| `020_power_meter_category.sql` | `Working` / `Not Working` categories |
| `021_power_meter_receipt_duration.sql` | 6 fixed receipt-duration label rows |
| `023_task_tables.sql` | 11 task categories + ~35 sub-categories |
| `033_add_superuser_role.sql` | The `Superuser` role |
| `068_survey_seed_sundargarh.sql` | ~190 real survey questions for the Sundargarh AI Virtual Classroom project |
| `069_survey_seed_sikkim.sql` | ~90 real survey questions for the Sikkim project |
| `072_survey_section_qtype_normalize.sql` | The 6 fixed `survey_question_type` rows (text/number/boolean/select/photo/decimal) |
| `077_expense_faulty_item_dispatch.sql` | The `Faulty Item Sent To Store` expense purpose row |

**Not here, left in `ddl/` on purpose:** `030_company_module_settings.sql`,
`031_module_settings_unified.sql`, `034_state_module_settings.sql`,
`066_normalize_state_names.sql`, and `074_distance_images_dedupe.sql` each do
a one-time backfill/cleanup that's tied intrinsically to that specific schema
change (e.g. deriving `state` rows from whatever `district` rows already
exist *at that point in migration history*, migrating
`company_module_settings` into the new unified table the same migration just
created, or merging duplicate `distance_images` rows right before adding a
new unique constraint on that column). These aren't static lookup values —
they must run as part of that exact schema step, not as a separate, later,
generic "seed" pass, so moving them here would change their behavior, not
just their location.
