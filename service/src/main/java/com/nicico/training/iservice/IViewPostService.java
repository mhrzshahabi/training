package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPostDTO;

public interface IViewPostService {
    SearchDTO.SearchRs<ViewPostDTO.Info> search(SearchDTO.SearchRq searchRq);
}
