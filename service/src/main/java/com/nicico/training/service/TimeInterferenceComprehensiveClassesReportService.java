package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.ITimeInterferenceComprehensiveClassesReportService;
import com.nicico.training.repository.TimeInterferenceComprehensiveClassesReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.function.Function;


@Service
@RequiredArgsConstructor
public class TimeInterferenceComprehensiveClassesReportService implements ITimeInterferenceComprehensiveClassesReportService {
    private  final TimeInterferenceComprehensiveClassesReportDAO timeInterferenceDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(timeInterferenceDAO, request, converter);
    }

}
