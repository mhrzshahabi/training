package com.nicico.training.iservice;

import com.nicico.training.dto.MonthlyStatisticalReportDTO;

import java.util.List;

public interface IMonthlyStatisticalReportService {
    public List<MonthlyStatisticalReportDTO> monthlyStatisticalList(String reportParameter);
}
