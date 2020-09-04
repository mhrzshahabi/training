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
            "        (CASE WHEN :courseId = -1 OR na.course_id =:courseId THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelNationalCode IS NULL THEN 1 WHEN na.PERSONNEL_NATIONAL_CODE =:personnelNationalCode THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelPostGradeId = -1 OR na.PERSONNEL_POST_GRADE_ID =:personnelPostGradeId THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCompanyName IS NULL THEN 1 WHEN na.PERSONNEL_COMPANY_NAME =:personnelCompanyName THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCppArea IS NULL THEN 1 WHEN na.PERSONNEL_CPP_AREA =:personnelCppArea THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCcpAssistantCode IS NULL THEN 1 WHEN na.PERSONNEL_CPP_ASSISTANT =:personnelCcpAssistantCode THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCcpUnit IS NULL THEN 1 WHEN na.PERSONNEL_CPP_UNIT =:personnelCcpUnit THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCppAffairs IS NULL THEN 1 WHEN na.PERSONNEL_CPP_AFFAIRS =:personnelCppAffairs THEN 1 END) IS NOT NULL " +
            "        AND (CASE WHEN :personnelCppTitle IS NULL THEN 1 WHEN na.PERSONNEL_CPP_TITLE =:personnelCppTitle THEN 1 END) IS NOT NULL " +
            "GROUP BY " +
            "    na.course_id, " +
            "    na.course_code, " +
            "    na.course_title_fa", nativeQuery = true)
    List<List<?>> getPersonnelCountByPriority(Long courseId,
                                              String personnelNationalCode,
                                              Long personnelPostGradeId,
                                              String personnelCompanyName,
                                              String personnelCppArea,
                                              String personnelCcpAssistantCode,
                                              String personnelCcpUnit,
                                              String personnelCppAffairs,
                                              String personnelCppTitle);

}
