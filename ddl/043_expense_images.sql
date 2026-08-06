-- DDL 043: Multiple photos per expense submission
SET search_path TO myactivity;

CREATE TABLE IF NOT EXISTS expense_images (
  id          SERIAL        PRIMARY KEY,
  expense_id  INT           NOT NULL REFERENCES expense_tbl(expense_id) ON DELETE CASCADE,
  image_path  VARCHAR(500)  NOT NULL,
  sort_order  INT           NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_expense_images_expense ON expense_images(expense_id);
