package com.nicico.training.service;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalUnitDTO;
import com.nicico.training.iservice.IEvaluation;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EvaluationService implements IEvaluation {

    @Override
    public SearchDTO.SearchRs<OperationalUnitDTO.Info> search(SearchDTO.SearchRq request) {
        return null;
    }

}
