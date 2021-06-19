create PROCEDURE PRC_MERGE_TBL_POST_MDMS AS
BEGIN
    ------------UPDATE-------------------------------------------------------
    MERGE INTO TBL_POST T
    USING (
        SELECT MDMS_POST.C_CODE                 AS MDMS_C_CODE,
               MDMS_POST.C_TITLE_FA             AS MDMS_C_TITLE_FA,
               MDMS_POST.f_job_id               AS MDMS_f_job_id,
               MDMS_POST.f_department_id        AS MDMS_f_department_id,
               MDMS_POST.n_parent_id            AS MDMS_n_parent_id,
               MDMS_POST.c_area                 AS MDMS_c_area,
               MDMS_POST.c_mojtame_title        AS MDMS_c_mojtame_title,
               MDMS_POST.c_assistance           AS MDMS_c_assistance,
               MDMS_POST.c_affairs              AS MDMS_c_affairs,
               MDMS_POST.c_unit                 AS MDMS_c_unit,
               MDMS_POST.c_section              AS MDMS_c_section,
               MDMS_POST.c_cost_center_code     AS MDMS_c_cost_center_code,
               MDMS_POST.c_cost_center_title_fa AS MDMS_c_cost_center_title_fa,
               MDMS_POST.e_enabled              AS MDMS_e_enabled,
               MDMS_POST.e_deleted              AS MDMS_e_deleted,
               MDMS_POST.f_post_grade_id        AS MDMS_f_post_grade_id,
               MDMS_POST.C_PEOPLE_TYPE          AS C_PEOPLE_TYPE,
               TR_POST.C_CODE                   AS TR_C_CODE,
               TR_POST.C_TITLE_FA               AS TR_C_TITLE_FA,
               TR_POST.f_job_id                 AS TR_f_job_id,
               TR_POST.f_department_id          AS TR_f_department_id,
               TR_POST.n_parent_id              AS TR_n_parent_id,
               TR_POST.c_area                   AS TR_c_area,
               TR_POST.c_mojtame_title          AS TR_c_mojtame_title,
               TR_POST.c_assistance             AS TR_c_assistance,
               TR_POST.c_affairs                AS TR_c_affairs,
               TR_POST.c_unit                   AS TR_c_unit,
               TR_POST.c_section                AS TR_c_section,
               TR_POST.c_cost_center_code       AS TR_c_cost_center_code,
               TR_POST.c_cost_center_title_fa   AS TR_c_cost_center_title_fa,
               TR_POST.e_enabled                AS TR_e_enabled,
               TR_POST.e_deleted                AS TR_e_deleted
        FROM (
                 SELECT post.c_code                               AS c_code,
                        nvl(post.c_title, 'null_' || post.c_code) AS c_title_fa,
                        post_grade.id                             AS f_post_grade_id,
                        job_.id                                   AS f_job_id,
                        post.c_people_type                        AS c_people_type,
                        dep.id                                    AS f_department_id,
                        parent_.id                                AS n_parent_id,
                        dep.c_hoze_title                          AS c_area,
                        dep.c_mojtame_title                       AS c_mojtame_title,
                        dep.c_moavenat_title                      AS c_assistance,
                        dep.c_omor_title                          AS c_affairs,
                        dep.c_vahed_title                         AS c_unit,
                        dep.c_ghesmat_title                       AS c_section,
                        dep.c_code                                AS c_cost_center_code,
                        dep.c_title                               AS c_cost_center_title_fa,
                        CASE
                            WHEN post.c_active = 1 THEN
                                NULL
                            WHEN post.c_active = 0 THEN
                                74
                            END                                   AS e_enabled,
                        CASE
                            WHEN post.c_deleted = 1 THEN
                                75
                            WHEN post.c_deleted = 0 THEN
                                NULL
                            END                                   AS e_deleted
                 FROM MDMS_TBL_MD_POST post
                          left join MDMS_tbl_md_department mdms_dep on post.c_dep_id = mdms_dep.c_id
                          left join TBL_DEPARTMENT dep on dep.C_CODE = mdms_dep.c_code
                          left join MDMS_TBL_MD_POST_grade mdms_post_grade
                                    on (post.c_grade_id = mdms_post_grade.c_id)
                          left join TBL_POST_GRADE post_grade
                                    on (post_grade.c_code = mdms_post_grade.c_code and
                                        post_grade.C_PEOPLE_TYPE = mdms_post_grade.C_PEOPLE_TYPE)
                          left join MDMS_TBL_md_job MDMS_POST on MDMS_POST.c_id = post.c_job_id
                          left join TBL_JOB job_ on (job_.c_code = MDMS_POST.c_code and
                                                      job_.C_PEOPLE_TYPE = MDMS_POST.C_PEOPLE_TYPE)
                          left join MDMS_TBL_MD_POST mdms_parent on mdms_parent.c_id = post.n_parent_id
                          left join TBL_POST parent_ on (parent_.c_code = mdms_parent.c_code and
                                                         parent_.C_PEOPLE_TYPE = mdms_parent.C_PEOPLE_TYPE)
             ) MDMS_POST
                 INNER JOIN TBL_POST TR_POST
                            ON (MDMS_POST.C_CODE = TR_POST.C_CODE and MDMS_POST.C_PEOPLE_TYPE = TR_POST.C_PEOPLE_TYPE)
        WHERE TR_POST.c_title_fa <> MDMS_POST.c_title_fa
           OR TR_POST.c_affairs <> MDMS_POST.c_affairs
           OR (TR_POST.c_affairs IS NULL
            AND MDMS_POST.c_affairs IS NOT NULL)
           OR (TR_POST.c_affairs IS NOT NULL
            AND MDMS_POST.c_affairs IS NULL)
           OR TR_POST.c_area <> MDMS_POST.c_area
           OR (TR_POST.c_area IS NULL
            AND MDMS_POST.c_area IS NOT NULL)
           OR (TR_POST.c_area IS NOT NULL
            AND MDMS_POST.c_area IS NULL)
           OR TR_POST.c_mojtame_title <> MDMS_POST.c_mojtame_title
           OR (TR_POST.c_mojtame_title IS NULL
            AND MDMS_POST.c_mojtame_title IS NOT NULL)
           OR (TR_POST.c_mojtame_title IS NOT NULL
            AND MDMS_POST.c_mojtame_title IS NULL)
           OR TR_POST.c_assistance <> MDMS_POST.c_assistance
           OR (TR_POST.c_assistance IS NULL
            AND MDMS_POST.c_assistance IS NOT NULL)
           OR (TR_POST.c_assistance IS NOT NULL
            AND MDMS_POST.c_assistance IS NULL)
           OR TR_POST.c_cost_center_title_fa <> MDMS_POST.c_cost_center_title_fa
           OR (TR_POST.c_cost_center_title_fa IS NULL
            AND MDMS_POST.c_cost_center_title_fa IS NOT NULL)
           OR (TR_POST.c_cost_center_title_fa IS NOT NULL
            AND MDMS_POST.c_cost_center_title_fa IS NULL)
           OR TR_POST.c_cost_center_code <> MDMS_POST.c_cost_center_code
           OR (TR_POST.c_cost_center_code IS NULL
            AND MDMS_POST.c_cost_center_code IS NOT NULL)
           OR (TR_POST.c_cost_center_code IS NOT NULL
            AND MDMS_POST.c_cost_center_code IS NULL)
           OR TR_POST.c_section <> MDMS_POST.c_section
           OR (TR_POST.c_section IS NULL
            AND MDMS_POST.c_section IS NOT NULL)
           OR (TR_POST.c_section IS NOT NULL
            AND MDMS_POST.c_section IS NULL)
           OR TR_POST.c_unit <> MDMS_POST.c_unit
           OR (TR_POST.c_unit IS NULL
            AND MDMS_POST.c_unit IS NOT NULL)
           OR (TR_POST.c_unit IS NOT NULL
            AND MDMS_POST.c_unit IS NULL)
           OR TR_POST.f_job_id <> MDMS_POST.f_job_id
           OR (TR_POST.f_job_id IS NULL
            AND MDMS_POST.f_job_id IS NOT NULL)
           OR (TR_POST.f_job_id IS NOT NULL
            AND MDMS_POST.f_job_id IS NULL)
           OR TR_POST.f_post_grade_id <> MDMS_POST.f_post_grade_id
           OR (TR_POST.f_post_grade_id IS NULL
            AND MDMS_POST.f_post_grade_id IS NOT NULL)
           OR (TR_POST.f_post_grade_id IS NOT NULL
            AND MDMS_POST.f_post_grade_id IS NULL)
           OR TR_POST.e_enabled <> MDMS_POST.e_enabled
           OR TR_POST.e_deleted <> MDMS_POST.e_deleted
           OR (TR_POST.e_enabled IS NULL
            AND MDMS_POST.e_enabled = 0)
           OR (TR_POST.e_deleted IS NULL
            AND MDMS_POST.e_deleted = 1)
           OR (TR_POST.e_enabled IS NOT NULL
            AND MDMS_POST.e_enabled IS NULL)
           OR (TR_POST.e_deleted IS NOT NULL
            AND MDMS_POST.e_deleted IS NULL)
           OR TR_POST.f_department_id <> MDMS_POST.f_department_id
           OR (TR_POST.f_department_id IS NULL
            AND MDMS_POST.f_department_id IS NOT NULL)
           OR (TR_POST.f_department_id IS NOT NULL
            AND MDMS_POST.f_department_id IS NULL)
           OR TR_POST.n_parent_id <> MDMS_POST.n_parent_id
           OR (TR_POST.n_parent_id IS NULL
            AND MDMS_POST.n_parent_id IS NOT NULL)
           OR (TR_POST.n_parent_id IS NOT NULL
            AND MDMS_POST.n_parent_id IS NULL)
    ) CHANGES_
    ON (CHANGES_.MDMS_C_CODE = T.C_CODE and CHANGES_.C_PEOPLE_TYPE = T.C_PEOPLE_TYPE)
    WHEN MATCHED THEN
        UPDATE
        SET t.c_title_fa             = CHANGES_.MDMS_c_title_fa,
            t.c_affairs              = CHANGES_.MDMS_c_affairs,
            t.c_area                 = CHANGES_.MDMS_c_area,
            t.c_mojtame_title        = CHANGES_.MDMS_c_mojtame_title,
            t.c_assistance           = CHANGES_.MDMS_c_assistance,
            t.c_cost_center_code     = CHANGES_.MDMS_c_cost_center_code,
            t.c_cost_center_title_fa = CHANGES_.MDMS_c_cost_center_title_fa,
            t.c_section              = CHANGES_.MDMS_c_section,
            t.c_unit                 = CHANGES_.MDMS_c_unit,
            t.f_job_id               = CHANGES_.MDMS_f_job_id,
            t.f_post_grade_id        = CHANGES_.MDMS_f_post_grade_id,
            t.e_enabled              = CHANGES_.MDMS_e_enabled,
            t.e_deleted              = CHANGES_.MDMS_e_deleted,
            c_last_modified_by       = 'chargoon',
            d_last_modified_date     = sysdate,
            n_version                = t.n_version + 1,
            t.f_department_id        = CHANGES_.MDMS_f_department_id,
            t.n_parent_id            = CHANGES_.MDMS_n_parent_id;
    ------------INSERT-------------------------------------------------------
    MERGE INTO TBL_POST T
    USING (
        SELECT MDMS_POST.*
        FROM (
                 SELECT post.c_code                               AS c_code,
                        nvl(post.c_title, 'null_' || post.c_code) AS c_title_fa,
                        post_grade.id                             AS f_post_grade_id,
                        job_.id                                   AS f_job_id,
                        post.c_people_type                        AS c_people_type,
                        dep.id                                    AS f_department_id,
                        parent_.id                                AS n_parent_id,
                        dep.c_hoze_title                          AS c_area,
                        dep.c_mojtame_title                       AS c_mojtame_title,
                        dep.c_moavenat_title                      AS c_assistance,
                        dep.c_omor_title                          AS c_affairs,
                        dep.c_vahed_title                         AS c_unit,
                        dep.c_ghesmat_title                       AS c_section,
                        dep.c_code                                AS c_cost_center_code,
                        dep.c_title                               AS c_cost_center_title_fa,
                        CASE
                            WHEN post.c_active = 1 THEN
                                NULL
                            WHEN post.c_active = 0 THEN
                                74
                            END                                   AS e_enabled,
                        CASE
                            WHEN post.c_deleted = 1 THEN
                                75
                            WHEN post.c_deleted = 0 THEN
                                NULL
                            END                                   AS e_deleted
                 FROM MDMS_TBL_MD_POST post
                          left join MDMS_tbl_md_department mdms_dep on post.c_dep_id = mdms_dep.c_id
                          left join TBL_DEPARTMENT dep on dep.C_CODE = mdms_dep.c_code
                          left join MDMS_TBL_MD_POST_grade mdms_post_grade
                                    on (post.c_grade_id = mdms_post_grade.c_id)
                          left join TBL_POST_GRADE post_grade
                                    on (post_grade.c_code = mdms_post_grade.c_code and
                                        post_grade.C_PEOPLE_TYPE = mdms_post_grade.C_PEOPLE_TYPE)
                          left join MDMS_TBL_md_job MDMS_POST on MDMS_POST.c_id = post.c_job_id
                          left join TBL_JOB job_ on (job_.c_code = MDMS_POST.c_code and
                                                      job_.C_PEOPLE_TYPE = MDMS_POST.C_PEOPLE_TYPE)
                          left join MDMS_TBL_MD_POST mdms_parent on mdms_parent.c_id = post.n_parent_id
                          left join TBL_POST parent_ on (parent_.c_code = mdms_parent.c_code and
                                                         parent_.C_PEOPLE_TYPE = mdms_parent.C_PEOPLE_TYPE)
             ) MDMS_POST
                 LEFT JOIN TBL_POST TR_POST
                            ON (MDMS_POST.C_CODE = TR_POST.C_CODE and MDMS_POST.C_PEOPLE_TYPE = TR_POST.C_PEOPLE_TYPE)
        WHERE TR_POST.ID IS NULL
    ) NEW_
    ON (NEW_.C_CODE = T.C_CODE AND NEW_.C_PEOPLE_TYPE = T.C_PEOPLE_TYPE)
    WHEN NOT MATCHED THEN
        INSERT (id, c_created_by, d_created_date, e_enabled, e_deleted, n_version, c_code, c_title_fa, c_affairs,
                c_area, c_mojtame_title, c_assistance, c_cost_center_title_fa, c_cost_center_code, c_section, c_unit,
                f_job_id, f_post_grade_id, c_people_type, f_department_id, n_parent_id)
        VALUES (SEQ_POST_ID.nextval, 'chargoon', sysdate, NEW_.e_enabled, NEW_.e_deleted, 0, NEW_.c_code,
                NEW_.c_title_fa, NEW_.c_affairs, NEW_.c_area, NEW_.c_mojtame_title, NEW_.c_assistance, NEW_.c_cost_center_title_fa,
                NEW_.c_cost_center_code, NEW_.c_section, NEW_.c_unit,
                NEW_.f_job_id, NEW_.f_post_grade_id, NEW_.c_people_type, NEW_.f_department_id, NEW_.n_parent_id);
END;
/

