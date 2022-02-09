package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;

public interface IViewTrainingPostReportService {
    SearchDTO.SearchRs<ViewTrainingPostDTO.Report> search(SearchDTO.SearchRq searchRq);
}
