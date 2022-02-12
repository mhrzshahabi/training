package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewUnfinishedClassesReportDTO;

public interface IViewUnfinishedClassesReportService {
    SearchDTO.SearchRs<ViewUnfinishedClassesReportDTO.Grid> search(SearchDTO.SearchRq searchRq);
}
