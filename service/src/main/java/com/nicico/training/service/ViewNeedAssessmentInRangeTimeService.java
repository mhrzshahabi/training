package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;

import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import com.nicico.training.repository.ViewNeedAssessmentInRangeTimeDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ViewNeedAssessmentInRangeTimeService implements IViewNeedAssessmentInRangeTimeService {
    private final ViewNeedAssessmentInRangeTimeDAO viewNeedAssessmentInRangeTimeDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(viewNeedAssessmentInRangeTimeDAO, request, converter);
    }

}
