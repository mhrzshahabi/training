package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ContinuousStatusReportViewDTO;

public interface IContinuousStatusReportViewService {
    SearchDTO.SearchRs<ContinuousStatusReportViewDTO.Grid> search(SearchDTO.SearchRq setCriteria);
}
