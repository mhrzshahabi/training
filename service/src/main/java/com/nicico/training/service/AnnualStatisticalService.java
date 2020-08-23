package com.nicico.training.service;

import com.google.common.reflect.TypeToken;
import com.nicico.training.dto.AnnualStatisticalReportDTO;
import com.nicico.training.iservice.IAnnualStatisticalReport;
import com.nicico.training.model.AnnualStatisticalReport;
import com.nicico.training.repository.AnnualStatisticalReportDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AnnualStatisticalService implements IAnnualStatisticalReport {
    private final AnnualStatisticalReportDAO annualStatisticalReportDAO;
    private final ModelMapper mapper;
    @Transactional(readOnly = true)
    @Override
    public List<AnnualStatisticalReportDTO.Info> list(Long termId, String year, String hozeh, String moavenat, String omor, String vahed, String ghesmat, Long categoryId, String startDate, String enddate) {
        termId = termId == null ? new Long(-1) : termId;
        categoryId = categoryId == null ? new Long(-1) : categoryId;
        List<AnnualStatisticalReport> AnnualList = annualStatisticalReportDAO.AnnualStatistical(termId,year,hozeh,moavenat,omor,vahed,ghesmat,categoryId,startDate,enddate);
        return mapper.map(AnnualList, new TypeToken<List<AnnualStatisticalReportDTO.Info>>() {
        }.getType());
    }

}
