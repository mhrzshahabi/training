package com.nicico.training.iservice;

import com.nicico.training.dto.ClassPerformanceReportDTO;

import java.util.List;

public interface IClassPerformanceReportService {
    public List<ClassPerformanceReportDTO> classPerformanceList(String reportParameter);
}
