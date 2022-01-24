package com.nicico.training.iservice;

import com.nicico.training.model.AttendanceAudit;

import java.util.List;

public interface IAttendanceAuditService {

    List<AttendanceAudit> getChangeList(List<Long> attendanceIds);
}
