package com.nicico.training.controller;


import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewEvaluationCommentsDTO;
import com.nicico.training.iservice.IViewEvaluationPersonnelCommentsService;
import com.nicico.training.iservice.IViewEvaluationStudentCommentsService;
import com.nicico.training.iservice.IViewEvaluationTeacherCommentsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/evaluation/comments")
public class ViewEvaluationCommentsController {

    private final IViewEvaluationTeacherCommentsService viewEvaluationTeacherCommentsService;
    private final IViewEvaluationStudentCommentsService viewEvaluationStudentCommentsService;
    private final IViewEvaluationPersonnelCommentsService viewEvaluationPersonnelCommentsService;

    @Loggable
    @GetMapping(value = "/list/{type}")
    public ResponseEntity<ViewEvaluationCommentsDTO.ViewEvaluationCommentsDTOSpecRs> list(HttpServletRequest iscRq, @PathVariable String type) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ViewEvaluationCommentsDTO.Info> searchRs;
        switch (type){
            case("teacher"):{
                searchRs = viewEvaluationTeacherCommentsService.search(searchRq);
                break;
            }
            case("personnel"):{
                searchRs = viewEvaluationPersonnelCommentsService.search(searchRq);
                break;
            }
            case("student"):{
                searchRs = viewEvaluationStudentCommentsService.search(searchRq);
                break;
            }
            default:
                throw new IllegalStateException("Unexpected value: " + type);
        }
        ISC<ViewEvaluationCommentsDTO.Info> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity(infoISC, HttpStatus.OK);
    }


}
