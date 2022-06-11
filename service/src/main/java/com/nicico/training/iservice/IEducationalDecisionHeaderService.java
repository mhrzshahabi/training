package com.nicico.training.iservice;

import com.nicico.training.dto.EducationalDecisionHeaderDTO;
import com.nicico.training.model.EducationalDecisionHeader;
import response.BaseResponse;

import java.util.List;

public interface IEducationalDecisionHeaderService {

    EducationalDecisionHeaderDTO.Info get(Long id);

    List<EducationalDecisionHeader> list();

    BaseResponse create(EducationalDecisionHeader request);

    void delete(Long id);



}
