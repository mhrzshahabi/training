package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewReactionEvaluationFormulaReportDTO;

public interface IViewReactionEvaluationFormulaReportService {

    SearchDTO.SearchRs<ViewReactionEvaluationFormulaReportDTO.Info> search(SearchDTO.SearchRq searchRq);

    String getPercentReaction(Long classId);
}
