-- Function: fn_documentation_files_replace  |  Domain: documentation
-- Replaces a report's whole attachment list with p_files, a JSONB array of
-- { "file_type": "image"|"pdf"|"video", "file_name": "...", "fullpath_url": "..." }
-- in display order. Shared by fn_documentation_create / fn_documentation_update.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_documentation_files_replace(
  p_documentation_id INT,
  p_files            JSONB
)
RETURNS VOID AS $$
BEGIN
  DELETE FROM documentation_files WHERE documentation_id = p_documentation_id;

  INSERT INTO documentation_files (documentation_id, file_type, file_name, fullpath_url, sort_order)
  SELECT p_documentation_id, f->>'file_type', f->>'file_name', f->>'fullpath_url', (o - 1)::INT
  FROM JSONB_ARRAY_ELEMENTS(COALESCE(p_files, '[]'::JSONB)) WITH ORDINALITY AS x(f, o);
END;
$$ LANGUAGE plpgsql;
