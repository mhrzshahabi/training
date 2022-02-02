package com.nicico.training.repository;

import com.nicico.training.model.PersonnelCoursePassedOrNotPaseedNAReportView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PersonnelCoursePassedOrNotPaseedNAReportViewDAO extends JpaRepository<PersonnelCoursePassedOrNotPaseedNAReportView, Long>, JpaSpecificationExecutor<PersonnelCoursePassedOrNotPaseedNAReportView> {

    @Query(value = "SELECT\n" +
            "    * FROM(\n" +
            "SELECT\n" +
            "        rowNum as id,\n" +
            "\n" +
            " \n" +
            "    na.course_code,\n" +
            "    na.course_title_fa,\n" +
            "    na.personnel_personnel_no,\n" +
            "    na.personnel_cpp_affairs,\n" +
            "    na.personnel_cpp_area,\n" +
            "    na.personnel_cpp_assistant,\n" +
            "    na.personnel_cpp_section,\n" +
            "    na.personnel_cpp_title,\n" +
            "    na.personnel_cpp_unit,\n" +
            "    na.personnel_company_name,\n" +
            "    na.personnel_complex_title,\n" +
            "    na.personnel_education_level_title,\n" +
            "    na.personnel_first_name,\n" +
            "    na.personnel_last_name,\n" +
            "    na.personnel_national_code,\n" +
            "    na.personnel_emp_no,\n" +
            "    na.personnel_post_code,\n" +
            "    na.personnel_post_title,\n" +
            "    CASE\n" +
            "            WHEN passed.class_student_scores_state_id IN (\n" +
            "                400,\n" +
            "                401\n" +
            "            ) THEN 216\n" +
            "            ELSE 399\n" +
            "        END\n" +
            "    AS is_passed\n" +
            "FROM\n" +
            "    view_personnel_course_na_report na\n" +
            "    LEFT JOIN view_student_classstudent_class_term_course passed ON na.personnel_national_code = passed.student_national_code\n" +
            "                                                                    AND na.course_id = passed.course_id\n" +
            "                                                                    AND passed.class_student_scores_state_id IN (\n" +
            "        400,\n" +
            "        401\n" +
            "    )\n" +
            "    ORDER BY\n" +
            "    na.personnel_national_code)\n" +
            "    WHERE is_passed = (:passedOrUnPassed) AND (:query)", nativeQuery = true)
    List<PersonnelCoursePassedOrNotPaseedNAReportView> getPassedOrUnPassed(String query, String passedOrUnPassed);
}
