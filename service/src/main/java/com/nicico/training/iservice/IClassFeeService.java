package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassFeeDTO;
import com.nicico.training.dto.FeeItemDTO;
import com.nicico.training.model.ClassFee;
import com.nicico.training.model.FeeItem;

public interface IClassFeeService {

    ClassFee get(Long id);

    ClassFeeDTO.Info create(ClassFeeDTO.Create request);

    ClassFee update(ClassFeeDTO.Create update, Long id);

    SearchDTO.SearchRs<ClassFeeDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException;

    void delete(Long id);


}
