-- DDL 077: "Faulty Item Sent To Store" expense purpose — mobile submits a
-- Mode of Dispatch ('Courier' | 'Local Transport') alongside it. The
-- per-mode detail fields (docket_number for Courier; driver_name/
-- driver_number/vehicle_number for Local Transport) already exist from the
-- separate Material Dispatch/Courier purposes (049/050) and are reused here
-- rather than duplicated — only the mode selector itself is new.
SET search_path TO myactivity;

ALTER TABLE expense_tbl
  ADD COLUMN IF NOT EXISTS mode_of_dispatch VARCHAR(50);  -- 'Courier' | 'Local Transport'

-- The purpose row moved to database/seed/077_expense_faulty_item_dispatch.sql
-- — DDL files are schema-only now (see database/seed/README.md).
