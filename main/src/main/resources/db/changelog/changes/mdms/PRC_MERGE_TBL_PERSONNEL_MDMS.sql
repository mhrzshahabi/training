create or replace PROCEDURE PRC_MERGE_TBL_PERSONNEL_MDMS AS
BEGIN------------UPDATE-------------------------------------------------------

MERGE INTO TBL_PERSONNEL T
USING (
    SELECT to_char(emp.c_em_number_10) AS personnel_no,
           emp.c_address               AS address,
           emp.c_ssn                   AS birth_certificate_no,
           emp.c_birthdate             AS birth_date,
           emp.c_birth_city            AS birth_place,
           emp.c_inc_dep_code          AS department_code,
           emp.c_inc_dep_title         AS department_title,
           emp.c_edu_lvl_title         AS education_level_title,
           emp.c_area_of_study         AS education_field_title,
           emp.c_emp_date              AS employment_date,
           emp.c_emp_status_id         AS employment_status_id,
           emp.c_father_name           AS father_name,
           emp.c_first_name            AS first_name,
           emp.c_last_name             AS last_name,
           emp.c_national_code         AS national_code,
           to_char(emp.c_em_number)    AS emp_no,
           emp.c_home_phone            AS phone,
           emp.post_code               AS post_code,
           emp.c_job_grade             AS post_grade_code,
           emp.post_title              AS post_title,
           emp.p_type                  AS p_type,
           emp.f_department_id         AS f_department_id,
           emp.f_geo_id                AS f_geo_id,
           emp.f_post_id               AS f_post_id,
           emp.work_place_title        AS work_place_title,
           emp.c_username              AS c_username,
           0                           AS deleted,
           emp.ccp_affairs             AS ccp_affairs,
           emp.ccp_area                AS ccp_area,
           emp.ccp_assistant           AS ccp_assistant,
           emp.marital_status_title    AS marital_status_title,
           emp.gender_title            AS gender_title,
           emp.EMPLOYMENT_STATUS_TITLE AS EMPLOYMENT_STATUS_TITLE,
           emp.EMPLOYMENT_TYPE_TITLE   AS EMPLOYMENT_TYPE_TITLE,
           emp.ccp_code                AS ccp_code,
           emp.ccp_section             AS ccp_section,
           emp.ccp_title               AS ccp_title,
           emp.ccp_unit                AS ccp_unit,
           emp.company_name            AS company_name
    FROM (SELECT emp.*,
                 emp.c_official_post_pure_title AS post_title,
                 CASE
                     WHEN emp.p_type = 'ContractorPersonal' THEN
                         geo.c_title
                     ELSE
                         'شرکت ملي صنايع مس ايران'
                     END                        AS company_name,
                 CASE
                     WHEN emp.c_gender = 'MALE' THEN
                         'مرد'
                     WHEN emp.c_gender = 'FEMALE' THEN
                         'زن'
                     END                        AS gender_title,
                 CASE
                     WHEN emp.c_martial_status = 'SINGLE' THEN
                         'مجرد'
                     WHEN emp.c_martial_status = 'MARRIED' THEN
                         'متاهل'
                     END                        AS marital_status_title,
                 geo.c_title                    AS work_place_title,
                 stat.c_title                   AS EMPLOYMENT_STATUS_TITLE,
                 type.c_title                   AS EMPLOYMENT_TYPE_TITLE,
                 dep.c_omor_title               AS ccp_affairs,
                 dep.c_hoze_title               AS ccp_area,
                 dep.c_moavenat_title           AS ccp_assistant,
                 dep.c_code                     AS ccp_code,
                 dep.c_ghesmat_title            AS ccp_section,
                 dep.c_title                    AS ccp_title,
                 dep.id                         AS f_department_id,
                 geo.id                         AS f_geo_id,
                 post.id                        AS f_post_id,
                 dep.c_vahed_title              AS ccp_unit,
                 post.C_CODE                    AS post_code
                 --emp.p_type                   AS p_type
          FROM (select po.c_username,
                       po.C_BIRTH_CITY,
                       po.C_BIRTHDATE,
                       po.C_FATHER_NAME,
                       po.C_FIRST_NAME,
                       po.C_GENDER,
                       po.C_LAST_NAME,
                       po.C_MARTIAL_STATUS,
                       po.C_NATIONAL_CODE,
                       po.C_SSN,
                       e.C_ID,
                       e.C_EM_NUMBER,
                       e.C_EM_NUMBER_10,
                       e.C_LICENCE,
                       e.C_LICENCE_TITLE,
                       e.C_EDU_LVL_TITLE,
                       e.C_AREA_OF_STUDY,
                       e.C_LICENCE_ID,
                       e.C_FIELD_ID,
                       e.C_DEP_ID,
                       e.C_DEP_CODE,
                       e.C_DEP_TITLE,
                       e.C_INC_DEP_ID,
                       e.C_INC_DEP_TITLE,
                       e.C_INC_DEP_CODE,
                       e.C_JOB_CODE,
                       e.C_OFFICIAL_POST_PURE_TITLE,
                       e.C_JOB_GRADE,
                       e.C_POST_ID,
                       e.C_ADDRESS,
                       e.P_TYPE,
                       e.C_PEOPLE_ID,
                       e.C_HOME_PHONE,
                       e.C_EMP_DATE,
                       e.C_GEO_ID,
                       e.C_EMP_TYPE_ID,
                       e.C_EMP_STATUS_ID,
                       e.C_WORK_TURN_ID,
                       e.C_WORK_EXPERIENCE_YEAR,
                       e.C_WORK_EXPERIENCE_MONTH,
                       e.C_WORK_EXPERIENCE_DAY,
                       e.C_LICENCE_CODE,
                       e.C_FIELD_CODE,
                       e.c_post_code
                FROM (select *
                      from (
                               select e.*,
                                      row_number() over (partition by e.c_people_id
                                          order by c_id desc) as inx
                               from   MDMS_tbl_md_employee e
                           )
                      where inx = 1
                     ) e
                         inner join  MDMS_tbl_md_people po on po.c_id = e.c_people_id
               ) emp
                   LEFT JOIN   MDMS_tbl_md_department mdms_dep ON emp.c_inc_dep_id = mdms_dep.c_id
                   LEFT JOIN tbl_department dep ON (mdms_dep.c_code = dep.c_code)
                   LEFT JOIN   MDMS_tbl_md_geo_work mdms_geo ON emp.c_geo_id = mdms_geo.c_id
                   LEFT JOIN TBL_GEO_WORK geo
                             on (geo.C_CODE = mdms_geo.c_code and geo.C_PEOPLE_TYPE = mdms_geo.C_PEOPLE_TYPE)
                   LEFT JOIN   MDMS_tbl_md_employee_STATUS stat ON emp.c_emp_status_id = stat.c_id
                   LEFT JOIN   MDMS_TBL_MD_EMPLOYMENT_TYPE type ON emp.c_emp_type_id = type.c_id
                   LEFT JOIN   MDMS_TBL_MD_POST mdms_post on mdms_post.c_id = emp.c_post_id
                   LEFT JOIN TBL_POST post
                             on mdms_post.c_code = post.c_code and post.C_PEOPLE_TYPE = mdms_post.C_PEOPLE_TYPE
         ) emp
             INNER JOIN (select * from TBL_PERSONNEL where DELETED = 0 and active = 1) TR_PERS
                        ON (emp.C_NATIONAL_CODE = TR_PERS.NATIONAL_CODE)
    where TR_PERS.personnel_no <> to_char(emp.c_em_number_10)
       OR (TR_PERS.personnel_no IS NULL
        AND to_char(emp.c_em_number_10) IS NOT NULL)
       OR (TR_PERS.personnel_no IS NOT NULL
        AND to_char(emp.c_em_number_10) IS NULL)
       OR TR_PERS.address <> address
       OR (TR_PERS.address IS NULL
        AND address IS NOT NULL)
       OR (TR_PERS.address IS NOT NULL
        AND address IS NULL)
       OR TR_PERS.birth_certificate_no <> birth_certificate_no
       OR (TR_PERS.birth_certificate_no IS NULL
        AND birth_certificate_no IS NOT NULL)
       OR (TR_PERS.birth_certificate_no IS NOT NULL
        AND birth_certificate_no IS NULL)
       OR TR_PERS.birth_date <> birth_date
       OR (TR_PERS.birth_date IS NULL
        AND birth_date IS NOT NULL)
       OR (TR_PERS.birth_date IS NOT NULL
        AND birth_date IS NULL)
       OR TR_PERS.birth_place <> birth_place
       OR (TR_PERS.birth_place IS NULL
        AND birth_place IS NOT NULL)
       OR (TR_PERS.birth_place IS NOT NULL
        AND birth_place IS NULL)
       OR TR_PERS.ccp_affairs <> emp.ccp_affairs
       OR (TR_PERS.ccp_affairs IS NULL
        AND emp.ccp_affairs IS NOT NULL)
       OR (TR_PERS.ccp_affairs IS NOT NULL
        AND emp.ccp_affairs IS NULL)
       OR TR_PERS.ccp_area <> emp.ccp_area
       OR (TR_PERS.ccp_area IS NULL
        AND emp.ccp_area IS NOT NULL)
       OR (TR_PERS.ccp_area IS NOT NULL
        AND emp.ccp_area IS NULL)
       OR TR_PERS.ccp_assistant <> emp.ccp_assistant
       OR (TR_PERS.ccp_assistant IS NULL
        AND emp.ccp_assistant IS NOT NULL)
       OR (TR_PERS.ccp_assistant IS NOT NULL
        AND emp.ccp_assistant IS NULL)
       OR TR_PERS.ccp_code <> emp.ccp_code
       OR (TR_PERS.ccp_code IS NULL
        AND emp.ccp_code IS NOT NULL)
       OR (TR_PERS.ccp_code IS NOT NULL
        AND emp.ccp_code IS NULL)
       OR TR_PERS.ccp_section <> emp.ccp_section
       OR (TR_PERS.ccp_section IS NULL
        AND emp.ccp_section IS NOT NULL)
       OR (TR_PERS.ccp_section IS NOT NULL
        AND emp.ccp_section IS NULL)
       OR TR_PERS.ccp_title <> emp.ccp_title
       OR (TR_PERS.ccp_title IS NULL
        AND emp.ccp_title IS NOT NULL)
       OR (TR_PERS.ccp_title IS NOT NULL
        AND emp.ccp_title IS NULL)
       OR TR_PERS.ccp_unit <> emp.ccp_unit
       OR (TR_PERS.ccp_unit IS NULL
        AND emp.ccp_unit IS NOT NULL)
       OR (TR_PERS.ccp_unit IS NOT NULL
        AND emp.ccp_unit IS NULL)
       OR TR_PERS.company_name <> emp.company_name
       OR (TR_PERS.company_name IS NULL
        AND emp.company_name IS NOT NULL)
       OR (TR_PERS.company_name IS NOT NULL
        AND emp.company_name IS NULL)
       OR TR_PERS.department_code <> department_code
       OR (TR_PERS.department_code IS NULL
        AND department_code IS NOT NULL)
       OR (TR_PERS.department_code IS NOT NULL
        AND department_code IS NULL)
       OR TR_PERS.department_title <> department_title
       OR (TR_PERS.department_title IS NULL
        AND department_title IS NOT NULL)
       OR (TR_PERS.department_title IS NOT NULL
        AND department_title IS NULL)
       OR TR_PERS.education_level_title <> emp.c_edu_lvl_title
       OR (TR_PERS.education_level_title IS NULL
        AND emp.c_edu_lvl_title IS NOT NULL)
       OR (TR_PERS.education_level_title IS NOT NULL
        AND emp.c_edu_lvl_title IS NULL)
       OR TR_PERS.education_field_title <> emp.c_area_of_study
       OR (TR_PERS.education_field_title IS NULL
        AND emp.c_area_of_study IS NOT NULL)
       OR (TR_PERS.education_field_title IS NOT NULL
        AND emp.c_area_of_study IS NULL)
       OR TR_PERS.employment_date <> emp.c_emp_date
       OR (TR_PERS.employment_date IS NULL
        AND emp.c_emp_date IS NOT NULL)
       OR (TR_PERS.employment_date IS NOT NULL
        AND emp.c_emp_date IS NULL)
       OR TR_PERS.employment_status_id <> emp.c_emp_status_id
       OR (TR_PERS.employment_status_id IS NULL
        AND emp.c_emp_status_id IS NOT NULL)
       OR (TR_PERS.employment_status_id IS NOT NULL
        AND emp.c_emp_status_id IS NULL)
       OR TR_PERS.EMPLOYMENT_STATUS_TITLE <> emp.EMPLOYMENT_STATUS_TITLE
       OR (TR_PERS.EMPLOYMENT_STATUS_TITLE IS NULL
        AND emp.EMPLOYMENT_STATUS_TITLE IS NOT NULL)
       OR (TR_PERS.EMPLOYMENT_STATUS_TITLE IS NOT NULL
        AND emp.EMPLOYMENT_STATUS_TITLE IS NULL)
       OR TR_PERS.EMPLOYMENT_TYPE_TITLE <> emp.EMPLOYMENT_TYPE_TITLE
       OR (TR_PERS.EMPLOYMENT_TYPE_TITLE IS NULL
        AND emp.EMPLOYMENT_TYPE_TITLE IS NOT NULL)
       OR (TR_PERS.EMPLOYMENT_TYPE_TITLE IS NOT NULL
        AND emp.EMPLOYMENT_TYPE_TITLE IS NULL)
       OR TR_PERS.father_name <> emp.c_father_name
       OR (TR_PERS.father_name IS NULL
        AND emp.c_father_name IS NOT NULL)
       OR (TR_PERS.father_name IS NOT NULL
        AND emp.c_father_name IS NULL)
       OR TR_PERS.first_name <> emp.c_first_name
       OR (TR_PERS.first_name IS NULL
        AND emp.c_first_name IS NOT NULL)
       OR (TR_PERS.first_name IS NOT NULL
        AND emp.c_first_name IS NULL)
       OR TR_PERS.gender_title <> emp.gender_title
       OR (TR_PERS.gender_title IS NULL
        AND emp.gender_title IS NOT NULL)
       OR (TR_PERS.gender_title IS NOT NULL
        AND emp.gender_title IS NULL)
       OR TR_PERS.last_name <> emp.c_last_name
       OR (TR_PERS.last_name IS NULL
        AND emp.c_last_name IS NOT NULL)
       OR (TR_PERS.last_name IS NOT NULL
        AND emp.c_last_name IS NULL)
       OR TR_PERS.marital_status_title <> emp.marital_status_title
       OR (TR_PERS.marital_status_title IS NULL
        AND emp.marital_status_title IS NOT NULL)
       OR (TR_PERS.marital_status_title IS NOT NULL
        AND emp.marital_status_title IS NULL)
       OR TR_PERS.national_code <> emp.c_national_code
       OR (TR_PERS.national_code IS NULL
        AND emp.c_national_code IS NOT NULL)
       OR (TR_PERS.national_code IS NOT NULL
        AND emp.c_national_code IS NULL)
       OR TR_PERS.emp_no <> to_char(emp.c_em_number)
       OR (TR_PERS.emp_no IS NULL
        AND to_char(emp.c_em_number) IS NOT NULL)
       OR (TR_PERS.emp_no IS NOT NULL
        AND to_char(emp.c_em_number) IS NULL)
       OR TR_PERS.phone <> emp.C_HOME_PHONE
       OR (TR_PERS.phone IS NULL
        AND emp.C_HOME_PHONE IS NOT NULL)
       OR (TR_PERS.phone IS NOT NULL
        AND emp.C_HOME_PHONE IS NULL)
       OR TR_PERS.post_code <> emp.post_code
       OR (TR_PERS.post_code IS NULL
        AND emp.post_code IS NOT NULL)
       OR (TR_PERS.post_code IS NOT NULL
        AND emp.post_code IS NULL)
       OR TR_PERS.post_grade_code <> emp.C_JOB_GRADE
       OR (TR_PERS.post_grade_code IS NULL
        AND emp.C_JOB_GRADE IS NOT NULL)
       OR (TR_PERS.post_grade_code IS NOT NULL
        AND emp.C_JOB_GRADE IS NULL)
       OR TR_PERS.post_title <> emp.post_title
       OR (TR_PERS.post_title IS NULL
        AND emp.post_title IS NOT NULL)
       OR (TR_PERS.post_title IS NOT NULL
        AND emp.post_title IS NULL)
       OR TR_PERS.p_type <> emp.p_type
       OR (TR_PERS.p_type IS NULL
        AND emp.p_type IS NOT NULL)
       OR (TR_PERS.p_type IS NOT NULL
        AND emp.p_type IS NULL)
       OR TR_PERS.f_department_id <> emp.f_department_id
       OR (TR_PERS.f_department_id IS NULL
        AND emp.f_department_id IS NOT NULL)
       OR (TR_PERS.f_department_id IS NOT NULL
        AND emp.f_department_id IS NULL)
       OR TR_PERS.f_geo_id <> emp.f_geo_id
       OR (TR_PERS.f_geo_id IS NULL
        AND emp.f_geo_id IS NOT NULL)
       OR (TR_PERS.f_geo_id IS NOT NULL
        AND emp.f_geo_id IS NULL)
       OR TR_PERS.f_post_id <> emp.f_post_id
       OR (TR_PERS.f_post_id IS NULL
        AND emp.f_post_id IS NOT NULL)
       OR (TR_PERS.f_post_id IS NOT NULL
        AND emp.f_post_id IS NULL)
       OR TR_PERS.deleted <> deleted
       OR (TR_PERS.deleted IS NULL
        AND deleted IS NOT NULL)
       OR (TR_PERS.deleted IS NOT NULL
        AND deleted IS NULL)
       OR TR_PERS.work_place_title <> emp.work_place_title
       OR (TR_PERS.work_place_title IS NULL
        AND emp.work_place_title IS NOT NULL)
       OR (TR_PERS.work_place_title IS NOT NULL
        AND emp.work_place_title IS NULL)
       OR TR_PERS.c_username <> emp.c_username
       OR (TR_PERS.c_username IS NULL
        AND emp.c_username IS NOT NULL)
       OR (TR_PERS.c_username IS NOT NULL
        AND emp.c_username IS NULL)
) CHANGES_
ON (CHANGES_.NATIONAL_CODE = T.NATIONAL_CODE and CHANGES_.deleted = T.DELETED)
WHEN MATCHED THEN
    UPDATE
    SET T.personnel_no            = CHANGES_.personnel_no,
        t.address                 = CHANGES_.address,
        t.birth_certificate_no    = CHANGES_.birth_certificate_no,
        t.birth_date              = CHANGES_.birth_date,
        t.birth_place             = CHANGES_.birth_place,
        t.ccp_affairs             = CHANGES_.ccp_affairs,
        t.ccp_area                = CHANGES_.ccp_area,
        t.ccp_assistant           = CHANGES_.ccp_assistant,
        t.ccp_code                = CHANGES_.ccp_code,
        t.ccp_section             = CHANGES_.ccp_section,
        t.ccp_title               = CHANGES_.ccp_title,
        t.ccp_unit                = CHANGES_.ccp_unit,
        t.company_name            = CHANGES_.company_name,
        t.department_code         = CHANGES_.department_code,
        t.department_title        = CHANGES_.department_title,
        t.education_level_title   = CHANGES_.education_level_title,
        t.education_field_title   = CHANGES_.education_field_title,
        t.employment_date         = CHANGES_.employment_date,
        t.employment_status_id    = CHANGES_.employment_status_id,
        t.EMPLOYMENT_STATUS_TITLE = CHANGES_.EMPLOYMENT_STATUS_TITLE,
        t.EMPLOYMENT_TYPE_TITLE   = CHANGES_.EMPLOYMENT_TYPE_TITLE,
        t.father_name             = CHANGES_.father_name,
        t.first_name              = CHANGES_.first_name,
        t.gender_title            = CHANGES_.gender_title,
        t.last_name               = CHANGES_.last_name,
        t.marital_status_title    = CHANGES_.marital_status_title,
        t.emp_no                  = CHANGES_.emp_no,
        t.phone                   = CHANGES_.phone,
        t.post_code               = CHANGES_.post_code,
        t.post_grade_code         = CHANGES_.post_grade_code,
        t.post_title              = CHANGES_.post_title,
        t.p_type                  = CHANGES_.p_type,
        t.f_department_id         = CHANGES_.f_department_id,
        t.f_geo_id                = CHANGES_.f_geo_id,
        t.f_post_id               = CHANGES_.f_post_id,
        t.work_place_title        = CHANGES_.work_place_title,
        t.c_username              = CHANGES_.c_username;

