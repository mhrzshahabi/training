package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalUnitDTO;

public interface IEvaluation {

    SearchDTO.SearchRs<OperationalUnitDTO.Info> search(SearchDTO.SearchRq request);
}
