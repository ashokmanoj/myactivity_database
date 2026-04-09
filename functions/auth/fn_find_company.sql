-- ============================================================================
-- Function: fn_find_company
-- Description: Finds an active company by name (case-insensitive lookup)
-- Parameters: p_company_name VARCHAR - the company name to search for
-- Returns: Matching active company record
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_find_company(p_company_name VARCHAR)
RETURNS TABLE(
    company_id   INT,
    company_name VARCHAR,
    email        VARCHAR,
    website      VARCHAR,
    address      VARCHAR,
    state        VARCHAR,
    country      VARCHAR,
    is_active    SMALLINT,
    created_at   TIMESTAMPTZ,
    updated_at   TIMESTAMPTZ
)
AS $$
BEGIN
    RETURN QUERY
    SELECT c.*
    FROM company c
    WHERE LOWER(c.company_name) = LOWER(p_company_name)
      AND c.is_active = 1;
END;
$$ LANGUAGE plpgsql;