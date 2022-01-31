package com.nicico.training.iservice;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.ParameterValueDTO;
import org.springframework.transaction.annotation.Transactional;


public interface IParameterService {

    @Transactional
    TotalResponse<ParameterValueDTO.Info> getByCode(String fel);
}
