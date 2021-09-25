package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedAssessmentGroupJobPromotionResponse;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.model.NeedAssessmentGroupResult;
import request.needsassessment.NeedAssessmentGroupJobPromotionRequestDto;
import request.needsassessment.NeedAssessmentGroupJobPromotionResponseDto;

import java.util.List;

public interface INeedsAssessmentReportsService {
    SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> searchForBpms(SearchDTO.SearchRq searchRq, String postCode, String objectType, String nationalCode,String personnelNumber);

    List<NeedAssessmentGroupJobPromotionResponse> createNeedAssessmentResultGroup(NeedAssessmentGroupJobPromotionRequestDto requestDto);

    NeedAssessmentGroupResult createNeedAssessmentGroupResult(byte[] blobFile,String username);

    NeedAssessmentGroupResult getNeedAssessmentGroupResult(String reference);

    List<NeedAssessmentGroupJobPromotionResponseDto.Info> getGroupJobPromotionListByUser(String userName);

}