--------------INSERT-----------------------------------------------------

MERGE INTO TBL_PERSONNEL T
USING (
    SELECT to_char(emp.c_em_number_10)    AS personnel_no,
           emp.c_address                  AS address,
           emp.c_ssn                      AS birth_certificate_no,
           emp.c_birthdate                AS birth_date,
           emp.c_birth_city               AS birth_place,
           emp.ccp_affairs,
           emp.ccp_area,
           emp.ccp_assistant,
           emp.ccp_code,
           emp.ccp_section,
           emp.ccp_title,
           emp.ccp_unit,
           emp.department_code            AS department_code,
           emp.c_inc_dep_title            AS department_title,
           emp.c_edu_lvl_title            AS education_level_title,
           emp.c_area_of_study            AS education_field_title,
           emp.c_emp_date                 AS employment_date,
           emp.c_emp_status_id            AS employment_status_id,
           emp.EMPLOYMENT_STATUS_TITLE,
           emp.EMPLOYMENT_TYPE_TITLE,
           emp.c_father_name              AS father_name,
           emp.c_first_name               AS first_name,
           emp.c_last_name                AS last_name,
           emp.c_national_code            AS national_code,
           to_char(emp.c_em_number)       AS emp_no,
           emp.c_home_phone               AS phone,
           emp.c_post_code                AS post_code,
           emp.c_job_grade                AS post_grade_code,
           emp.c_official_post_pure_title AS post_title,
           emp.p_type                     AS p_type,
           --emp.c_inc_dep_id               AS f_department_id,
           --emp.c_geo_id                   AS f_geo_id,
           --emp.c_post_id                  AS f_post_id,
           emp.work_place_title           AS work_place_title,
           emp.c_username                 AS c_username,
           0                              AS deleted,
           emp.company_name               AS company_name,
           emp.gender_title               AS gender_title,
           emp.marital_status_title       AS marital_status_title,
           emp.f_geo_id                   AS f_geo_id,
           emp.f_department_id            AS f_department_id,
           emp.f_post_id                  AS f_post_id
    FROM (SELECT emp.*,
                 CASE
                     WHEN emp.p_type = 'ContractorPersonal' THEN
                         geo.c_title
                     ELSE
                         'شرکت ملي صنايع مس ايران'
                     END              AS company_name,
                 CASE
                     WHEN emp.c_gender = 'MALE' THEN
                         'مرد'
                     WHEN emp.c_gender = 'FEMALE' THEN
                         'زن'
                     END              AS gender_title,
                 CASE
                     WHEN emp.c_martial_status = 'SINGLE' THEN
                         'مجرد'
                     WHEN emp.c_martial_status = 'MARRIED' THEN
                         'متاهل'
                     END              AS marital_status_title,
                 geo.c_title          AS work_place_title,
                 stat.c_title         AS EMPLOYMENT_STATUS_TITLE,
                 type.c_title         AS EMPLOYMENT_TYPE_TITLE,
                 dep.c_omor_title     AS ccp_affairs,
                 dep.c_hoze_title     AS ccp_area,
                 dep.c_moavenat_title AS ccp_assistant,
                 dep.c_code           AS ccp_code,
                 dep.c_ghesmat_title  AS ccp_section,
                 dep.c_title          AS ccp_title,
                 dep.c_vahed_title    AS ccp_unit,
                 dep.c_code           AS department_code,
                 geo.id               AS f_geo_id,
                 dep.id               AS f_department_id,
                 post.id              As f_post_id
          FROM (select po.c_username,
                       po.C_BIRTH_CITY,
                       po.C_BIRTHDATE,
                       po.C_FATHER_NAME,
                       po.C_FIRST_NAME,
                       po.C_GENDER,
                       po.C_LAST_NAME,
                       po.C_MARTIAL_STATUS,
                       po.C_NATIONAL_CODE,
                       po.C_SSN,
                       e.C_ID,
                       e.C_EM_NUMBER,
                       e.C_EM_NUMBER_10,
                       e.C_LICENCE,
                       e.C_LICENCE_TITLE,
                       e.C_EDU_LVL_TITLE,
                       e.C_AREA_OF_STUDY,
                       e.C_LICENCE_ID,
                       e.C_FIELD_ID,
                       e.C_DEP_ID,
                       e.C_DEP_CODE,
                       e.C_DEP_TITLE,
                       e.C_INC_DEP_ID,
                       e.C_INC_DEP_TITLE,
                       e.C_INC_DEP_CODE,
                       e.C_JOB_CODE,
                       e.C_OFFICIAL_POST_PURE_TITLE,
                       e.C_JOB_GRADE,
                       e.C_POST_ID,
                       e.C_ADDRESS,
                       e.P_TYPE,
                       e.C_PEOPLE_ID,
                       e.C_HOME_PHONE,
                       e.C_EMP_DATE,
                       e.C_GEO_ID,
                       e.C_EMP_TYPE_ID,
                       e.C_EMP_STATUS_ID,
                       e.C_WORK_TURN_ID,
                       e.C_WORK_EXPERIENCE_YEAR,
                       e.C_WORK_EXPERIENCE_MONTH,
                       e.C_WORK_EXPERIENCE_DAY,
                       e.C_LICENCE_CODE,
                       e.C_FIELD_CODE,
                       e.c_post_code
                FROM (select *
                      from (
                               select e.*,
                                      row_number() over (partition by e.c_people_id
                                          order by c_id desc) as inx
                               from   MDMS_tbl_md_employee e)
                      where inx = 1) e
                         inner join   MDMS_tbl_md_people po on po.c_id = e.c_people_id
               ) emp
                   LEFT JOIN   MDMS_tbl_md_department mdms_dep ON emp.c_inc_dep_id = mdms_dep.c_id
                   LEFT JOIN TBL_DEPARTMENT dep on mdms_dep.c_code = dep.C_CODE
                   LEFT JOIN   MDMS_tbl_md_geo_work mdms_geo ON emp.c_geo_id = mdms_geo.c_id
                   LEFT JOIN TBL_GEO_WORK geo
                             on (geo.C_CODE = mdms_geo.c_code and geo.C_PEOPLE_TYPE = mdms_geo.C_PEOPLE_TYPE)
                   LEFT JOIN   MDMS_tbl_md_employee_STATUS stat ON emp.c_emp_status_id = stat.c_id
                   LEFT JOIN   MDMS_TBL_MD_EMPLOYMENT_TYPE type ON emp.c_emp_type_id = type.c_id
                   LEFT JOIN   MDMS_TBL_MD_POST mdms_post on mdms_post.c_id = emp.c_post_id
                   LEFT JOIN TBL_POST post
                             on mdms_post.c_code = post.c_code and post.C_PEOPLE_TYPE = mdms_post.C_PEOPLE_TYPE
         ) emp
             LEFT JOIN (select * from TBL_PERSONNEL where DELETED = 0 and active = 1) TR_PERS
                       ON (emp.C_NATIONAL_CODE = TR_PERS.NATIONAL_CODE)
    where TR_PERS.id IS NULL) NEW_
