package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewEvaluationStaticalReportDTO;

public interface IViewEvaluationStaticalReportService {
    SearchDTO.SearchRs<ViewEvaluationStaticalReportDTO.Info> search(SearchDTO.SearchRq searchRq);
}
