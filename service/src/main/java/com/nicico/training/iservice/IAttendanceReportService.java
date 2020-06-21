package com.nicico.training.iservice;

import com.nicico.training.dto.AttendanceReportDTO;

import java.util.List;

public interface IAttendanceReportService {
    List<AttendanceReportDTO.Info> getAbsentList(String startDate, String endDate,String absentType);
}
