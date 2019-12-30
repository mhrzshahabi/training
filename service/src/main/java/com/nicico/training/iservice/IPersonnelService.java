package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelDTO;

import java.util.List;

public interface IPersonnelService {

    List<PersonnelDTO.Info> list();

    SearchDTO.SearchRs<PersonnelDTO.Info> search(SearchDTO.SearchRq rq);

    TotalResponse<PersonnelDTO.Info> search(NICICOCriteria request);

}
