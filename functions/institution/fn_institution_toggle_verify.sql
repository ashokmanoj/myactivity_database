SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_institution_toggle_verify(
    p_institute_id  INT,
    p_user_id       INT
)
RETURNS TABLE(institute_id INT, is_verified SMALLINT, verified_at TIMESTAMPTZ)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current SMALLINT;
BEGIN
    SELECT i.is_verified INTO v_current
    FROM institution i
    WHERE i.institute_id = p_institute_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Institution % not found', p_institute_id;
    END IF;

    UPDATE institution
    SET
        is_verified = CASE WHEN v_current = 1 THEN 0 ELSE 1 END,
        verified_at = CASE WHEN v_current = 1 THEN NULL ELSE NOW() END,
        verified_by = CASE WHEN v_current = 1 THEN NULL ELSE p_user_id END
    WHERE institution.institute_id = p_institute_id;

    RETURN QUERY
    SELECT i.institute_id, i.is_verified, i.verified_at
    FROM institution i
    WHERE i.institute_id = p_institute_id;
END;
$$;
