package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.ParameterValueDTO;

import java.util.List;

public interface IParameterValueService {
    List<ParameterValueDTO.Info> list();

    TotalResponse<ParameterValueDTO.Info> search(NICICOCriteria nicicoCriteria);

    ParameterValueDTO.Info checkAndCreate(ParameterValueDTO.Create create);

    ParameterValueDTO.Info update(Long id, ParameterValueDTO.Update update);

    ParameterValueDTO.Info delete(Long id);

    List<ParameterValueDTO.Info> editConfigList(ParameterValueDTO.ConfigUpdate[] rq);

    Long getId(String code);

    TotalResponse<ParameterValueDTO> getMessages(String type, String target);

    void editParameterValue(String value, String title, String des, String code, Long id);

    void editDescription(Long id);

    void editDesDescription(Long id, String des);

    void editCodeDescription(Long id, String code);
}
