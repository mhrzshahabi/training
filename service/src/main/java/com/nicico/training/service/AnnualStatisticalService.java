package com.nicico.training.service;

import com.google.gson.reflect.TypeToken;
import com.nicico.training.dto.AnnualStatisticalReportDTO;
import com.nicico.training.iservice.IAnnualStatisticalReport;
import com.nicico.training.model.AnnualStatisticalReport;
import com.nicico.training.repository.AnnualStatisticalReportDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AnnualStatisticalService implements IAnnualStatisticalReport {
    private final AnnualStatisticalReportDAO annualStatisticalReportDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public List<AnnualStatisticalReportDTO.Info> list(List<Long> termId, List<String> year, String hozeh, List<Long> institute, String moavenat, String omor, String vahed, String ghesmat, List<Long> categoryId, String startDate, String enddate, String startDate2, String enddate2) {

        int instituteNull =  (institute == null) ? 1 : 0;
        int yearNull = (year == null) ? 1 : 0;
        int termNull = (termId == null) ? 1 : 0;
        int categoryNull = (categoryId== null) ? 1 : 0;
        if (termId == null) {
            termId = new ArrayList<>();
            termId.add(-1L);
        }
        if (year == null) {
            year = new ArrayList<>();
            year.add("");
        }
        if (categoryId == null) {
            categoryId = new ArrayList<>();
            categoryId.add(-1L);
        }
        if (institute == null) {
            institute = new ArrayList<>();
            institute.add(-1L);
        }
        if(hozeh == null ||  StringUtils.hasText(hozeh) || !hozeh.contains("شهربابک"))
        {
            List<AnnualStatisticalReport> AnnualList = annualStatisticalReportDAO.AnnualStatistical(termId,termNull,year,yearNull,
                    hozeh, institute,instituteNull, moavenat, omor, vahed, null, categoryId,categoryNull, startDate, enddate, startDate2, enddate2);
            return mapper.map(AnnualList, new TypeToken<List<AnnualStatisticalReportDTO.Info>>() {
            }.getType());
        }
        else {
            List<AnnualStatisticalReport> AnnualList1 = annualStatisticalReportDAO.AnnualStatisticalReportShahrBabak(termId, termNull, year, yearNull,
                    hozeh, institute, instituteNull, moavenat, omor, vahed, null, startDate, enddate, startDate2, enddate2);
            return mapper.map(AnnualList1, new TypeToken<List<AnnualStatisticalReportDTO.Info>>() {
            }.getType());
        }

    }

}
