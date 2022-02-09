package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewPersonnelTrainingStatusReportDTO;

public interface IViewPersonnelTrainingStatusReportService {
    SearchDTO.SearchRs<ViewPersonnelTrainingStatusReportDTO.Info> search(SearchDTO.SearchRq searchRq);
}
