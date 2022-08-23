package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IViewCalenderPrerequisiteService;
import com.nicico.training.repository.ViewCalenderPrerequisiteDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class ViewCalenderPrerequisiteService  implements IViewCalenderPrerequisiteService {
    private  final ViewCalenderPrerequisiteDAO calenderPrerequisiteDAO;
    @Override
    @Transactional(readOnly = true)
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(calenderPrerequisiteDAO, request, converter);
    }
}
