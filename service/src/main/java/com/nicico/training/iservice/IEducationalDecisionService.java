package com.nicico.training.iservice;

import com.nicico.training.dto.EducationalDecisionDTO;
import com.nicico.training.model.EducationalDecision;
import response.BaseResponse;

import java.util.List;

public interface IEducationalDecisionService {

    EducationalDecisionDTO.Info get(Long id);

    List<EducationalDecision> list(String ref,long header);

    BaseResponse create(EducationalDecision request);

    void delete(Long id);

    List<EducationalDecision> findAllByDateAndRef(String fromDate, String ref);
}
