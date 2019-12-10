package com.nicico.training.iservice;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;

import java.io.Serializable;
import java.util.List;

public interface IBaseService<E, ID extends Serializable, INFO, CREATE, UPDATE, DELETE> {

    List<INFO> list();

    SearchDTO.SearchRs<INFO> search(SearchDTO.SearchRq rq);

    TotalResponse<INFO> search(NICICOCriteria request);
}
