package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewCoursesEvaluationReportDTO;

public interface IViewCoursesEvaluationReportService {
    SearchDTO.SearchRs<ViewCoursesEvaluationReportDTO.Info> search(SearchDTO.SearchRq searchRq);
}
