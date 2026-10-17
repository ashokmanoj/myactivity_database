-- Function: fn_visit_create  |  Domain: visit
-- Starts a new institution visit — records the arrival photo + timestamp.
-- Idempotent on uuid (same pattern as fn_distance_start): a mobile retry
-- that resends the same client-generated uuid (e.g. the first request's
-- response was lost to a timeout) returns the row that already exists
-- instead of a unique-violation error.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_visit_create(
    p_uuid              VARCHAR  DEFAULT NULL,
    p_project_id        INT      DEFAULT NULL,
    p_institution_id    INT      DEFAULT NULL,
    p_user_id           INT      DEFAULT NULL,
    p_visit_start_image VARCHAR  DEFAULT NULL
)
RETURNS SETOF visit_details AS $$
BEGIN
    IF p_uuid IS NOT NULL THEN
        RETURN QUERY SELECT * FROM visit_details WHERE uuid = p_uuid;
        IF FOUND THEN RETURN; END IF;
    END IF;

    RETURN QUERY
    INSERT INTO visit_details (
        uuid, project_id, institution_id, user_id,
        visit_start_image, visit_start_at
    ) VALUES (
        p_uuid, p_project_id, p_institution_id, p_user_id,
        p_visit_start_image, NOW()
    )
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
