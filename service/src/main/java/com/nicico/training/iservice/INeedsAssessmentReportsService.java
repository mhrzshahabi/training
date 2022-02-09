package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.NeedAssessmentGroupResult;
import com.nicico.training.model.NeedsAssessment;
import org.springframework.transaction.annotation.Transactional;
import request.needsassessment.NeedAssessmentGroupJobPromotionRequestDto;
import request.needsassessment.NeedAssessmentGroupJobPromotionResponseDto;

import java.util.List;

public interface INeedsAssessmentReportsService {

    SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> searchForBpms(SearchDTO.SearchRq searchRq, String postCode, String objectType, String nationalCode,String personnelNumber);

    List<NeedAssessmentGroupJobPromotionResponse> createNeedAssessmentResultGroup(NeedAssessmentGroupJobPromotionRequestDto requestDto);

    NeedAssessmentGroupResult createNeedAssessmentGroupResult(byte[] blobFile,String username);

    NeedAssessmentGroupResult getNeedAssessmentGroupResult(String reference);

    List<NeedAssessmentGroupJobPromotionResponseDto.Info> getGroupJobPromotionListByUser(String userName);

    List<NeedsAssessmentReportsDTO.ReportInfo> getCourseList(Long objectId, String objectType, Long personnelId);

    List<NeedsAssessment> getNeedsAssessmentListForBpms(String postCode, String objectType);

    List<NeedsAssessmentReportsDTO.ReportInfo> getCourseListForBpms( String postCode, String objectType, String nationalCode,String personnelNumber);

    void delete(Long id);

    NeedAssessmentReportUserObj findNeedAssessmentByNationalCode(String nationalCode);
    NAReportForLMSResponseDTO findNeedAssessmentByNationalCodeAndPostCode(String nationalCode, String postCode);

    NAReportForLMSResponseDTO findNeedAssessmentForLMSByNationalCode(String nationalCode);

    SearchDTO.SearchRs<NeedsAssessmentReportsDTO.CourseNAS> getCourseNA(SearchDTO.SearchRq searchRq, Long courseId, Boolean passedReport);
    SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> search(SearchDTO.SearchRq searchRq, Long objectId, String objectType, Long personnelId);
}
