package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.iservice.ITermService;
import com.nicico.training.service.ClassCourseSumByFeaturesAndDepartmentReportService;
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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/manHourStatisticsPerDepartmentReport")
public class ManHourStatisticsPerDepartmentReportRestController {

    private final ITermService termService;
    private final ModelMapper modelMapper;
    private final ClassCourseSumByFeaturesAndDepartmentReportService classCourseSumByFeaturesAndDepartmentReportService;

    @Loggable
    @GetMapping
    public ResponseEntity<ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassCourseSumByFeaturesAndDepartmentReportDTOSpecRs> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        String startDate = null;
        String endDate = null;
        String complexCode = null;
        String moavenatCode = null;
        String omorCode = null;
        List<String> classStatusList = null;
        List<String> yearList = null;
        List<Long> termIdList = null;
        String termId = null;
        if (searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                if (criterion.getFieldName().equals("mojtameCode")) {
                    complexCode = criterion.getValue().toString().replace("[", "").replace("]", "");
                }
                if (criterion.getFieldName().equals("ccpAssistant")) {
                    moavenatCode = criterion.getValue().toString().replace("[", "").replace("]", "");
                }
                if (criterion.getFieldName().equals("ccpAffairs")) {
                    omorCode = criterion.getValue().toString().replace("[", "").replace("]", "");
                }
                if (criterion.getFieldName().equals("startDate")) {
                    startDate = criterion.getValue().toString().replace("[", "").replace("]", "");

                }
                if (criterion.getFieldName().equals("endDate")) {
                    endDate = criterion.getValue().toString().replace("[", "").replace("]", "");
                }
                if (criterion.getFieldName().equals("year")) {
                    yearList = new ArrayList<String>(Arrays.asList(criterion.getValue().toString().replace("[", "").replace("]", "").split(", ")));
                }
                if (criterion.getFieldName().equals("termId")) {
                    termId = modelMapper.map(criterion.getValue().toString(), String.class);
                    String[] termList = termId.substring(1, termId.length() - 1).split(",");
                    termIdList = Arrays.stream(termList).map(x -> Long.parseLong(x)).collect(Collectors.toList());
                }
                if (criterion.getFieldName().equals("classStatus")) {
                    classStatusList = new ArrayList<String>(Arrays.asList(criterion.getValue().toString().replace("[", "").replace("]", "").split(", ")));
                }
            }
        }

        if (startDate == null) {
            if (termId != null) {
                TermDTO info = termService.get(termIdList.get(0));
                startDate = info.getStartDate().trim();
                endDate = info.getEndDate().trim();
            } else if (yearList != null) {
                startDate = yearList.get(0) + "/01/01";
                endDate = yearList.get((yearList.size()) - 1) + "/12/29";
            }
        }

        List<ClassCourseSumByFeaturesAndDepartmentReportDTO> finalList;
        if (omorCode != null) {
            finalList = classCourseSumByFeaturesAndDepartmentReportService.getReport(startDate, endDate, null, null, omorCode, classStatusList);
        } else if (moavenatCode != null) {
            finalList = classCourseSumByFeaturesAndDepartmentReportService.getReport(startDate, endDate, null, moavenatCode, null, classStatusList);
        } else if (complexCode != null) {
            finalList = classCourseSumByFeaturesAndDepartmentReportService.getReport(startDate, endDate, complexCode, null, null, classStatusList);
        } else {
            finalList = classCourseSumByFeaturesAndDepartmentReportService.getReport(startDate, endDate, null, null, null, classStatusList);
        }

        final ClassCourseSumByFeaturesAndDepartmentReportDTO.SpecRs specResponse = new ClassCourseSumByFeaturesAndDepartmentReportDTO.SpecRs();
        final ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassCourseSumByFeaturesAndDepartmentReportDTOSpecRs specRs = new ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassCourseSumByFeaturesAndDepartmentReportDTOSpecRs();

        specResponse.setData(finalList)
                .setStartRow(0)
                .setEndRow(finalList.size())
                .setTotalRows(finalList.size());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}