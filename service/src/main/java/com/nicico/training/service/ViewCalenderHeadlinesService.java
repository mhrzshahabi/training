package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IViewCalenderHeadlinesService;
import com.nicico.training.repository.ViewCalenderHeadlinesDAO;
import com.nicico.training.repository.ViewCalenderOfMainGoalsDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class ViewCalenderHeadlinesService implements IViewCalenderHeadlinesService {
    private final ViewCalenderHeadlinesDAO viewCalenderHeadlinesDAO;

    @Override
    @Transactional(readOnly = true)
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(viewCalenderHeadlinesDAO, request, converter);
    }
}
