package com.nicico.training.repository;

import com.nicico.training.model.Attendance;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PreTestScoreReportDAO extends JpaRepository<Attendance, Long>, JpaSpecificationExecutor<Attendance> {

    @Query(value = "SELECT DISTINCT\n" +
            "    tbl_session.c_session_date,\n" +
            "    tbl_student.last_name,\n" +
            "    tbl_student.first_name,\n" +
            "    tbl_class.c_title_class,\n" +
            "tbl_class_student.pre_test_score,\n"+
            "    tbl_class.c_start_date ,\n" +
            "    tbl_class_student.class_id,\n" +
            "    tbl_class.c_end_date,\n" +
            "    tbl_session.c_session_end_hour,\n" +
            "    tbl_session.c_session_start_hour,\n" +
            "    tbl_session.c_session_state\n" +
            "FROM\n" +
            "    tbl_attendance\n" +
            "    INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session\n" +
            "    INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id\n" +
            "    INNER JOIN tbl_class_student ON tbl_class.id = tbl_class_student.class_id\n" +
            "    INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id\n" +
            "WHERE\n" +
            "    tbl_attendance.c_state = '3'\n" +
            "    AND   tbl_class.c_start_date >= :startDate \n" +
            "    AND   tbl_class.c_end_date <= :endDate \n" +"order by  tbl_class.c_title_class, tbl_student.last_name, tbl_student.first_name \n ", nativeQuery = true)
       List<Object> unjustified(@Param("startDate") String startDate, @Param("endDate") String endDate);

    @Query(value = "SELECT\n" +
            "    tbl_class.c_code,\n" +
            "    tbl_class.c_title_class,\n" +
            "    tbl_class_student.pre_test_score,\n" +
            "    tbl_student.first_name,\n" +
            "    tbl_student.last_name,\n" +
            "    tbl_class.c_start_date,\n" +
            "    tbl_class.c_end_date,\n" +
            "     (\n" +
            "    CASE\n" +
            "    WHEN  tbl_student.emp_no IS NULL\n" +
            "    THEN 'ندارد'\n" +
            "    END) as emp_no,\n" +
            "    tbl_student.personnel_no ,\n" +
            "    tbl_student.national_code\n" +
            "  \n" +
            "FROM\n" +
            "    tbl_class\n" +
            "    INNER JOIN tbl_class_student ON tbl_class.id = tbl_class_student.class_id\n" +
            "    INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id\n" +
            "WHERE\n" +
            "    tbl_class_student.pre_test_score >= (\n" +
            "        SELECT\n" +
            "            tbl_parameter_value.c_value\n" +
            "        FROM\n" +
            "            tbl_parameter_value\n" +
            "        WHERE\n" +
            "            tbl_parameter_value.c_code = 'minScorePreTestEB'\n" +
            "    )\n" +
            "    AND   tbl_class.pre_course_test = 1  AND   tbl_class.c_start_date >= :startDate   AND   tbl_class.c_end_date <=  :endDate order by  tbl_class.c_title_class, tbl_student.last_name, tbl_student.first_name \n" +
            " ", nativeQuery = true)
    List<Object> printPreScore(@Param("startDate") String startDate, @Param("endDate") String endDate);
}
