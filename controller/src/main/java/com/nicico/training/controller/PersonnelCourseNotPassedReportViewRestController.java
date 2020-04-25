package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCourseNotPassedReportViewDTO;
import com.nicico.training.iservice.IPersonnelCourseNotPassedReportViewService;
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
import java.util.function.Function;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/personnel-course-not-passed-report")
public class PersonnelCourseNotPassedReportViewRestController {

    private final IPersonnelCourseNotPassedReportViewService personnelCourseNotPassedReportViewService;
    private final ModelMapper modelMapper;

    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<T> searchRs = personnelCourseNotPassedReportViewService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<PersonnelCourseNotPassedReportViewDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        return search(iscRq, p -> modelMapper.map(p, PersonnelCourseNotPassedReportViewDTO.Info.class));
    }

}