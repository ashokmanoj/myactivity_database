-- Function: fn_te_map_get_all  |  Domain: te_mapping
SET search_path TO myactivity;
CREATE OR REPLACE FUNCTION fn_te_map_get_all(
    p_assigned_by    INT DEFAULT NULL,
    p_project_id     INT DEFAULT NULL,
    p_district_id    INT DEFAULT NULL,
    p_designation_id INT DEFAULT NULL
)
RETURNS TABLE(
    map_id            INT,
    user_id           INT,
    emp_code          VARCHAR,
    full_name         VARCHAR,
    designation_name  VARCHAR,
    institute_id      INT,
    institution_name  VARCHAR,
    institute_code    VARCHAR,
    district_name     VARCHAR,
    block_name        VARCHAR,
    assigned_by       INT,
    assigned_by_name  VARCHAR,
    is_active         SMALLINT,
    created_at        TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        tem.map_id,
        tem.user_id,
        te.emp_code,
        te.full_name,
        dsg.designation_name::VARCHAR,
        tem.institute_id,
        inst.institution_name,
        inst.institute_code,
        dist.district_name::VARCHAR,
        blk.block_name::VARCHAR,
        tem.assigned_by,
        rm.full_name::VARCHAR        AS assigned_by_name,
        tem.is_active,
        tem.created_at
    FROM  tech_exec_institution_map  tem
    JOIN  user_tbl                   te   ON te.user_id        = tem.user_id
    LEFT JOIN user_information       ui   ON ui.user_id        = tem.user_id
    LEFT JOIN designation            dsg  ON dsg.designation_id = ui.designation_id
    JOIN  institution                inst ON inst.institute_id  = tem.institute_id
    LEFT JOIN district               dist ON dist.district_id   = inst.district_id
    LEFT JOIN block                  blk  ON blk.block_id       = inst.block_id
    LEFT JOIN user_tbl               rm   ON rm.user_id         = tem.assigned_by
    WHERE tem.is_active = 1
      AND (p_assigned_by    IS NULL OR tem.assigned_by    = p_assigned_by)
      AND (p_district_id    IS NULL OR inst.district_id   = p_district_id)
      AND (p_designation_id IS NULL OR ui.designation_id  = p_designation_id)
      AND (p_project_id     IS NULL OR inst.institute_id IN (
              SELECT ipm.institute_id
              FROM   institution_project_map ipm
              WHERE  ipm.project_id = p_project_id AND ipm.is_active = 1
          ))
    ORDER BY tem.created_at DESC;
END;
$$ LANGUAGE plpgsql;
