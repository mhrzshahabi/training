package com.nicico.training.service;

import com.nicico.training.iservice.IAttendanceAuditService;
import com.nicico.training.model.AttendanceAudit;
import com.nicico.training.repository.AttendanceAuditDao;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AttendanceAuditService implements IAttendanceAuditService {
    private final AttendanceAuditDao attendanceAuditDao;

    @Override
    public List<AttendanceAudit> getChangeList(List<Long> attendanceIds, String sessionTime) {
        return attendanceAuditDao.findByAttendanceId(attendanceIds,sessionTime);
    }
}
