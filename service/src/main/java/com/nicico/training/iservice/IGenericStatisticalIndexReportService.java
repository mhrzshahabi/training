package com.nicico.training.iservice;

import com.nicico.training.dto.GenericStatisticalIndexReportDTO;

import java.util.List;

public interface IGenericStatisticalIndexReportService {

    List<GenericStatisticalIndexReportDTO> getQueryResult(String reportName, String fromDate, String toDate);
}
