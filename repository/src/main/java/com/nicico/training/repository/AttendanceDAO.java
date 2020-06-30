package com.nicico.training.repository;

import com.nicico.training.model.Attendance;
import com.nicico.training.model.ClassSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface AttendanceDAO extends JpaRepository<Attendance, Long>, JpaSpecificationExecutor<Attendance> {

    //    List<Attendance> findAllBySessionId(ArrayList<Long> sessionIds);
    List<Attendance> findBySessionId(Long sessionId);

    List<Attendance> findBySessionIdAndStudentId(Long sessionId, Long studentId);

    List<Attendance> findBySessionIdInAndStudentIdAndState(List<Long> sessionIdList, Long studentId, String state);

    boolean existsBySessionId(Long sessionId);

    @Transactional
    @Query(value = "SELECT count(*) FROM " +
            " tbl_attendance " +
            " INNER JOIN tbl_student ON tbl_student.id = tbl_attendance.f_student " +
            " INNER JOIN tbl_class_student ON tbl_student.id = tbl_class_student.student_id " +
            " INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session " +
            " AND tbl_session.f_class_id = tbl_class_student.class_id WHERE tbl_attendance.f_session =:sessionId AND tbl_attendance.c_state !=:state And tbl_class_student.PRESENCE_TYPE_ID !=:presence ", nativeQuery = true)
    Integer checkSessionIdAndState(Long sessionId, String state, Long presence);

    List<Attendance> findBySessionInAndState(List<ClassSession> sessions, String state);

    List<Attendance> findBySessionInAndStudentId(List<ClassSession> sessions, Long studentId);

    Integer deleteAllBySessionId(Long sessionId);

    Integer deleteAllBySessionIdAndState(Long sessionId, String state);
}