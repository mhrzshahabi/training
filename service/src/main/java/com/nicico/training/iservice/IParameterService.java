package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ParameterDTO;
import com.nicico.training.dto.ParameterValueDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

public interface IParameterService {

    @Transactional
    TotalResponse<ParameterValueDTO.Info> getByCode(String fel);

    List<ParameterDTO.Info> list();

    TotalResponse<ParameterDTO.Info> search(NICICOCriteria nicicoCriteria);

    ParameterDTO.Info create(ParameterDTO.Create create);

    ParameterDTO.Info update(Long id, ParameterDTO.Update update);

    ParameterDTO.Info delete(Long id);

    SearchDTO.SearchRs<ParameterDTO.Config> allConfig(SearchDTO.SearchRq searchRq);

    Map<Long, String> getMapByCode(String studentScoreState);

    List<ParameterValueDTO.TupleInfo> getValueListByCode(String code);

    Long findByCode(String gapCompetenceType);
}
