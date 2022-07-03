package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalChartDTO;

import java.util.List;

public interface IOperationalChartService {
    OperationalChartDTO.Info get(Long id);

    List<OperationalChartDTO.Info> list();

    OperationalChartDTO.Info create(OperationalChartDTO.Create request);

//    OperationalChartDTO.Info addChild(OperationalChartDTO.Create request);

    OperationalChartDTO.Info update(Long id, OperationalChartDTO.Update request);

    OperationalChartDTO.Info updateParent(Long id,Long parentId, OperationalChartDTO.Update request);

    void delete(Long id);

    void delete(OperationalChartDTO.Delete request);

    SearchDTO.SearchRs<OperationalChartDTO.Info> search(SearchDTO.SearchRq request);

    OperationalChartDTO.Info addChild(Long parent_id, Long child_id);
}
