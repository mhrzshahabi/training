package com.nicico.training.iservice;

import com.nicico.training.dto.AttendanceReportDTO;

import java.util.List;

public interface IAttendanceReportService {
    List<AttendanceReportDTO.Info> getAttendanceList(String startDate, String endDate);
}
