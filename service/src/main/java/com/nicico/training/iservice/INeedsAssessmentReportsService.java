package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedAssessmentGroupJobPromotionResponse;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import request.needsassessment.NeedAssessmentGroupJobPromotionRequestDto;

import java.util.List;

public interface INeedsAssessmentReportsService {
    SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> searchForBpms(SearchDTO.SearchRq searchRq, String postCode, String objectType, String nationalCode,String personnelNumber);

    List<NeedAssessmentGroupJobPromotionResponse> createNeedAssessmentResultGroup(NeedAssessmentGroupJobPromotionRequestDto requestDto);
}
