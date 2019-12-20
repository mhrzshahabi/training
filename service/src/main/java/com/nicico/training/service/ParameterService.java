package com.nicico.training.service;

import com.nicico.training.dto.ParameterDTO;
import com.nicico.training.model.Parameter;
import com.nicico.training.repository.ParameterDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ParameterService extends BaseService<Parameter, Long, ParameterDTO.Info, ParameterDTO.Create, ParameterDTO.Update, ParameterDTO.Delete, ParameterDAO> {

    ParameterDAO parameterDAO;

    @Autowired
    ParameterService(ParameterDAO parameterDAO) {
        super(new Parameter(), parameterDAO);
    }
}
