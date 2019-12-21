package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.repository.ParameterValueDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class ParameterValueService extends BaseService<ParameterValue, Long, ParameterValueDTO.Info, ParameterValueDTO.Create, ParameterValueDTO.Update, ParameterValueDTO.Delete, ParameterValueDAO> {

    private ParameterService parameterService;

    @Autowired
    ParameterValueService(ParameterValueDAO parameterValueDAO) {
        super(new ParameterValue(), parameterValueDAO);
    }

    @Transactional
    public ParameterValueDTO.Info checkAndCreate(ParameterValueDTO.Create rq) {
        Long parameterId = rq.getParameterId();
        if (parameterService.isExist(parameterId)) {
            return create(rq);
        }
        throw new TrainingException(TrainingException.ErrorType.ParameterNotFound);
    }
}
