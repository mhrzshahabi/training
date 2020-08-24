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
    public List<AnnualStatisticalReportDTO.Info> list(Long termId, String year, String hozeh, Long institute, String moavenat, String omor, String vahed, String ghesmat, Long categoryId, String startDate, String enddate, String startDate2, String enddate2) {
        termId = termId == null ? new Long(-1) : termId;
        categoryId = categoryId == null ? new Long(-1) : categoryId;
        institute = institute == null ? new Long(-1) : institute;
        List<AnnualStatisticalReport> AnnualList = annualStatisticalReportDAO.AnnualStatistical(termId,year,hozeh,institute,moavenat,omor,vahed,ghesmat,categoryId,startDate,enddate, startDate2,enddate2);
        return mapper.map(AnnualList, new TypeToken<List<AnnualStatisticalReportDTO.Info>>() {
        }.getType());
    }

}
