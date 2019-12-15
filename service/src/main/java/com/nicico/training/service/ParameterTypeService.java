package com.nicico.training.service;

import com.nicico.training.dto.ParameterTypeDTO;
import com.nicico.training.model.ParameterType;
import com.nicico.training.repository.ParameterTypeDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ParameterTypeService extends BaseService<ParameterType, Long, ParameterTypeDTO.Info, ParameterTypeDTO.Create, ParameterTypeDTO.Update, ParameterTypeDTO.Delete, ParameterTypeDAO> {

    @Autowired
    ParameterTypeService(ParameterTypeDAO parameterTypeDAO) {
        super(parameterTypeDAO);
    }
}
