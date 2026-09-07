-- DDL 060: Two-way chat on Distance trips — lets a message @mention the trip's
-- field executive so it's routed to that executive's own mention inbox
-- (fn_distance_mentions_get), separate from the existing role-to-role forward flow.
SET search_path TO myactivity;

ALTER TABLE distance_messages
  ADD COLUMN IF NOT EXISTS mentioned_user_id INT REFERENCES user_tbl(user_id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_dm_mentioned_user ON distance_messages(mentioned_user_id);

INSERT INTO schema_versions(version, migration_file) VALUES('v1.0.0','060_distance_chat_mentions.sql') ON CONFLICT DO NOTHING;
