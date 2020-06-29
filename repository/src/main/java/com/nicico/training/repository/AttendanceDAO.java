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
    @Query(value = "SELECT count(*) FROM tbl_attendance where F_SESSION = :sessionId and tbl_attendance.c_state != :state", nativeQuery = true)
    Integer checkSessionIdAndState(Long sessionId, String state);

    List<Attendance> findBySessionInAndState(List<ClassSession> sessions, String state);

    List<Attendance> findBySessionInAndStudentId(List<ClassSession> sessions, Long studentId);

    Integer deleteAllBySessionId(Long sessionId);

    Integer deleteAllBySessionIdAndState(Long sessionId, String state);
}