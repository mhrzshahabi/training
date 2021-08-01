package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewAssigneeNeedsAssessmentsReportDTO;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.iservice.IViewAssigneeNeedsAssessmentsReport;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/assigneeNeedsAssessmentsReport")
public class assigneeNeedsAssessmentsReport {

    private final IViewAssigneeNeedsAssessmentsReport iViewAssigneeNeedsAssessmentsReport;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<ViewNeedAssessmentInRangeDTO.TrainingNeedAssessmentDTOSpecRs>> iscListReport(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs result = iViewAssigneeNeedsAssessmentsReport.search(searchRq, o -> modelMapper.map(o, ViewAssigneeNeedsAssessmentsReportDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

}
