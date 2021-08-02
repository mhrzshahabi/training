package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewAssigneeNeedsAssessmentsReportDTO;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.dto.ViewUnAssigneeNeedsAssessmentsReportDTO;
import com.nicico.training.iservice.IViewAssigneeNeedsAssessmentsReport;
import com.nicico.training.iservice.IViewUnAssigneeNeedsAssessmentsReport;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/unAssigneeNeedsAssessmentsReport")
public class UnAssigneeNeedsAssessmentsReportController {

    private final IViewUnAssigneeNeedsAssessmentsReport iViewUnAssigneeNeedsAssessmentsReport;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewUnAssigneeNeedsAssessmentsReportDTO.TrainingNeedAssessmentDTOSpecRs>> iscListReport(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs result = iViewUnAssigneeNeedsAssessmentsReport.search(searchRq, o -> modelMapper.map(o, ViewUnAssigneeNeedsAssessmentsReportDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

}