ON (NEW_.NATIONAL_CODE = T.NATIONAL_CODE)
WHEN NOT MATCHED THEN
    INSERT (id,
            active,
            deleted,
            personnel_no,
            address,
            birth_certificate_no,
            birth_date,
            birth_place,
            ccp_affairs,
            ccp_area,
            ccp_assistant,
            ccp_code,
            ccp_section,
            ccp_title,
            ccp_unit,
            company_name,
            department_code,
            department_title,
            education_level_title,
            education_field_title,
            employment_date,
            employment_status_id,
            EMPLOYMENT_STATUS_TITLE,
            EMPLOYMENT_TYPE_TITLE,
            father_name,
            first_name,
            gender_title,
            last_name,
            marital_status_title,
            national_code,
            emp_no,
            phone,
            post_code,
            post_grade_code,
            post_title,
            p_type,
            f_department_id,
            f_geo_id,
            f_post_id,
            work_place_title,
            c_username)
    VALUES (SEQ_PERSONAL_ID.NEXTVAL,
            1,
            0,
            NEW_.personnel_no,
            NEW_.address,
            NEW_.birth_certificate_no,
            NEW_.birth_date,
            NEW_.birth_place,
            NEW_.ccp_affairs,
            NEW_.ccp_area,
            NEW_.ccp_assistant,
            NEW_.ccp_code,
            NEW_.ccp_section,
            NEW_.ccp_title,
            NEW_.ccp_unit,
            NEW_.company_name,
            NEW_.department_code,
            NEW_.department_title,
            NEW_.education_level_title,
            NEW_.education_field_title,
            NEW_.employment_date,
            NEW_.employment_status_id,
            NEW_.EMPLOYMENT_STATUS_TITLE,
            NEW_.EMPLOYMENT_TYPE_TITLE,
            NEW_.father_name,
            NEW_.first_name,
            NEW_.gender_title,
            NEW_.last_name,
            NEW_.marital_status_title,
            NEW_.national_code,
            NEW_.emp_no,
            NEW_.phone,
            NEW_.post_code,
            NEW_.post_grade_code,
            NEW_.post_title,
            NEW_.p_type,
            NEW_.f_department_id,
            NEW_.f_geo_id,
            NEW_.f_post_id,
            NEW_.work_place_title,
            NEW_.c_username);

----------- UPDATE DELETED PERSONALS ----------------------

UPDATE TBL_PERSONNEL SET DELETED = 1 WHERE ID IN (SELECT PRS_EXIST_TR.ID
                                                  FROM TBL_PERSONNEL PRS_EXIST_TR
                                                           LEFT JOIN   tbl_md_employee_mdms PRS_MDMS ON PRS_MDMS.C_NATIONAL_CODE = PRS_EXIST_TR.NATIONAL_CODE
                                                  WHERE PRS_EXIST_TR.DELETED = 0 AND PRS_MDMS.C_ID IS NULL);




end;
/

