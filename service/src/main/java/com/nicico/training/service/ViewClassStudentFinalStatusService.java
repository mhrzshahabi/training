package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IViewClassCourseFinalStatusService;
import com.nicico.training.iservice.IViewClassStudentFinalStatusService;
import com.nicico.training.repository.ViewClassCourseFinalStatusDAO;
import com.nicico.training.repository.ViewClassStudentFinalStatusDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ViewClassStudentFinalStatusService implements IViewClassStudentFinalStatusService {
    private final ViewClassStudentFinalStatusDAO viewClassStudentFinalStatusDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        if (request.getCriteria() != null && request.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                if (criterion.getFieldName().equals("classScoringMethodCode")) {
                    List<String> scoringValues = new ArrayList<>();
                    for (Object value : criterion.getValue()) {
                        if (value.toString().equals("1")) {
                            scoringValues.add("2");
                            scoringValues.add("3");
                        }
                        if (value.toString().equals("2")) {
                            scoringValues.add("1");
                            scoringValues.add("4");
                        }
                    }
                    criterion.setValue(scoringValues);
                }
            }
        }
        return SearchUtil.search(viewClassStudentFinalStatusDAO, request, converter);
    }


}
