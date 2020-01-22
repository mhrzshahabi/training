package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ParameterDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.model.Parameter;
import com.nicico.training.repository.ParameterDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class ParameterService extends BaseService<Parameter, Long, ParameterDTO.Info, ParameterDTO.Create, ParameterDTO.Update, ParameterDTO.Delete, ParameterDAO> {

    @Autowired
    ParameterService(ParameterDAO parameterDAO) {
        super(new Parameter(), parameterDAO);
    }

    @Transactional(readOnly = true)
    public TotalResponse<ParameterValueDTO.Info> getByCode(String code) {
        Optional<Parameter> pByCode = dao.findByCode(code);
        Parameter parameter = pByCode.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        List<ParameterValueDTO.Info> infos = modelMapper.map(parameter.getParameterValueList(), new TypeToken<List<ParameterValueDTO.Info>>() {
        }.getType());
        return new TotalResponse<>(new GridResponse<>(infos));
    }

    //////////////////////////////////////////config//////////////////////////////////////////

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<ParameterDTO.Config> allConfig(SearchDTO.SearchRq rq) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.equals);
        criteriaRq.setFieldName("type");
        criteriaRq.setValue("config");
        rq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<ParameterDTO.Config> configSearchRs = SearchUtil.search(dao, rq, e -> modelMapper.map(e, ParameterDTO.Config.class));
        for (ParameterDTO.Config config : configSearchRs.getList())
            config.getParameterValueList().sort(Comparator.comparing(ParameterValueDTO::getType));
        return configSearchRs;
    }
}
