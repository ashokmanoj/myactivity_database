SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_gps_bulk_create(p_points JSONB)
RETURNS TABLE(synced_count INT)
LANGUAGE plpgsql
AS $$
DECLARE
  v_count INT;
BEGIN
  -- ── 1. Insert GPS points ────────────────────────────────────────────────────
  -- Deduplicate on uuid within the batch (keep first occurrence by array order),
  -- then skip rows whose uuid already exists in the table (idempotent retries).
  INSERT INTO gps_location (uuid, trip_id, user_id, latitude, longitude, altitude, timestamp)
  SELECT
    NULLIF(pt->>'uuid',     '')::VARCHAR(100),
    (pt->>'tripId')::INT,
    NULLIF(pt->>'userId',   '')::INT,
    (pt->>'latitude')::NUMERIC(10,7),
    (pt->>'longitude')::NUMERIC(10,7),
    NULLIF(pt->>'altitude', '')::NUMERIC(8,2),
    (pt->>'timestamp')::BIGINT
  FROM (
    SELECT
      pt,
      NULLIF(pt->>'uuid', '') AS p_uuid,
      ROW_NUMBER() OVER (
        PARTITION BY NULLIF(pt->>'uuid', '')
        ORDER BY ordinality
      ) AS rn
    FROM jsonb_array_elements(p_points) WITH ORDINALITY AS t(pt, ordinality)
  ) ranked
  WHERE p_uuid IS NULL OR rn = 1
  ON CONFLICT (uuid) DO NOTHING;

  GET DIAGNOSTICS v_count = ROW_COUNT;

  -- ── 2. Recalculate distance for ended trips ─────────────────────────────────
  -- GPS batch uploads often arrive after the trip has already been ended, so
  -- fn_distance_sync may have computed total_distance from an incomplete set of
  -- points. Re-sum all GPS points for any ended trip touched by this batch.
  WITH affected AS (
    SELECT DISTINCT (pt->>'tripId')::INT AS trip_id
    FROM jsonb_array_elements(p_points) AS pt
    WHERE pt->>'tripId' IS NOT NULL
  ),
  recalc AS (
    SELECT
      g.trip_id,
      COALESCE(
        SUM(
          6371000 * 2 * ASIN(SQRT(
            POWER(SIN(RADIANS((b_lat - a_lat) / 2.0)), 2) +
            COS(RADIANS(a_lat)) * COS(RADIANS(b_lat)) *
            POWER(SIN(RADIANS((b_lon - a_lon) / 2.0)), 2)
          ))
        )::INT,
      0) AS new_distance
    FROM (
      SELECT
        trip_id,
        latitude::FLOAT                                                       AS a_lat,
        longitude::FLOAT                                                      AS a_lon,
        LEAD(latitude::FLOAT)  OVER (PARTITION BY trip_id ORDER BY timestamp) AS b_lat,
        LEAD(longitude::FLOAT) OVER (PARTITION BY trip_id ORDER BY timestamp) AS b_lon
      FROM gps_location
      WHERE trip_id IN (SELECT trip_id FROM affected)
    ) g
    WHERE b_lat IS NOT NULL
    GROUP BY g.trip_id
  )
  UPDATE distance_tracking dt
  SET
    total_distance  = r.new_distance,
    required_amount = ROUND((r.new_distance / 1000.0) * dt.rate_per_km, 2),
    -- Only reset approved_amount if no approver has acted yet; once any role
    -- approves or rejects, their decision stands and must not be overwritten.
    approved_amount = CASE
      WHEN dt.verifier_status = 'Pending'
       AND dt.rm_status       = 'Pending'
       AND dt.ta_status       = 'Pending'
      THEN ROUND((r.new_distance / 1000.0) * dt.rate_per_km, 2)
      ELSE dt.approved_amount
    END
  FROM recalc r
  WHERE dt.id                      = r.trip_id
    AND dt.end_distance_timestamp  IS NOT NULL;  -- only ended trips need correcting

  RETURN QUERY SELECT v_count;
END;
$$;
