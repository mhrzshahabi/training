package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IViewCoursesPassedPersonnelReportService;
import com.nicico.training.repository.ViewCoursesPassedPersonnelReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;


@RequiredArgsConstructor
@Service
public class ViewCoursesPassedPersonnelReportService implements IViewCoursesPassedPersonnelReportService {
        private final ViewCoursesPassedPersonnelReportDAO viewCoursesPassedPersonnelReportDAO;

        @Transactional(readOnly = true)
        @Override
        public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
            return SearchUtil.search(viewCoursesPassedPersonnelReportDAO, request, converter);
        }
}