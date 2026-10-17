-- Function: fn_visit_end  |  Domain: visit
-- Closes out an open visit — records the departure photo + timestamp.
-- Idempotent: visit_end_at is set once (COALESCE keeps the first value on a
-- retry), but visit_end_image still updates if a later call brings a photo
-- that an earlier call didn't have (e.g. a malformed multipart body that
-- made the server drop the file but still record the timestamp).
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_visit_end(
    p_id               INT,
    p_visit_end_image  VARCHAR DEFAULT NULL
)
RETURNS SETOF visit_details AS $$
BEGIN
    RETURN QUERY
    UPDATE visit_details
    SET visit_end_image = COALESCE(p_visit_end_image, visit_end_image),
        visit_end_at    = COALESCE(visit_end_at, NOW()),
        updated_at      = NOW()
    WHERE id = p_id
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
