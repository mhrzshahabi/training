package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCoursePassedNAReportViewDTO;
import com.nicico.training.dto.PresenceReportViewDTO;
import com.nicico.training.iservice.IPresenceReportViewService;
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
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/presence-report")
public class PresenceReportViewRestController {

    private final IPresenceReportViewService presenceReportViewService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<PersonnelCoursePassedNAReportViewDTO.Grid>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity<>(ISC.convertToIscRs(presenceReportViewService.search(searchRq, o -> modelMapper.map(o, PresenceReportViewDTO.Grid.class)), searchRq.getStartIndex()), HttpStatus.OK);
    }

}