SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_bulk_approve(
    p_trip_ids    INT[],
    p_approver_id INT,
    p_role        VARCHAR,
    p_comment     TEXT DEFAULT 'Bulk approved'
)
RETURNS TABLE(trip_id INT, message TEXT)
AS $$
DECLARE
    v_id INT;
BEGIN
    FOREACH v_id IN ARRAY p_trip_ids LOOP
        BEGIN
            RETURN QUERY SELECT * FROM fn_distance_approval_update(v_id, p_approver_id, p_role, 'Approved', p_comment, NULL);
        EXCEPTION WHEN OTHERS THEN
            RETURN QUERY SELECT v_id, ('ERROR: ' || SQLERRM)::TEXT;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
