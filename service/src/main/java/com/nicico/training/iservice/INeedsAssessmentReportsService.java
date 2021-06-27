package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;

public interface INeedsAssessmentReportsService {
    SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> searchForBpms(SearchDTO.SearchRq searchRq, String postCode, String objectType, String nationalCode,String personnelNumber);
}
