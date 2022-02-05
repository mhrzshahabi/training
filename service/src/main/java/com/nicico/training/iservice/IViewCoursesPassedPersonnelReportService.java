package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewCoursesPassedPersonnelReportDTO;

public interface IViewCoursesPassedPersonnelReportService {
    SearchDTO.SearchRs<ViewCoursesPassedPersonnelReportDTO.Grid> search(SearchDTO.SearchRq searchRq);
}
