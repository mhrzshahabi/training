package com.nicico.training.iservice;

import com.nicico.training.dto.AnnualStatisticalReportDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IAnnualStatisticalReport {

    List<AnnualStatisticalReportDTO.Info> list(Long termId, String year, String hozeh, Long institute, String moavenat, String omor, String vahed, String ghesmat, Long categoryId, String startDate, String enddate, String startDate2, String enddate2);
}
