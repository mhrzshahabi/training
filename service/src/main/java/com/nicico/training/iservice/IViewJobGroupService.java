package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewJobGroupDTO;

public interface IViewJobGroupService {
    SearchDTO.SearchRs<ViewJobGroupDTO.Info> search(SearchDTO.SearchRq searchRq);
}
