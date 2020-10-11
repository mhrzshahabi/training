package com.nicico.training.repository;

import com.nicico.training.model.PersonnelCoursePassedNAReportView;
import com.nicico.training.model.compositeKey.PersonnelCourseKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PersonnelCoursePassedNAReportViewDAO extends JpaRepository<PersonnelCoursePassedNAReportView, PersonnelCourseKey>, JpaSpecificationExecutor<PersonnelCoursePassedNAReportView> {

    @Query(value = "SELECT " +
            "    na.course_id, " +
            "    na.course_code, " +
            "    na.course_title_fa, " +
            "    NVL(SUM(CASE WHEN na.NA_PRIORITY_ID = 111 THEN 1 ELSE 0 END),0) AS total_essential_personnel_count, " +
            "    NVL(SUM(CASE WHEN na.NA_PRIORITY_ID = 111 AND na.IS_PASSED = 399 THEN 1 ELSE 0 END),0) AS not_passed_essential_personnel_count, " +
            "    NVL(SUM(CASE WHEN na.NA_PRIORITY_ID = 112 THEN 1 ELSE 0 END),0) AS total_improving_personnel_count, " +
            "    NVL(SUM(CASE WHEN na.NA_PRIORITY_ID = 112 AND na.IS_PASSED = 399 THEN 1 ELSE 0 END),0) AS not_passed_improving_personnel_count, " +
            "    NVL(SUM(CASE WHEN na.NA_PRIORITY_ID = 113 THEN 1 ELSE 0 END),0) AS total_developmental_personnel_count, " +
            "    NVL(SUM(CASE WHEN na.NA_PRIORITY_ID = 113 AND na.IS_PASSED = 399 THEN 1 ELSE 0 END),0) AS not_passed_developmental_personnel_count " +
            "FROM " +
            "    VIEW_PERSONNEL_COURSE_PASSED_NA_REPORT na " +
            "WHERE " +
            "        (CASE WHEN :isCourseCodeNull = 1 OR na.COURSE_CODE IN (:courseCode) THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :isPersonnelNoNull = 1 OR na.PERSONNEL_PERSONNEL_NO IN (:personnelPersonnelNo) THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :isPostGradeIdNull = 1 OR na.personnel_post_grade_id IN (:postGradeId) THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCompanyName IS NULL THEN 1 WHEN na.PERSONNEL_COMPANY_NAME like :personnelCompanyName THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCcpArea IS NULL THEN 1 WHEN na.PERSONNEL_CPP_AREA like :personnelCcpArea THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCcpAssistant IS NULL THEN 1 WHEN na.PERSONNEL_CPP_ASSISTANT like :personnelCcpAssistant THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCcpSection IS NULL THEN 1 WHEN na.PERSONNEL_CPP_SECTION like :personnelCcpSection THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCcpUnit IS NULL THEN 1 WHEN na.PERSONNEL_CPP_UNIT like :personnelCcpUnit THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCcpAffairs IS NULL THEN 1 WHEN na.PERSONNEL_CPP_AFFAIRS like :personnelCcpAffairs THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCppTitle IS NULL THEN 1 WHEN na.PERSONNEL_CPP_TITLE like :personnelCppTitle THEN 1 END) IS NOT NULL " +
            "GROUP BY " +
            "    na.course_id, " +
            "    na.course_code, " +
            "    na.course_title_fa", nativeQuery = true)
    List<List> getPersonnelCountByPriority(Object[] courseCode,
                                              int isCourseCodeNull,
                                              Object[] personnelPersonnelNo,
                                              int isPersonnelNoNull,
                                              Object[] postGradeId,
                                              int isPostGradeIdNull,
                                              String personnelCompanyName,
                                              String personnelCcpArea,
                                              String personnelCcpAssistant,
                                              String personnelCcpSection,
                                              String personnelCcpUnit,
                                              String personnelCcpAffairs,
                                              String personnelCppTitle);

    @Query(value = "SELECT " +
            "    NVL(SUM(CASE WHEN na.na_priority_id = 111 THEN 1 ELSE 0 END),0) AS count_essential_total, " +
            "    NVL(SUM(CASE WHEN na.na_priority_id = 111 AND na.IS_PASSED = 216 THEN 1 ELSE 0 END),0) AS count_essential_passed, " +
            "    NVL(SUM(CASE WHEN na.na_priority_id = 112 THEN 1 ELSE 0 END),0) AS count_improving_total, " +
            "    NVL(SUM(CASE WHEN na.na_priority_id = 112 AND na.IS_PASSED = 216 THEN 1 ELSE 0 END),0) AS count_improving_passed, " +
            "    NVL(SUM(CASE WHEN na.na_priority_id = 113 THEN 1 ELSE 0 END),0) AS count_developmental_total, " +
            "    NVL(SUM(CASE WHEN na.na_priority_id = 113 AND na.IS_PASSED = 216 THEN 1 ELSE 0 END),0) AS count_developmental_passed " +
            "FROM " +
            "    VIEW_PERSONNEL_COURSE_PASSED_NA_REPORT na " +
            "    LEFT JOIN tbl_department dep ON dep.id = na.personnel_department_id " +
            "    LEFT JOIN tbl_post post ON post.id = na.personnel_post_id " +
            "WHERE " +
            "    (CASE WHEN :courseId IS NULL THEN 1 WHEN na.course_id =:courseId THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCppArea IS NULL THEN 1 WHEN dep.c_hoze_title =:personnelCppArea THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCppAreaCode IS NULL THEN 1 WHEN dep.c_hoze_code =:personnelCppAreaCode THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCcpAssistant IS NULL THEN 1 WHEN dep.c_moavenat_title =:personnelCcpAssistant THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCcpAssistantCode IS NULL THEN 1 WHEN dep.c_moavenat_code =:personnelCcpAssistantCode THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCppAffairs IS NULL THEN 1 WHEN dep.c_omor_title =:personnelCppAffairs THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCppAffairsCode IS NULL THEN 1 WHEN dep.c_omor_code =:personnelCppAffairsCode THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCcpSection IS NULL THEN 1 WHEN dep.c_ghesmat_title =:personnelCcpSection THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCcpSectionCode IS NULL THEN 1 WHEN dep.c_ghesmat_code =:personnelCcpSectionCode THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCcpUnit IS NULL THEN 1 WHEN dep.c_vahed_title =:personnelCcpUnit THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCcpUnitCode IS NULL THEN 1 WHEN dep.c_vahed_code =:personnelCcpUnitCode THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :personnelCompanyName IS NULL THEN 1 WHEN na.PERSONNEL_COMPANY_NAME =:personnelCompanyName THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :eduLevelTitle IS NULL THEN 1 WHEN na.PERSONNEL_EDUCATION_LEVEL_TITLE =:eduLevelTitle THEN 1 END) IS NOT NULL " +
            "    AND (CASE WHEN :jobId = -1 OR post.F_JOB_ID =:jobId THEN 1 END) IS NOT NULL", nativeQuery = true)
    List<List<Integer>> getPersonnelCountByPriority(Long courseId,
                                                    String personnelCppArea,
                                                    String personnelCppAreaCode,
                                                    String personnelCcpAssistant,
                                                    String personnelCcpAssistantCode,
                                                    String personnelCppAffairs,
                                                    String personnelCppAffairsCode,
                                                    String personnelCcpSection,
                                                    String personnelCcpSectionCode,
                                                    String personnelCcpUnit,
                                                    String personnelCcpUnitCode,
                                                    String personnelCompanyName,
                                                    String eduLevelTitle,
                                                    Long jobId);
}