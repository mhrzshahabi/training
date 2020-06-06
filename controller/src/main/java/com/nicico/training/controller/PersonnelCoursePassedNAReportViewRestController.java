package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCoursePassedNAReportViewDTO;
import com.nicico.training.iservice.IPersonnelCoursePassedNAReportViewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.function.Function;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/personnel-course-na-report")
public class PersonnelCoursePassedNAReportViewRestController {

    private final IPersonnelCoursePassedNAReportViewService personnelCoursePassedNAReportViewService;
    private final ModelMapper modelMapper;

    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<T> searchRs = personnelCoursePassedNAReportViewService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<PersonnelCoursePassedNAReportViewDTO.Grid>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity<>(ISC.convertToIscRs(personnelCoursePassedNAReportViewService.searchCourseList(searchRq), startRow), HttpStatus.OK);
    }

    @GetMapping("/personnel-list")
    public ResponseEntity<ISC<PersonnelCoursePassedNAReportViewDTO.NotPassedPersonnel>> notPassedPersonnelList(HttpServletRequest iscRq) throws IOException {
        return search(iscRq, e -> modelMapper.map(e, PersonnelCoursePassedNAReportViewDTO.NotPassedPersonnel.class));
    }

    @Loggable
    @GetMapping("/minList")
    public ResponseEntity<ISC<PersonnelCoursePassedNAReportViewDTO.MinInfo>> minlist(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity<>(ISC.convertToIscRs(personnelCoursePassedNAReportViewService.searchMinList(searchRq), startRow), HttpStatus.OK);
    }

}