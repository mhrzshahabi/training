package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassSumByStatus;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ReportResponse;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.SpecRs;
import com.nicico.training.iservice.IClassCourseSumByFeaturesAndDepartmentReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/manHourStatisticsByClassCategoryReport")
public class ManHourStatisticsByClassCategoryReportRestController {

    private final IClassCourseSumByFeaturesAndDepartmentReportService service;

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ReportResponse> list(@RequestParam String fromDate,
                                               @RequestParam String toDate,
                                               @RequestParam List<String> omorCodes,
                                               @RequestParam List<String> moavenatCodes,
                                               @RequestParam List<String> mojtameCodes) {
        omorCodes = omorCodes.isEmpty() ? null : omorCodes;
        moavenatCodes = moavenatCodes.isEmpty() ? null : moavenatCodes;
        mojtameCodes = mojtameCodes.isEmpty() ? null : mojtameCodes;

        List<ClassSumByStatus> list = service.getSumReportByClassStatus(fromDate, toDate, mojtameCodes, moavenatCodes, omorCodes);

        SpecRs specRs = new SpecRs()
                .setDataSumByStatus(list)
                .setStartRow(0)
                .setTotalRows(list.size())
                .setEndRow(list.size());

        return new ResponseEntity<>(new ReportResponse().setResponse(specRs), HttpStatus.OK);
    }


}
