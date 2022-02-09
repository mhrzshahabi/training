package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPostGradeDTO;

public interface IViewPostGradeService {
    SearchDTO.SearchRs<ViewPostGradeDTO.Info> search(SearchDTO.SearchRq searchRq);
}
