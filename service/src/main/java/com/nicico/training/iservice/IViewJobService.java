package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewjobDTO;

public interface IViewJobService {
    SearchDTO.SearchRs<ViewjobDTO.Info> search(SearchDTO.SearchRq searchRq);
}
