package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.GroupBy;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.SpecRs;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ReportResponse;
import com.nicico.training.iservice.IClassCourseSumByFeaturesAndDepartmentReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/manHourStatisticsByClassFeatureReport")
public class ManHourStatisticsByClassFeatureReportRestController {

    private final IClassCourseSumByFeaturesAndDepartmentReportService service;

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ReportResponse> list(@RequestParam String fromDate,
                                               @RequestParam String toDate,
                                               @RequestParam String omorCode,
                                               @RequestParam String moavenatCode,
                                               @RequestParam String mojtameCode,
                                               @RequestParam List<GroupBy> groupBys) {
        omorCode = omorCode.isEmpty() ? null : omorCode;
        moavenatCode = moavenatCode.isEmpty() ? null : moavenatCode;
        mojtameCode = mojtameCode.isEmpty() ? null : mojtameCode;

        List<ClassCourseSumByFeaturesAndDepartmentReportDTO> result = service.getReport(fromDate, toDate, mojtameCode, moavenatCode, omorCode, groupBys.get(0));

        SpecRs specRs = new SpecRs()
                .setData(result)
                .setStartRow(0)
                .setEndRow(result.size())
                .setTotalRows(result.size());
        return new ResponseEntity<>(new ReportResponse().setResponse(specRs), HttpStatus.OK);
    }


}
