package com.nicico.training.iservice;

import com.nicico.training.dto.GenericStatisticalIndexReportDTO;

import java.util.List;

public interface IGenericStatisticalIndexReportService {

    List<GenericStatisticalIndexReportDTO> getQueryResult(String reportName,
                                                          String fromDate,
                                                          String toDate,
                                                          List<Object> complex,
                                                          int complexNull,
                                                          List<Object> assistant,
                                                          int assistantNull,
                                                          List<Object> affairs,
                                                          int affairsNull);
}
