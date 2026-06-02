-- Function: fn_pm_answer_save  |  Domain: preventive_maintenance
-- Inserts or updates a single answer for a PM session question.
-- Returns the full upserted row.
SET search_path TO myactivity;

CREATE OR REPLACE FUNCTION fn_pm_answer_save(
    p_pm_id       INT,
    p_question_id INT,
    p_q_id        VARCHAR,
    p_answer      VARCHAR,
    p_photo_path  VARCHAR DEFAULT NULL
)
RETURNS SETOF pm_answer AS $$
BEGIN
    RETURN QUERY
    INSERT INTO pm_answer (
        pm_id,
        question_id,
        q_id,
        answer,
        photo_path,
        created_at,
        updated_at
    )
    VALUES (
        p_pm_id,
        p_question_id,
        p_q_id,
        p_answer,
        p_photo_path,
        NOW(),
        NOW()
    )
    ON CONFLICT (pm_id, question_id) DO UPDATE
        SET answer      = EXCLUDED.answer,
            photo_path  = EXCLUDED.photo_path,
            updated_at  = NOW()
    RETURNING *;
END;
$$ LANGUAGE plpgsql;
