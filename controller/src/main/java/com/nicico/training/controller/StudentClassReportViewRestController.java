package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.StudentClassReportViewDTO;
import com.nicico.training.iservice.IStudentClassReportViewService;
import com.nicico.training.service.StudentClassReportViewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;
import java.util.function.Function;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/student-class-report-view")
public class StudentClassReportViewRestController {

    private final IStudentClassReportViewService iStudentClassReportViewService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;

    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<T> searchRs = iStudentClassReportViewService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<StudentClassReportViewDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        return search(iscRq, c -> modelMapper.map(c, StudentClassReportViewDTO.Info.class));
    }

    @GetMapping("/all-field-values")
    public ResponseEntity<ISC<StudentClassReportViewDTO.FieldValue>> findAllValuesOfOneFieldFromPersonnel(@RequestParam String fieldName) throws IOException {
        return new ResponseEntity<>(ISC.convertToIscRs(iStudentClassReportViewService.findAllValuesOfOneFieldFromPersonnel(fieldName), 0), HttpStatus.OK);
    }

    @GetMapping("/all-courses")
    public ResponseEntity<StudentClassReportViewDTO.StudentClassReportSpecRs> findAllCourses() throws IOException {
        List<StudentClassReportViewDTO.CourseInfoSCRV> list = iStudentClassReportViewService.findCourses();
        final StudentClassReportViewDTO.SpecRs specResponse = new StudentClassReportViewDTO.SpecRs();
        final StudentClassReportViewDTO.StudentClassReportSpecRs specRs = new StudentClassReportViewDTO.StudentClassReportSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping("/{reportType}")
    public ResponseEntity<StudentClassReportViewDTO.StudentClassReportSpecRs> findAllStatisticalReport(@PathVariable String reportType) {
        List<StudentClassReportViewDTO.Info> list = iStudentClassReportViewService.findAllStatisticalReportFilter(reportType);

        final StudentClassReportViewDTO.SpecRs specResponse = new StudentClassReportViewDTO.SpecRs();
        final StudentClassReportViewDTO.StudentClassReportSpecRs specRs = new StudentClassReportViewDTO.StudentClassReportSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//	@PreAuthorize("hasAuthority('r_course')")
    public ResponseEntity<StudentClassReportViewDTO.StudentClassReportSpecRs> list(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                       @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<StudentClassReportViewDTO.Info> response = iStudentClassReportViewService.search(request);
        final StudentClassReportViewDTO.SpecRs specResponse = new StudentClassReportViewDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final StudentClassReportViewDTO.StudentClassReportSpecRs specRs = new StudentClassReportViewDTO.StudentClassReportSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}