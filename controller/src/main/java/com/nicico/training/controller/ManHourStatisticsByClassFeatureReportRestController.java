package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassFeatures;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.GroupBy;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.SpecRs;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ReportResponse;
import com.nicico.training.iservice.IClassCourseSumByFeaturesAndDepartmentReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
                                               @RequestParam List<String> omorCodes,
                                               @RequestParam List<String> moavenatCodes,
                                               @RequestParam List<String> mojtameCodes,
                                               @RequestParam List<GroupBy> groupBys) {
        omorCodes = omorCodes.isEmpty() ? null : omorCodes;
        moavenatCodes = moavenatCodes.isEmpty() ? null : moavenatCodes;
        mojtameCodes = mojtameCodes.isEmpty() ? null : mojtameCodes;

        Map<GroupBy, List<ClassFeatures>> allData = new HashMap<>();

        for (int i = 0; i < groupBys.size(); i++) {
            List<ClassFeatures> list = new ArrayList<>();
            service.getReportForMultipleDepartment(fromDate, toDate, mojtameCodes, moavenatCodes, omorCodes, groupBys.get(i)).forEach(dto -> list.add(dto));
            allData.put(groupBys.get(i), list);
        }
        SpecRs specRs = new SpecRs()
                .setAllData(allData);
        return new ResponseEntity<>(new ReportResponse().setResponse(specRs), HttpStatus.OK);
    }


}
