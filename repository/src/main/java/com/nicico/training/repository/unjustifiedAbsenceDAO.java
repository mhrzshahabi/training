package com.nicico.training.repository;

import com.nicico.training.model.Attendance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
@Repository
public interface unjustifiedAbsenceDAO extends JpaRepository<Attendance, Long>, JpaSpecificationExecutor<Attendance> {
    @Query(value = "SELECT DISTINCT\n" +
            "    tbl_session.c_session_date,\n" +
            "    tbl_student.last_name,\n" +
            "    tbl_student.first_name,\n" +
            "    tbl_class.c_title_class,\n" +
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
            "    AND   tbl_class.c_start_date >='1398/10/03'\n" +
            "    AND   tbl_class.c_end_date <='1398/10/05' \n" +"order by  tbl_class.c_title_class\n ", nativeQuery = true)
    List<Object> unjustified();
//    List<Object> findConflict(@Param("sData") String sData, @Param("eData") String eData);

}
