package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewCalenderMainGoalsDTO;
import com.nicico.training.dto.ViewEffectiveCoursesReportDTO;
import com.nicico.training.iservice.IViewCalenderOfMainGoalsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
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
@RequestMapping(value = "/api/view-educational-calender-report")
public class ViewEducationalCalenderReportController {
    @Autowired
    private final IViewCalenderOfMainGoalsService iViewCalenderOfMainGoalsService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/mainGoals/iscList")
    public ResponseEntity<ISC<ViewCalenderMainGoalsDTO.ViewCalenderMainGoalsSpecRs>> iscListReport(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result = iViewCalenderOfMainGoalsService.search(searchRq, o -> modelMapper.map(o, ViewCalenderMainGoalsDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }
}
