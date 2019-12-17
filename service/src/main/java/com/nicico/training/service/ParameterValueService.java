package com.nicico.training.service;

import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.repository.ParameterValueDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ParameterValueService extends BaseService<ParameterValue, Long, ParameterValueDTO.Info, ParameterValueDTO.Create, ParameterValueDTO.Update, ParameterValueDTO.Delete, ParameterValueDAO> {

    @Autowired
    ParameterValueService(ParameterValueDAO parameterTypeDAO) {
        super(new ParameterValue(), parameterTypeDAO);
    }
}
