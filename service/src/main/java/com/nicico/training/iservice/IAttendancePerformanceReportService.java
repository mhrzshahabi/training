package com.nicico.training.iservice;

import com.nicico.training.dto.AttendancePerformanceReportDTO;

import java.util.List;

public interface IAttendancePerformanceReportService {
    public List<AttendancePerformanceReportDTO> attendancePerformanceList(String reportParameter);
}
