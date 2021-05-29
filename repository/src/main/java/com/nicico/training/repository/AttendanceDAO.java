package com.nicico.training.repository;

import com.nicico.training.model.Attendance;
import com.nicico.training.model.ClassSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface AttendanceDAO extends JpaRepository<Attendance, Long>, JpaSpecificationExecutor<Attendance> {

    //    List<Attendance> findAllBySessionId(ArrayList<Long> sessionIds);
    List<Attendance> findBySessionId(Long sessionId);

    Optional<Attendance> findBySessionIdAndStudentId(Long sessionId, Long studentId);

    List<Attendance> findBySessionIdInAndStudentIdAndState(List<Long> sessionIdList, Long studentId, String state);

    boolean existsBySessionId(Long sessionId);

    @Query(value = "SELECT count(*) FROM " +
            " tbl_attendance " +
            " INNER JOIN tbl_student ON tbl_student.id = tbl_attendance.f_student " +
            " INNER JOIN tbl_class_student ON tbl_student.id = tbl_class_student.student_id " +
            " INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session " +
            " AND tbl_session.f_class_id = tbl_class_student.class_id WHERE tbl_attendance.f_session =:sessionId AND tbl_attendance.c_state !=:state And tbl_class_student.PRESENCE_TYPE_ID !=:presence ", nativeQuery = true)
    Integer checkSessionIdAndState(Long sessionId, String state, Long presence);

    @Query(value = " SELECT " +
            "    DISTINCT " +
            "    tbl_attendance.f_session \n " +
            " FROM " +
            "    tbl_attendance " +
            "        INNER JOIN tbl_student ON tbl_student.id = tbl_attendance.f_student " +
            "        INNER JOIN tbl_class_student ON tbl_student.id = tbl_class_student.student_id " +
            "        INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session AND tbl_session.f_class_id = tbl_class_student.class_id " +
            " WHERE " +
            "    tbl_attendance.f_session IN (:sessionIds) AND " +
            "    tbl_attendance.c_state !=:state AND " +
            "    tbl_class_student.PRESENCE_TYPE_ID !=:presence ",
    nativeQuery = true)
    List<Long> checkSessionIdsAndStates(List<Long> sessionIds, String state, Long presence);

    List<Attendance> findBySessionInAndState(List<ClassSession> sessions, String state);

    List<Attendance> findBySessionInAndStudentId(List<ClassSession> sessions, Long studentId);

    List<Attendance> findBySessionIn(Set<ClassSession> sessions);

    Integer deleteAllBySessionId(Long sessionId);

    @Modifying
    @Query(value = "DELETE FROM TBL_ATTENDANCE where f_student=:studentId and f_session in (select id from tbl_session where f_class_id=:classId)",nativeQuery = true)
    void deleteAllByClassIdAndStudentId(Long classId,Long studentId);

    @Modifying
    @Query(value = "DELETE FROM TBL_ATTENDANCE WHERE F_SESSION IN (:sessionIds)",nativeQuery = true)
    Integer deleteAllBySessionId(List<Long> sessionIds);

    Integer deleteAllBySessionIdAndState(Long sessionId, String state);


    @Query(value = "select count(*) from tbl_attendance where c_state<>0 and f_student=:studentId and f_session in (select id from tbl_session where f_class_id=:classId)",
            nativeQuery = true)
    Integer checkAttendanceByStudentIdAndClassId(Long studentId,Long classId);


    @Query(value = "select c_state FROM TBL_ATTENDANCE where f_student=:studentId and f_session in (select id from tbl_session where f_class_id=:classId)",nativeQuery = true)
    List<Long> getAttendanceByClassIdAndStudentId(Long classId,Long studentId);
}