package com.nicico.training.repository;

import com.nicico.training.model.SynonymPersonnel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface SynonymPersonnelDAO extends JpaRepository<SynonymPersonnel, Long>, JpaSpecificationExecutor<SynonymPersonnel> {


    @Query(value = "SELECT\n" +
            "    * FROM (\n" +
            "SELECT\n" +
            "    mdms_tbl_md_employee.c_id                           AS id,\n" +
            "    mdms_tbl_md_employee.c_em_number                    AS emp_no,\n" +
            "    mdms_tbl_md_employee.c_em_number_10                 AS personnel_no,\n" +
            "    mdms_tbl_md_employee.c_address                      AS address,\n" +
            "    mdms_tbl_md_employee.c_national_code                AS national_code,\n" +
            "    mdms_tbl_md_employee.deleted                        AS deleted,\n" +
            "    mdms_tbl_md_people.c_birth_city         AS birth_place,\n" +
            "    mdms_tbl_md_people.c_birthdate          AS birth_date,\n" +
            "    mdms_tbl_md_people.c_father_name        AS father_name,\n" +
            "    mdms_tbl_md_people.c_first_name         AS first_name,\n" +
            "    mdms_tbl_md_people.c_last_name          AS last_name,\n" +
            "    mdms_tbl_md_people.c_ssn                AS birth_certificate_no,\n" +
            "    mdms_tbl_md_people.c_mobile             AS phone,\n" +
            "    mdms_tbl_md_post.c_title                AS post_title,\n" +
            "    mdms_tbl_md_post.c_code                 AS post_code,\n" +
            "    CASE\n" +
            "        WHEN mdms_tbl_md_people.c_gender = 'MALE'   THEN\n" +
            "            'مرد'\n" +
            "        WHEN mdms_tbl_md_people.c_gender = 'FEMALE' THEN\n" +
            "            'زن'\n" +
            "    END                                                 AS gender_title,\n" +
            "    mdms_tbl_md_employee.c_post_id                      AS f_post_id,\n" +
            "    mdms_tbl_md_employee.c_inc_dep_code                 AS department_code,\n" +
            "    mdms_tbl_md_employee.c_inc_dep_title                AS department_title,\n" +
            "    mdms_tbl_md_employee.c_area_of_study                AS education_field_title,\n" +
            "    mdms_tbl_md_department.c_omor_title     AS ccp_affairs,\n" +
            "    mdms_tbl_md_department.c_moavenat_title AS ccp_assistant,\n" +
            "    mdms_tbl_md_department.c_hoze_title     AS ccp_area,\n" +
            "    mdms_tbl_md_department.c_code           AS ccp_code,\n" +
            "    mdms_tbl_md_department.c_ghesmat_title  AS ccp_section,\n" +
            "    mdms_tbl_md_department.c_vahed_title    AS ccp_unit,\n" +
            "    mdms_tbl_md_department.c_title          AS ccp_title,\n" +
            "    mdms_tbl_md_employee.p_type                         AS p_type,\n" +
            "    mdms_tbl_md_employee.c_dep_id                       AS f_department_id,\n" +
            "    mdms_tbl_md_employee.c_geo_id                       AS f_geo_id,\n" +
            "      mdms_tbl_md_people.c_username           AS c_username,\n" +
            "      mdms_tbl_md_post_grade.c_code           AS post_grade_code,\n" +
            "      mdms_tbl_md_post_grade.c_title          AS post_grade_title,\n" +
            "    mdms_tbl_md_employee.c_emp_date                     AS employment_date,\n" +
            "      mdms_tbl_md_employment_type.c_title     AS employment_type_title,\n" +
            "    mdms_tbl_md_employee.c_work_place_title             AS work_place_title,\n" +
            "    mdms_tbl_md_employee.c_edu_lvl_title                AS education_level_title,\n" +
            "      mdms_tbl_md_job.c_title                 AS job_title,\n" +
            "    CASE\n" +
            "        WHEN mdms_tbl_md_employee.p_type = 'ContractorPersonal' THEN\n" +
            "              mdms_tbl_md_geo_work.c_title\n" +
            "        ELSE\n" +
            "            'شرکت ملي صنايع مس ايران'\n" +
            "    END                                                 AS company_name\n" +
            "FROM  \n" +
            "    mdms_tbl_md_employee\n" +
            "    LEFT JOIN   mdms_tbl_md_people ON mdms_tbl_md_employee.c_people_id =   mdms_tbl_md_people.c_id\n" +
            "    INNER JOIN   mdms_tbl_md_post ON mdms_tbl_md_employee.c_post_id =   mdms_tbl_md_post.c_id\n" +
            "    INNER JOIN   mdms_tbl_md_department ON mdms_tbl_md_employee.c_dep_id =   mdms_tbl_md_department.c_id\n" +
            "    INNER JOIN   mdms_tbl_md_post_grade ON   mdms_tbl_md_post.c_grade_id =   mdms_tbl_md_post_grade.c_id\n" +
            "    LEFT JOIN   mdms_tbl_md_employment_type ON mdms_tbl_md_employee.c_emp_type_code =   mdms_tbl_md_employment_type.\n" +
            "    c_code\n" +
            "    INNER JOIN   mdms_tbl_md_job ON mdms_tbl_md_employee.c_job_code =   mdms_tbl_md_job.c_code\n" +
            "    INNER JOIN   mdms_tbl_md_geo_work ON mdms_tbl_md_employee.c_geo_id =   mdms_tbl_md_geo_work.c_id \n" +
            "    WHERE mdms_tbl_md_employee.deleted = 0\n" +
            "    ORDER BY id DESC\n" +
            "    ) where ROWNUM <= 5 ", nativeQuery = true)
    List<SynonymPersonnel> getData();
    @Query(value = "SELECT\n" +
            "    * FROM (\n" +
            "SELECT\n" +
            "    mdms_tbl_md_employee.c_id                           AS id,\n" +
            "    mdms_tbl_md_employee.c_em_number                    AS emp_no,\n" +
            "    mdms_tbl_md_employee.c_em_number_10                 AS personnel_no,\n" +
            "    mdms_tbl_md_employee.c_address                      AS address,\n" +
            "    mdms_tbl_md_employee.c_national_code                AS national_code,\n" +
            "    mdms_tbl_md_employee.deleted                        AS deleted,\n" +
            "    mdms_tbl_md_people.c_birth_city         AS birth_place,\n" +
            "    mdms_tbl_md_people.c_birthdate          AS birth_date,\n" +
            "    mdms_tbl_md_people.c_father_name        AS father_name,\n" +
            "    mdms_tbl_md_people.c_first_name         AS first_name,\n" +
            "    mdms_tbl_md_people.c_last_name          AS last_name,\n" +
            "    mdms_tbl_md_people.c_ssn                AS birth_certificate_no,\n" +
            "    mdms_tbl_md_people.c_mobile             AS phone,\n" +
            "    mdms_tbl_md_post.c_title                AS post_title,\n" +
            "    mdms_tbl_md_post.c_code                 AS post_code,\n" +
            "    CASE\n" +
            "        WHEN mdms_tbl_md_people.c_gender = 'MALE'   THEN\n" +
            "            'مرد'\n" +
            "        WHEN mdms_tbl_md_people.c_gender = 'FEMALE' THEN\n" +
            "            'زن'\n" +
            "    END                                                 AS gender_title,\n" +
            "    mdms_tbl_md_employee.c_post_id                      AS f_post_id,\n" +
            "    mdms_tbl_md_employee.c_inc_dep_code                 AS department_code,\n" +
            "    mdms_tbl_md_employee.c_inc_dep_title                AS department_title,\n" +
            "    mdms_tbl_md_employee.c_area_of_study                AS education_field_title,\n" +
            "    mdms_tbl_md_department.c_omor_title     AS ccp_affairs,\n" +
            "    mdms_tbl_md_department.c_moavenat_title AS ccp_assistant,\n" +
            "    mdms_tbl_md_department.c_hoze_title     AS ccp_area,\n" +
            "    mdms_tbl_md_department.c_code           AS ccp_code,\n" +
            "    mdms_tbl_md_department.c_ghesmat_title  AS ccp_section,\n" +
            "    mdms_tbl_md_department.c_vahed_title    AS ccp_unit,\n" +
            "    mdms_tbl_md_department.c_title          AS ccp_title,\n" +
            "    mdms_tbl_md_employee.p_type                         AS p_type,\n" +
            "    mdms_tbl_md_employee.c_dep_id                       AS f_department_id,\n" +
            "    mdms_tbl_md_employee.c_geo_id                       AS f_geo_id,\n" +
            "      mdms_tbl_md_people.c_username           AS c_username,\n" +
            "      mdms_tbl_md_post_grade.c_code           AS post_grade_code,\n" +
            "      mdms_tbl_md_post_grade.c_title          AS post_grade_title,\n" +
            "    mdms_tbl_md_employee.c_emp_date                     AS employment_date,\n" +
            "      mdms_tbl_md_employment_type.c_title     AS employment_type_title,\n" +
            "    mdms_tbl_md_employee.c_work_place_title             AS work_place_title,\n" +
            "    mdms_tbl_md_employee.c_edu_lvl_title                AS education_level_title,\n" +
            "      mdms_tbl_md_job.c_title                 AS job_title,\n" +
            "    CASE\n" +
            "        WHEN mdms_tbl_md_employee.p_type = 'ContractorPersonal' THEN\n" +
            "              mdms_tbl_md_geo_work.c_title\n" +
            "        ELSE\n" +
            "            'شرکت ملي صنايع مس ايران'\n" +
            "    END                                                 AS company_name\n" +
            "FROM  \n" +
            "    mdms_tbl_md_employee\n" +
            "    LEFT JOIN   mdms_tbl_md_people ON mdms_tbl_md_employee.c_people_id =   mdms_tbl_md_people.c_id\n" +
            "    INNER JOIN   mdms_tbl_md_post ON mdms_tbl_md_employee.c_post_id =   mdms_tbl_md_post.c_id\n" +
            "    INNER JOIN   mdms_tbl_md_department ON mdms_tbl_md_employee.c_dep_id =   mdms_tbl_md_department.c_id\n" +
            "    INNER JOIN   mdms_tbl_md_post_grade ON   mdms_tbl_md_post.c_grade_id =   mdms_tbl_md_post_grade.c_id\n" +
            "    LEFT JOIN   mdms_tbl_md_employment_type ON mdms_tbl_md_employee.c_emp_type_code =   mdms_tbl_md_employment_type.\n" +
            "    c_code\n" +
            "    INNER JOIN   mdms_tbl_md_job ON mdms_tbl_md_employee.c_job_code =   mdms_tbl_md_job.c_code\n" +
            "    INNER JOIN   mdms_tbl_md_geo_work ON mdms_tbl_md_employee.c_geo_id =   mdms_tbl_md_geo_work.c_id \n" +
            "    WHERE mdms_tbl_md_employee.deleted = 0\n" +
            "    ORDER BY id DESC\n" +
            "    ) where ROWNUM <= 5 ", nativeQuery = true)
    Integer total();

}