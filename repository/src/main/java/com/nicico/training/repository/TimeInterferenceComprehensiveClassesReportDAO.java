package com.nicico.training.repository;

import com.nicico.training.model.TimeInterferenceComprehensiveClassesView;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TimeInterferenceComprehensiveClassesReportDAO extends JpaRepository<TimeInterferenceComprehensiveClassesView, Long>, JpaSpecificationExecutor<TimeInterferenceComprehensiveClassesView> {

    @Query(value = " SELECT\n" +
            "    res.count_TimeInterference                              AS count_TimeInterference ,\n" +
            "    tbl_student.first_name || ' ' || tbl_student.last_name  AS studentFullName,\n" +
            "    res.national_code1                                      AS nationalCode,\n" +
            "    tbl_student.emp_no                                      AS studentWorkCode,\n" +
            "    tbl_student.ccp_affairs                                 AS studentAffairs,\n" +
            "    tbl_class.c_title_class                                 AS concurrentCourses,\n" +
            "    tbl_class.c_code                                        AS classCode,\n" +
            "    tbl_class_student.c_created_by                          AS addingUser,\n" +
            "    tbl_class_student.c_last_modified_by                    AS lastModifiedBy,\n" +
            "    res.c_session_date1                                     AS sessionDate,\n" +
            "    res.c_session_start_hour1                               AS sessionStartHour,\n" +
            "    res.c_session_end_hour1                                 AS sessionEndHour,\n" +
            "   \n" +
            "    res.session_id                                          AS session_id,\n" +
            "    tbl_class_student.student_id                            AS student_id ,\n" +
            "    tbl_class_student.d_created_date                        AS class_student_d_created_date,\n" +
            "    tbl_class_student.d_last_modified_date                  AS class_student_d_last_modified_date\n" +
            "\n" +
            "FROM\n" +
            "         (\n" +
            "        SELECT\n" +
            "            COUNT(*)\n" +
            "            OVER(PARTITION BY national_code, c_session_end_hour, c_session_start_hour) AS count_TimeInterference,\n" +
            "            national_code                                                              AS national_code1,\n" +
            "            c_session_end_hour                                                         AS c_session_end_hour1,\n" +
            "            c_session_start_hour                                                       AS c_session_start_hour1,\n" +
            "            c_session_date                                                             AS c_session_date1,\n" +
            "            session_id,\n" +
            "            student_id\n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    tbl_session.c_session_date,\n" +
            "                    tbl_session.c_session_start_hour,\n" +
            "                    tbl_session.c_session_end_hour,\n" +
            "                   tbl_student.national_code,\n" +
            "                   tbl_student.id  AS student_id ,\n" +
            "                    tbl_session.id   AS session_id    \n" +
            "                FROM\n" +
            "                         tbl_session\n" +
            "                    INNER JOIN tbl_class_student ON tbl_session.f_class_id = tbl_class_student.class_id\n" +
            "                    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "               where 1=1\n" +
            "                  AND  tbl_session.c_session_date >= :startDate  \n" +
            "                  AND  tbl_session.c_session_date <= :endDate \n" +
            "            )\n" +
            "        GROUP BY\n" +
            "            national_code,\n" +
            "            c_session_end_hour,\n" +
            "            c_session_start_hour,\n" +
            "            c_session_date,\n" +
            "            session_id,\n" +
            "            student_id\n" +
            "    ) res\n" +
            "    INNER JOIN tbl_session\n" +
            "            ON res.session_id =tbl_session.id\n" +
            "    INNER JOIN tbl_class \n" +
            "            ON tbl_session.f_class_id =tbl_class.id\n" +
            "    INNER JOIN tbl_student \n" +
            "            ON res.student_id = tbl_student.id\n" +
            "    INNER JOIN tbl_class_student\n" +
            "            ON tbl_session.f_class_id = tbl_class_student.class_id\n" +
            "            AND res.student_id = tbl_class_student.student_id\n" +
            "WHERE\n" +
            "      res.count_TimeInterference > 1" , nativeQuery = true)
    List<Object> list(@Param("startDate") String startDate, @Param("endDate") String endDate);
}
