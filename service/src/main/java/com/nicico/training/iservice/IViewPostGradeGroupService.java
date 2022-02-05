package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPostGradeGroupDTO;

public interface IViewPostGradeGroupService {
    SearchDTO.SearchRs<ViewPostGradeGroupDTO.Info> search(SearchDTO.SearchRq searchRq);
}
