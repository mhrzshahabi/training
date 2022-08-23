package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IViewCalenderSessionsService;
import com.nicico.training.repository.ViewCalenderPrerequisiteDAO;
import com.nicico.training.repository.ViewCalenderSessionsDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class ViewCalenderSessionsService implements IViewCalenderSessionsService {
    private  final ViewCalenderSessionsDAO calenderSessionsDAO;
    @Override
    @Transactional(readOnly = true)
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(calenderSessionsDAO, request, converter);
    }
}
