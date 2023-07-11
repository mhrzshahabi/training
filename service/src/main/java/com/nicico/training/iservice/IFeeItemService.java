package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.FeeItemDTO;
import com.nicico.training.model.FeeItem;

import java.util.List;

public interface IFeeItemService {

    FeeItem get(Long id);

    FeeItemDTO.Info create(FeeItemDTO.Create request);

    FeeItem update(FeeItemDTO.Create update);

    SearchDTO.SearchRs<FeeItemDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException;

    void delete(Long id);

    List<FeeItemDTO.Info> getAllByClassId(Long classId);


}
