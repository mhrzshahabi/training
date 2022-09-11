package com.nicico.training.controller;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TimeInterferenceComprehensiveClassesDTO;
import com.nicico.training.iservice.ITimeInterferenceComprehensiveClassesReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/timeInterference-Comprehensive-Classes-report")
public class TimeInterferenceComprehensiveClassesReportController {
    private final ITimeInterferenceComprehensiveClassesReportService timeInterferenceComprehensiveClassesReportService;


    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<TimeInterferenceComprehensiveClassesDTO>> iscList(HttpServletRequest iscRq) throws Exception {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        List<SearchDTO.CriteriaRq> criteriaRqList = searchRq.getCriteria().getCriteria();

        String startDate = (String) criteriaRqList.stream().filter(item -> item.getFieldName().equals("startDate")).collect(Collectors.toList()).get(0).getValue().get(0);
        String endDate = (String) criteriaRqList.stream().filter(item -> item.getFieldName().equals("endDate")).collect(Collectors.toList()).get(0).getValue().get(0);

        List<TimeInterferenceComprehensiveClassesDTO> reportDTOList = timeInterferenceComprehensiveClassesReportService.list( startDate, endDate);

        ISC.Response<TimeInterferenceComprehensiveClassesDTO> response = new ISC.Response<>();
        response.setData(reportDTOList)
                .setStartRow(0)
                .setEndRow(reportDTOList.size())
                .setTotalRows(reportDTOList.size());
        ISC<TimeInterferenceComprehensiveClassesDTO> dataISC = new ISC<>(response);
        return new ResponseEntity<>(dataISC, HttpStatus.OK);

    }
}