SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_gps_bulk_create(p_points JSONB)
RETURNS TABLE(synced_count INT)
LANGUAGE plpgsql
AS $$
DECLARE
  v_count INT;
BEGIN
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
  RETURN QUERY SELECT v_count;
END;
$$;
