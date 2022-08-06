package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IViewEffectiveCoursesReportService;
import com.nicico.training.repository.ViewEffectiveCourseReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ViewEffectiveCoursesReportService implements IViewEffectiveCoursesReportService {
    private final ViewEffectiveCourseReportDAO effectiveCourseReportDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(effectiveCourseReportDAO, request, converter);
    }


}
