package com.nicico.training.iservice;

import com.nicico.training.dto.PreTestScoreReportDTO;

import java.util.List;

public interface IPreTestScoreReportService {


    List<PreTestScoreReportDTO.printScoreInfo> print(String startDate, String endDate) throws Exception;
}
