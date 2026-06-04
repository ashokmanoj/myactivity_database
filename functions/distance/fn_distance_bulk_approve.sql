SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_distance_bulk_approve(
    p_trip_ids    INT[],
    p_approver_id INT,
    p_role        VARCHAR,
    p_comment     TEXT DEFAULT 'Bulk approved'
)
RETURNS TABLE(trip_id INT, approved_amount NUMERIC, message TEXT)
AS $$
DECLARE
    v_id INT;
BEGIN
    FOREACH v_id IN ARRAY p_trip_ids LOOP
        BEGIN
            RETURN QUERY
                SELECT r.trip_id, r.approved_amount, r.message
                FROM fn_distance_approval_update(v_id, p_approver_id, p_role, 'Approved', p_comment, NULL) r;
        EXCEPTION WHEN OTHERS THEN
            RETURN QUERY SELECT v_id, NULL::NUMERIC, ('ERROR: ' || SQLERRM)::TEXT;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
