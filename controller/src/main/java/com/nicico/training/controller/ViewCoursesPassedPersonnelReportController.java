package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewCoursesPassedPersonnelReportDTO;
import com.nicico.training.iservice.IViewCoursesPassedPersonnelReportService;
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
@RequestMapping(value = "/api/view-courses-passed-personnel-report")
public class ViewCoursesPassedPersonnelReportController {
    private final IViewCoursesPassedPersonnelReportService iViewCoursesPassedPersonnelReportService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<ViewCoursesPassedPersonnelReportDTO.Grid>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setSortBy("id");
        searchRq.setDistinct(true);
        return new ResponseEntity<>(ISC.convertToIscRs(iViewCoursesPassedPersonnelReportService.search(searchRq, o -> modelMapper.map(o, ViewCoursesPassedPersonnelReportDTO.Grid.class)), searchRq.getStartIndex()), HttpStatus.OK);
    }

}