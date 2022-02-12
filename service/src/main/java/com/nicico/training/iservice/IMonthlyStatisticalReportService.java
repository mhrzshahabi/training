package com.nicico.training.iservice;

import com.nicico.training.dto.MonthlyStatisticalReportDTO;

import java.io.IOException;
import java.util.List;

public interface IMonthlyStatisticalReportService {
    List<MonthlyStatisticalReportDTO> monthlyStatisticalList(String reportParameter) throws IOException;
}
