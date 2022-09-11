package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalChartDTO;

import java.util.List;

public interface IOperationalChartService {
    OperationalChartDTO.Info get(Long id);

    List<OperationalChartDTO.Info> list(Long complexId);

    OperationalChartDTO.Info create(OperationalChartDTO.Create request);

    OperationalChartDTO.Info update(Long id, OperationalChartDTO.Update request);

    OperationalChartDTO.Info removeOldParent(Long childId);

    void delete(Long id);

    SearchDTO.SearchRs<OperationalChartDTO.Info> search(SearchDTO.SearchRq request);

    OperationalChartDTO.Info addChild(Long parent_id, Long child_id);

    SearchDTO.SearchRs<OperationalChartDTO.Info> deepSearch(SearchDTO.SearchRq searchRq,Long complexId) throws NoSuchFieldException, IllegalAccessException;
}
