package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IViewCalenderHeadlinesService;
import com.nicico.training.iservice.IViewCalenderOfMainGoalsService;
import com.nicico.training.iservice.IViewCalenderPrerequisiteService;
import com.nicico.training.iservice.IViewCalenderSessionsService;
import com.nicico.training.model.ViewCalenderSessions;
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

    private final IViewCalenderOfMainGoalsService iViewCalenderOfMainGoalsService;
    private final IViewCalenderPrerequisiteService iViewCalenderPrerequisiteService;
    private final IViewCalenderSessionsService iViewCalenderSessionsService;
    private final IViewCalenderHeadlinesService iViewCalenderHeadlinesService;
    private final ModelMapper modelMapper;



    @GetMapping(value = "/mainGoals/iscList")
   public   ResponseEntity<ISC<ViewCalenderMainGoalsDTO.ViewCalenderMainGoalsSpecRs>> iscListMainGoals(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result = iViewCalenderOfMainGoalsService.search(searchRq, o -> modelMapper.map(o, ViewCalenderMainGoalsDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/prerequisite/iscList")
    public   ResponseEntity<ISC<ViewCalenderPrerequisiteDTO.ViewCalenderPrerequisiteSpecRs>> iscListPrerequisite(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result = iViewCalenderPrerequisiteService.search(searchRq, o -> modelMapper.map(o, ViewCalenderPrerequisiteDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/headlines/iscList")
    public   ResponseEntity<ISC<ViewCalenderHeadlinesDTO.ViewCalenderHeadlinesSpecRs>> iscListHeadlines(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result = iViewCalenderHeadlinesService.search(searchRq, o -> modelMapper.map(o, ViewCalenderHeadlinesDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @GetMapping(value = "/sessions/iscList")
    public   ResponseEntity<ISC<ViewCalenderSessionsDTO.ViewCalenderSessionsSpecRs>> iscListSessions(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs result = iViewCalenderSessionsService.search(searchRq, o -> modelMapper.map(o, ViewCalenderSessionsDTO.Info.class));
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

}
