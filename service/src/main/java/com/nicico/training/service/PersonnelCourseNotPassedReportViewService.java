package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IPersonnelCourseNotPassedReportViewService;
import com.nicico.training.repository.PersonnelCourseNotPassedReportViewDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class PersonnelCourseNotPassedReportViewService implements IPersonnelCourseNotPassedReportViewService {

    private final PersonnelCourseNotPassedReportViewDAO personnelCourseNotPassedReportViewDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(personnelCourseNotPassedReportViewDAO, request, converter);
    }
}
