package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;

public interface IViewTrainingPostService {
    SearchDTO.SearchRs<ViewTrainingPostDTO.Info> search(SearchDTO.SearchRq searchRq);
}
