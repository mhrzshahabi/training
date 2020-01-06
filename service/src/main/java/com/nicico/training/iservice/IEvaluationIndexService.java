package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EvaluationIndexDTO;
import com.nicico.training.model.EvaluationIndex;

import java.util.List;

public interface IEvaluationIndexService {
    EvaluationIndexDTO.Info get(Long id);

    List<EvaluationIndexDTO.Info> list();

    EvaluationIndexDTO.Info create(EvaluationIndexDTO.Create request);

    EvaluationIndexDTO.Info update(Long id, EvaluationIndexDTO.Update request);

    void delete(Long id);

    void delete(EvaluationIndexDTO.Delete request);

    SearchDTO.SearchRs<EvaluationIndexDTO.Info> search(SearchDTO.SearchRq request);

    List<EvaluationIndex> getListByIds(List<Long> ids);

    //------------------------
}
