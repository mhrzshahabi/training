package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewCoursesEvaluationStatisticalReportDTO;

public interface IViewCoursesEvaluationStatisticalReportService {
    SearchDTO.SearchRs<ViewCoursesEvaluationStatisticalReportDTO> search(SearchDTO.SearchRq searchRq);
}
