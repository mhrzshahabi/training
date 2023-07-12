package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTeacherQuestionCountDTO;
import com.nicico.training.iservice.IViewTeacherQuestionCountService;
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
@RequestMapping(value = "/api/teacher-question-count")
public class ViewTeacherQuestionCountReportController {

    private final IViewTeacherQuestionCountService viewTeacherQuestionCountService;

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ISC<ViewTeacherQuestionCountDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewTeacherQuestionCountDTO.Info> result = viewTeacherQuestionCountService.search(searchRq);
        ISC<ViewTeacherQuestionCountDTO.Info> response = ISC.convertToIscRs(result, searchRq.getStartIndex());
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

}
