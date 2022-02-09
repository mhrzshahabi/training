package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewActivePersonnelInRegisteringDTO;

public interface IViewActivePersonnelInRegisteringService {

    SearchDTO.SearchRs<ViewActivePersonnelInRegisteringDTO.Info> search(SearchDTO.SearchRq request);
}
