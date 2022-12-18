package com.nicico.training.iservice;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;

import java.io.Serializable;
import java.util.List;

public interface IBaseService<E, ID extends Serializable, INFO, CREATE, UPDATE, DELETE> {

    List<INFO> list();

    SearchDTO.SearchRs<INFO> search(SearchDTO.SearchRq rq);

    List<INFO> mapEntityToInfo(List<E> eList);

    TotalResponse<INFO> search(NICICOCriteria rq);

    INFO create(CREATE rq);

    INFO update(ID id, UPDATE rq);

    INFO delete(ID id);

    Boolean isExist(ID id);

    E get(ID id);

    SearchDTO.SearchRs<INFO> excelSearch(SearchDTO.SearchRq rq);
}
