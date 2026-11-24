-- Repair Bike/Car trips stored with no state (or a junk one like '1'/'3').
-- fn_distance_sync used to take a trip's state from the user's address state
-- only (curr_state/perm_state), ignoring state_of_posting — so those trips got
-- the 3.00 default rate instead of their state's configured rate.
--
-- For each such trip whose user's posting state has a configured rate:
--   * state is filled in on every trip (display / filters only);
--   * rate_per_km and the amounts are recalculated ONLY while nobody has
--     approved, rejected or paid it — once anyone acted, the amount stands.
-- Safe to re-run: fixed trips have a known state and are skipped.
SET search_path TO myactivity;

WITH fix AS (
    SELECT dt.id,
           r.state       AS new_state,
           r.rate_per_km AS new_rate,
           (dt.verifier_status = 'Pending' AND dt.rm_status = 'Pending'
            AND dt.ta_status = 'Pending' AND dt.payment_status <> 'Paid') AS untouched
    FROM distance_tracking dt
    JOIN LATERAL (
        SELECT NULLIF(TRIM(COALESCE(NULLIF(TRIM(ui.state_of_posting), ''), ui.curr_state, ui.perm_state)), '') AS state
        FROM user_information ui
        WHERE ui.user_id = dt.user_id AND ui.is_active = 1
        LIMIT 1
    ) us ON TRUE
    JOIN distance_state_rate r ON LOWER(r.state) = LOWER(us.state) AND r.is_active = 1
    WHERE dt.vehicle_type IS DISTINCT FROM 'Others'
      AND NOT EXISTS (
          SELECT 1 FROM distance_state_rate k
          WHERE LOWER(k.state) = LOWER(TRIM(COALESCE(dt.state, '')))
      )
)
UPDATE distance_tracking dt SET
    state           = f.new_state,
    rate_per_km     = CASE WHEN f.untouched THEN f.new_rate ELSE dt.rate_per_km END,
    required_amount = CASE WHEN f.untouched AND dt.end_distance_timestamp IS NOT NULL
                           THEN ROUND(COALESCE(dt.total_distance, 0) / 1000.0 * f.new_rate, 2)
                           ELSE dt.required_amount END,
    approved_amount = CASE WHEN f.untouched AND dt.end_distance_timestamp IS NOT NULL
                           THEN ROUND(COALESCE(dt.total_distance, 0) / 1000.0 * f.new_rate, 2)
                           ELSE dt.approved_amount END,
    updated_at      = NOW()
FROM fix f
WHERE dt.id = f.id;
