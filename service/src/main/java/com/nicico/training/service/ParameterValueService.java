package com.nicico.training.service;

import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.model.Parameter;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.repository.ParameterValueDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class ParameterValueService extends BaseService<ParameterValue, Long, ParameterValueDTO.Info, ParameterValueDTO.Create, ParameterValueDTO.Update, ParameterValueDTO.Delete, ParameterValueDAO> {

    @Autowired
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

    //////////////////////////////////////////config//////////////////////////////////////////

    @Transactional
    public List<ParameterValueDTO.Info> editConfigList(ParameterValueDTO.ConfigUpdate[] rq) {
        ParameterValue parameterValue;
        final List<ParameterValue> parameterValues = new ArrayList<>();
        for (ParameterValueDTO.ConfigUpdate config : rq) {
            parameterValue = dao.getOne(config.getId());
            modelMapper.map(config, parameterValue);
            parameterValues.add(parameterValue);
        }
        return modelMapper.map(dao.saveAll(parameterValues), new TypeToken<List<ParameterValueDTO.Info>>() {
        }.getType());
    }

    public Long getId(String code) {
        return dao.findByCode(code).getId();
    }

    public ParameterValue getEntityId(String code) {
        return dao.findByCode(code);
    }

    public ParameterValue getByTitle(String title) {
        return dao.findByTitle(title);
    }

    @Transactional
    public String getParameterValueCodeById (Long id) {
        Optional<ParameterValue> byId = dao.findById(id);
        ParameterValue parameterValue = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return parameterValue.getCode();

    }

    public TotalResponse<ParameterValueDTO> getMessages(String type, String target) {
        List<ParameterValue> list = dao.findMessagesByCode("%"+type+"%","%"+target+"%");
         List<ParameterValueDTO> infos = modelMapper.map(list, new TypeToken<List<ParameterValueDTO.Info>>() {
        }.getType());
             GridResponse grid=new GridResponse<>(infos);
             grid.setTotalRows(infos.size());
             return new TotalResponse<>(grid);
     }
}
