package com.nicico.training.repository;

import com.nicico.training.model.AttendanceAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AttendanceAuditDao extends JpaRepository<AttendanceAudit, Long>, JpaSpecificationExecutor<AttendanceAudit> {

    @Query(value = " SELECT * FROM TBL_ATTENDANCE_AUD WHERE ID = :id " +
            " ORDER BY REV DESC  ", nativeQuery = true)
    List<AttendanceAudit> findByAttendanceId(Long id);

}
