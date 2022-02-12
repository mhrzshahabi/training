package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPersonnelCourseNaReportDTO;

public interface IViewPersonnelCourseNaReportService {
    SearchDTO.SearchRs<ViewPersonnelCourseNaReportDTO.Grid> search(SearchDTO.SearchRq setCriteria);
}
