package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTrainingNeedAssessmentDTO;
import com.nicico.training.iservice.IViewTrainingNeedAssessmentService;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.ViewTrainingNeedAssessment;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.ViewTrainingNeedAssessmentDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ViewTrainingNeedAssessmentService implements IViewTrainingNeedAssessmentService {
    private final ViewTrainingNeedAssessmentDAO viewTrainingNeedAssessmentDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(viewTrainingNeedAssessmentDAO, request, converter);
    }

}
