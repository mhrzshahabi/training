package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewClassDetailDTO;

public interface IViewClassDetailService {
    SearchDTO.SearchRs<ViewClassDetailDTO.Info> search(SearchDTO.SearchRq searchRq);
}
