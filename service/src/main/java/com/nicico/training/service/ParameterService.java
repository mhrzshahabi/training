package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ParameterDTO;
import com.nicico.training.model.Parameter;
import com.nicico.training.repository.ParameterDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class ParameterService extends BaseService<Parameter, Long, ParameterDTO.Info, ParameterDTO.Create, ParameterDTO.Update, ParameterDTO.Delete, ParameterDAO> {

    @Autowired
    ParameterService(ParameterDAO parameterDAO) {
        super(new Parameter(), parameterDAO);
    }

    //////////////////////////////////////////config//////////////////////////////////////////

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<ParameterDTO.Config> allConfig(SearchDTO.SearchRq rq) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.equals);
        criteriaRq.setFieldName("description");
        criteriaRq.setValue("config");
        rq.setCriteria(criteriaRq);

        return SearchUtil.search(dao, rq, e -> modelMapper.map(e, ParameterDTO.Config.class));
    }
}
