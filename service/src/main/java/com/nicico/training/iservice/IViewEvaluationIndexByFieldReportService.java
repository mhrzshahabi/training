package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewClassDetailDTO;
import com.nicico.training.dto.ViewEvaluationIndexByFieldReportDTO;

public interface IViewEvaluationIndexByFieldReportService {
    SearchDTO.SearchRs<ViewEvaluationIndexByFieldReportDTO.Info> search(SearchDTO.SearchRq searchRq);
}
