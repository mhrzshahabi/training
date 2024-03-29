package com.nicico.training.service;

import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IParameterValueService;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.repository.ParameterValueDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class ParameterValueService extends BaseService<ParameterValue, Long, ParameterValueDTO.Info, ParameterValueDTO.Create, ParameterValueDTO.Update, ParameterValueDTO.Delete, ParameterValueDAO> implements IParameterValueService {

    @Autowired
    private ParameterService parameterService;

    @Autowired
    ParameterValueService(ParameterValueDAO parameterValueDAO) {
        super(new ParameterValue(), parameterValueDAO);
    }

    @Transactional(readOnly = true)
    @Override
    public ParameterValueDTO.TupleInfo getInfo(Long id) {

        final Optional<ParameterValue> parameterValue = dao.findById(id);
        final ParameterValue parameterValue1 = parameterValue.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ParameterNotFound));

        return modelMapper.map(parameterValue1, ParameterValueDTO.TupleInfo.class);
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
            parameterValue = dao.getById(config.getId());
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
    public String getParameterValueCodeById(Long id) {
        Optional<ParameterValue> byId = dao.findById(id);
        ParameterValue parameterValue = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return parameterValue.getCode();

    }

    @Transactional
    public String getParameterTitleCodeById(Long id) {
        Optional<ParameterValue> byId = dao.findById(id);
        ParameterValue parameterValue = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return parameterValue.getTitle();

    }

    public TotalResponse<ParameterValueDTO> getMessages(String type, String target) {
        List<ParameterValue> list = dao.findMessagesByCode("%" + type + "%", "%" + target + "%");
        List<ParameterValueDTO> infos = modelMapper.map(list, new TypeToken<List<ParameterValueDTO.Info>>() {
        }.getType());
        GridResponse grid = new GridResponse<>(infos);
        grid.setTotalRows(infos.size());
        return new TotalResponse<>(grid);
    }

    public ParameterValue getIdByDescription(String message) {
        return dao.findFirstByDescription(message);
    }

    public void editParameterValue(String value, String title, String des, String code, Long id) {
        ParameterValue parameterValue = dao.findFirstById(id);
        parameterValue.setCode(code);
        parameterValue.setDescription(des);
        parameterValue.setValue(value);
        parameterValue.setTitle(title);
        dao.save(parameterValue);
    }

    public void editDescription(Long id) {
        ParameterValue parameterValue = dao.findFirstById(id);
        parameterValue.setDescription(parameterValue.getDescription().replace("<br />", " ").replace("<br/>", " "));
        dao.save(parameterValue);
    }

    public void editDesDescription(Long id, String des) {
        ParameterValue parameterValue = dao.findFirstById(id);
        parameterValue.setDescription(des);
        dao.save(parameterValue);
    }

    public void editCodeDescription(Long id, String code) {
        ParameterValue parameterValue = dao.findFirstById(id);
        parameterValue.setCode(code);
        dao.save(parameterValue);
    }

    @Override
    public Optional<ParameterValue> findById(Long ParameterValueId) {
        return dao.findById(ParameterValueId);
    }

    @Override
    public int getZone(String code) {
        ParameterValue zone = dao.findByCode("gmtTime");
        return Integer.parseInt(zone.getValue());
    }

    @Override
    public ParameterValueDTO.Info getInfoByCode(String code) {
        return modelMapper.map(dao.findByCode(code), ParameterValueDTO.Info.class);
    }

    @Override
    public String getTitleByValue(String pId) {
        Optional<ParameterValue> parameterValueOptional = dao.findFirstByValue(pId);
        if (parameterValueOptional.isPresent())
            return parameterValueOptional.get().getTitle();
        else
            return "";
    }

    @Override
    public Set<ParameterValue> getParameterValueByIds(Set<Long> ids) {
        Set<ParameterValue> parameterValueSet = new HashSet<>();
        if (!ids.isEmpty()) {
            parameterValueSet = dao.findAllById(ids).stream().collect(Collectors.toSet());
        }
        return parameterValueSet;
    }

    public void editParameterValue(String des, String code, Long id) {
        ParameterValue parameterValue = dao.findFirstById(id);
        parameterValue.setCode(code);
        parameterValue.setDescription(des);
        dao.save(parameterValue);
    }

    @Override
    public TotalResponse<ParameterValueDTO.Info> findAllByParameterCodes(List<String> parameterCodes) {
        List<ParameterValueDTO.Info> infos = new ArrayList<>();
        List<ParameterValue> parameterValues = dao.findAllByParameterCodes(parameterCodes);
        parameterValues.forEach(parameterValue -> {
            ParameterValueDTO.Info info = modelMapper.map(parameterValue, ParameterValueDTO.Info.class);
            info.setParameterTitle(parameterValue.getParameter().getTitle());
            infos.add(info);
        });
        GridResponse grid = new GridResponse<>(infos);
        grid.setTotalRows(infos.size());
        return new TotalResponse<>(grid);
    }
}
