package com.nicico.training.repository;

import com.nicico.training.model.AttendanceAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AttendanceAuditDao extends JpaRepository<AttendanceAudit, Long>, JpaSpecificationExecutor<AttendanceAudit> {

    @Query(value = "SELECT\n" +
            "*\n" +
            "FROM\n" +
            "         tbl_attendance_aud\n" +
            "    INNER JOIN tbl_session ON tbl_attendance_aud.f_session = tbl_session.id\n" +
            "WHERE\n" +
            "    tbl_attendance_aud.id IN (:attendanceIds)\n" +
            "    and tbl_session.c_session_start_hour = :time ORDER BY tbl_attendance_aud.id,tbl_attendance_aud.rev DESC", nativeQuery = true)
    List<AttendanceAudit> findByAttendanceId(List<Long> attendanceIds,String time);
}
