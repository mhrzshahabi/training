package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPostGroupDTO;

public interface IViewPostGroupService {
    SearchDTO.SearchRs<ViewPostGroupDTO.Info> search(SearchDTO.SearchRq searchRq);
}
