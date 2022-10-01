package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IClassesReactiveAssessmentHasNotReachedQuorumService;
import com.nicico.training.repository.ClassesReactiveAssessmentHasNotReachedQuorumDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ClassesReactiveAssessmentHasNotReachedQuorumService implements IClassesReactiveAssessmentHasNotReachedQuorumService {
    private final ClassesReactiveAssessmentHasNotReachedQuorumDAO hasNotReachedQuorumDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(hasNotReachedQuorumDAO, request, converter);
    }

}
