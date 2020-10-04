package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewCoursesPassedPersonnelReportDTO;
import com.nicico.training.service.ViewCoursesPassedPersonnelReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
@RequestMapping(value = "/api/view-courses-passed-personnel-report")
public class ViewCoursesPassedPersonnelReportController {
    private final ViewCoursesPassedPersonnelReportService iViewCoursesPassedPersonnelReportService;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<ViewCoursesPassedPersonnelReportDTO.Grid>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewCoursesPassedPersonnelReportDTO.Grid> searchRs = iViewCoursesPassedPersonnelReportService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
}