package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.StudentClassReportViewDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.repository.StudentClassReportViewDAO;
import com.nicico.training.service.ClassAlarmService;
import com.nicico.training.service.StudentClassReportViewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.*;
import java.util.function.Function;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/student-class-report-view")
public class StudentClassReportViewRestController {

    private final StudentClassReportViewService studentClassReportViewService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;

    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<T> searchRs = studentClassReportViewService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<ISC<StudentClassReportViewDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        return search(iscRq, c -> modelMapper.map(c, StudentClassReportViewDTO.Info.class));
    }

    @Loggable
    @GetMapping
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<List<StudentClassReportViewDTO.Info>> list() {
        return new ResponseEntity<>(studentClassReportViewService.list(), HttpStatus.OK);
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
        SearchDTO.SearchRs<StudentClassReportViewDTO.Info> response = studentClassReportViewService.search(request);
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